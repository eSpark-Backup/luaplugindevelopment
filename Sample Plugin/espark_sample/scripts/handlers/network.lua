local _core = require("core")
local _logger = require("logging")
local _network = require("network")
local _timer = require("timer")

local THIS_SCRIPT = "HUB:espark_sample/scripts/handlers/network"


local function CleanUp (device_id)
    if _G.dsc[device_id] then
        if _G.dsc[device_id].handle then
            _G.dsc.connections[_G.dsc[device_id].handle] = nil
        end
        _G.dsc[device_id] = nil
    end
end


local function Connect (device_id, ip, port, password)
    _logger.info("Connect to " .. ip .. ":" .. port)
    local success, handle = pcall(_network.connect, { ip = ip, port = port, connection_type = "TCP" })

    if not success then
        _logger.error("Failed to create TCP connection: " .. handle)
        return false
    end

    _G.dsc.connections[handle] = {
        device_id = device_id,
    }
    _G.dsc[device_id] = {
        handle = handle,
        password = password
    }

    return true
end


local function Connected (device_id)
    local callback_script
    if device_id == _G.dsc.const.TEST_DEV_ID then
        callback_script = "HUB:espark_sample/scripts/setup"
    else
        callback_script = "HUB:espark_sample/scripts/init"
    end

    loadfile(callback_script) {
        device_id = device_id,
        connected = true
    }
end


local function FailedToConnect (device_id)
    local callback_script
    if device_id == _G.dsc.const.TEST_DEV_ID then
        callback_script = "HUB:espark_sample/scripts/setup"
    else
        callback_script = "HUB:espark_sample/scripts/init"
    end

    loadfile(callback_script) {
        device_id = device_id,
        connected = false
    }

    CleanUp(device_id)
end


local function Disconnect (device_id)
    if not _G.dsc[device_id].handle then
        -- The connection is already closed, and the cleanup is already done.
        return
    end

    local success, errmsg = pcall(_network.close, _G.dsc[device_id].handle)

    if not success then
        _logger.error("Failed to close connection with handle '" .. _G.dsc[device_id].handle .. "': " .. errmsg)
        return
    end

    CleanUp(device_id)
end


local function ConnectionClosed (device_id)
    if device_id ~= _G.dsc.const.TEST_DEV_ID then
        local _utils = require("HUB:espark_sample/scripts/modules/utils")
        _utils.UpdateReachableState(device_id, false)
    end

    CleanUp(device_id)

    local _storage = require("storage")
    local dsc_storage = _storage.get_table("dsc") or {}

    Connect(device_id, dsc_storage[device_id].ip, dsc_storage[device_id].port, dsc_storage[device_id].password)
end


local function GetData (device_id, handle)
    local message = _network.receive(handle)
    _logger.debug("Received: " .. tostring(message))

    if not message or message == "" then
        return
    end

    if device_id ~= _G.dsc.const.TEST_DEV_ID then
        local timer_id = _G.dsc.const.TPI_COMM_ACK_WATCHDOG_TIMER .. "_" .. device_id

        if _timer.exists(timer_id) then
            _timer.cancel(timer_id)
        end

        if not _core.get_device(device_id).reachable then
            local _utils = require("HUB:espark_sample/scripts/modules/utils")
            _utils.UpdateReachableState(device_id, true)
        end
    end

    loadfile("HUB:espark_sample/scripts/process_received_data") {
        device_id = device_id,
        message = message
    }
end


local function SendData (device_id, command, data)
    data = data or ""

    local _utils = require("HUB:espark_sample/scripts/modules/utils")
    local checksum = _utils.CalculateChecksum(command, data)

    local message = command .. data .. checksum .. "\r\n"

    _logger.debug("Send: " .. message)
    local success, errmsg = pcall(_network.send, _G.dsc[device_id].handle, message)

    if not success then
        _logger.error("Failed to send data: " .. errmsg)
        return false
    end

    if device_id ~= _G.dsc.const.TEST_DEV_ID then
        _G.dsc.last_command = {
            device_id = device_id,
            command = command,
            data = data
        }

        -- Wait at most 4 seconds for the acknowledge for this command.
        -- If the acknowledge doesn't come, the connection is probably dead,
        -- so we have to mark the device as unreachable.
        _timer.set_timeout_with_id(4000, _G.dsc.const.TPI_COMM_ACK_WATCHDOG_TIMER .. "_" .. device_id, THIS_SCRIPT, _G.dsc.last_command)
    end

    return true
end


local function TpiCommandAcknowledgeTimeout (device_id, command, data)
    local _utils = require("HUB:espark_sample/scripts/modules/utils")

    _logger.error("Failed to receive acknowledge for command: " .. command .. data)

    _utils.UpdateReachableState(device_id, false)
end


local function HandleEvent (event_data)
    _logger.debug(event_data.event.io_activity_type)

    local device_id = _G.dsc.connections[event_data.event.handle].device_id

    if event_data.event.io_activity_type == "CONNECTED" then
        Connected(device_id)

    elseif event_data.event.io_activity_type == "FAIL_TO_CONNECT" then
        FailedToConnect(device_id)

    elseif event_data.event.io_activity_type == "IN" then
        GetData(device_id, event_data.event.handle)

    elseif event_data.event.io_activity_type == "CONNECTION_CLOSED" then
        ConnectionClosed(device_id)
    end
end

--------------------------------------------------------------------------------

local params = ... or {}

if params.event then
    -- params = {
    --   event (string)
    --   data = {
    --     event_type
    --     event = {
    --       handle (int)
    --       io_activity_type (string)
    --     }
    --   }
    -- }
    HandleEvent(params.data)
elseif params.action == "subscribe" then
    _network.subscribe(THIS_SCRIPT)
elseif params.action == "connect" then
    return Connect(params.device_id, params.ip, params.port, params.password)
elseif params.action == "disconnect" then
    return Disconnect(params.device_id)
elseif params.action == "send" then
    return SendData(params.device_id, params.command, params.data)
elseif params.timerId:find(_G.dsc.const.TPI_COMM_ACK_WATCHDOG_TIMER) then
    return TpiCommandAcknowledgeTimeout(params.device_id, params.command, params.data)
end
