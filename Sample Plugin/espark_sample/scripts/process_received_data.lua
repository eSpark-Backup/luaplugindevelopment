local _core = require("core")
local _logger = require("logging")
local _timer = require("timer")
local _utils = require("HUB:espark_sample/scripts/modules/utils")

local g_device_id


local function GetDevice (device_info_id)
    for _, device in ipairs(_core.get_devices() or {}) do
        if device.parent_device_id == g_device_id and (device.info or {}).id == device_info_id then
            return device
        end
    end
end


local function GetItem (device_id, item_name)
    for _, item in ipairs(_core.get_items_by_device_id(device_id) or {}) do
        if item.name == item_name then
            return item
        end
    end
end


local function GetItemFromLastCommandData()
    local partition = _G.dsc.last_command.data:match("^%d") or ""
    local device = GetDevice("partition_" .. partition)
    if device then
        return GetItem(device.id, "zones_status")
    end
end


local function TpiCommandAcknowledge (data)
    if g_device_id == _G.dsc.const.TEST_DEV_ID then
        return
    end

    -- We received ackowledge for a command we didn't send, so we'll ignore it.
    if data ~= _G.dsc.last_command.command then
        return
    end

    local timer_id = _G.dsc.const.TPI_COMM_ACK_WATCHDOG_TIMER .. "_" .. g_device_id

    if _timer.exists(timer_id) then
        _timer.cancel(timer_id)
    end

    if data == _G.dsc.commands.ARM_AWAY then
        local item = GetItemFromLastCommandData()
        if item then
            _core.update_item_value(item.id, "away")
        end

    elseif data == _G.dsc.commands.ARM_STAY then
        local item = GetItemFromLastCommandData()
        if item then
            _core.update_item_value(item.id, "stay")
        end

    elseif data == _G.dsc.commands.DISARM then
        local item = GetItemFromLastCommandData()
        if item then
            _core.update_item_value(item.id, "disarmed")
        end
    end
end


local function TpiLoginInteraction (data)
    if data == "3" then -- Request for password
        _logger.info("Send login command")

        local wait = loadfile("HUB:espark_sample/scripts/handlers/network") {
                action = "send",
                device_id = g_device_id,
                command = _G.dsc.commands.NETWORK_LOGIN,
                data = _G.dsc[g_device_id].password
            }

        if not wait then
            _logger.error("Failed to send login command")

            local callback_script
            if g_device_id == _G.dsc.const.TEST_DEV_ID then
                callback_script = "HUB:espark_sample/scripts/setup"
            else
                callback_script = "HUB:espark_sample/scripts/init"
            end

            loadfile(callback_script) {
                device_id = g_device_id,
                session_established = false
            }
        end

    else
        -- data == 2 -- Timeout waiting for password, session not established.
        -- data == 1 -- The password was correct, session established.
        -- data == 0 -- The password was incorrect, session not established.

        local callback_script
        if g_device_id == _G.dsc.const.TEST_DEV_ID then
            callback_script = "HUB:espark_sample/scripts/setup"
        else
            callback_script = "HUB:espark_sample/scripts/init"
        end

        loadfile(callback_script) {
            device_id = g_device_id,
            session_established = (data == "1")
        }
    end
end


local function TpiZoneAlarm (data)
    local device = GetDevice("zone_" .. data)

    if device then
        _logger.info("Zone " .. data .. " alarm")
        local item = GetItem(device.id, "motion")
        _core.update_item_value(item.id, true)
    end
end


local function TpiZoneAlarmRestore (data)
    local device = GetDevice("zone_" .. data)

    if device then
        _logger.info("Zone " .. data .. " alarm restored")
        local item = GetItem(device.id, "motion")
        _core.update_item_value(item.id, false)
    end
end


local function TpiZoneOpen (data)
    local device = GetDevice("zone_" .. data)

    if device then
        _logger.info("Zone " .. data .. " is open")
        _core.update_ready_state(device.id, false)
    end
end


local function TpiZoneRestored (data)
    local device = GetDevice("zone_" .. data)

    if device then
        _logger.info("Zone " .. data .. " is restored")
        _core.update_ready_state(device.id, true)
    end
end


local function TpiPartitionReady (data)
    local device = GetDevice("partition_" .. data)
    if device then
        _logger.info("Partition " .. data .. " is ready")
        _core.update_ready_state(device.id, true)
    end
end


local function TpiPartitionNotReady (data)
    local device = GetDevice("partition_" .. data)

    if device then
        _logger.info("Partition " .. data .. " is busy")
        _core.update_ready_state(device.id, false)
    end
end


local function TpiPartitionArmed (data)
    local partition, mode = data:match("(%d)(%d)")

    local device = GetDevice("partition_" .. partition)

    if device then
        local MODE_MAP = {
            ["0"] = "away",
            ["1"] = "stay",
            ["2"] = "away",
            ["3"] = "stay"
        }

        _logger.info("Partition " .. partition .. " is armed in '" .. MODE_MAP[mode] .. "' mode")

        local item = GetItem(device.id, "zones_status")
        _core.update_item_value(item.id, MODE_MAP[mode])
    end
end


local function TpiPartitionDisarmed (data)
    local device = GetDevice("partition_" .. data)

    if device then
        _logger.info("Partition " .. data .. " is disarmed")

        local item = GetItem(device.id, "zones_status")
        _core.update_item_value(item.id, "disarmed")
    end
end

--------------------------------------------------------------------------------

local params = ... or {}

g_device_id = params.device_id

for message in params.message:gmatch("[^\r\n]+") do
    local command, data, checksum = message:match("^(%d%d%d)(.*)(%x%x)$")
    _logger.debug("Command: " .. tostring(command) .. ", data: " .. tostring(data) .. ", checksum: " .. tostring(checksum))

    if not command or not data or not checksum then
        _logger.warning("Invalid message: incorrect format")
        -- TODO: to be decided
        return
    end

    if _utils.CalculateChecksum(command, data) ~= string.upper(checksum) then
        _logger.warning("Invalid message: checksum mismatch")
        -- TODO: to be decided
        return
    end

    if command == "500" then
        TpiCommandAcknowledge(data)
    elseif command == "505" then
        TpiLoginInteraction(data)
    elseif command == "601" then
        TpiZoneAlarm(data)
    elseif command == "602" then
        TpiZoneAlarmRestore(data)
    elseif command == "609" then
        TpiZoneOpen(data)
    elseif command == "610" then
        TpiZoneRestored(data)
    elseif command == "650" or command == "653" then
        TpiPartitionReady(data)
    elseif command == "651" or command == "673" then
        TpiPartitionNotReady(data)
    elseif command == "652" then
        TpiPartitionArmed(data)
    elseif command == "655" then
        TpiPartitionDisarmed(data)
    end
end
