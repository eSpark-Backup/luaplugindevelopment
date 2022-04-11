local _logger = require("logging")


local function UpdateMacAddress (device_id)
    local _storage = require("storage")
    local dsc_storage = _storage.get_table("dsc")

    if dsc_storage[device_id].mac ~= nil then
        return
    end

    _logger.info("Try to find MAC address for device " .. device_id)

    local fh = io.open("/proc/net/arp")
    if not fh then
        _logger.error("Failed to open /proc/net/arp")
        return
    end

    local mac

    for line in fh:lines("l") do
        if line:find("^" .. dsc_storage[device_id].ip:gsub("%.", "%%.") .. "%s") then
            mac = line:match("(%S+)%s+%S+%s+%S+$")
        end
    end

    fh:close()

    if not mac then
        _logger.error("MAC address not found")
        return
    end

    _logger.info("Found MAC address: " .. (mac or "nil"))

    dsc_storage[device_id].mac = mac
    _storage.set_table("dsc", dsc_storage)
end


local function GetStatusReport (device_id)
    _logger.info("Get status report")

    local wait = loadfile("HUB:espark_sample/scripts/handlers/network") {
        action = "send",
        device_id = device_id,
        command = _G.dsc.commands.STATUS_REPORT
    }

    if not wait then
        _logger.error("Failed to send status report command")
        return
    end
end

--------------------------------------------------------------------------------

local params = ... or {}

if params.action == "start_init" then
    local device_id = params.device_id

    if _G.dsc[device_id] and _G.dsc[device_id].handle then
        return GetStatusReport(params.device_id)
    end

    _logger.info("Start initializing device " .. params.device_id)

    local _storage = require("storage")
    local dsc_storage = _storage.get_table("dsc")

    local wait = loadfile("HUB:espark_sample/scripts/handlers/network") {
            action = "connect",
            device_id = params.device_id,
            ip = dsc_storage[device_id].ip,
            port = dsc_storage[device_id].port,
            password = dsc_storage[device_id].password
        }

    if not wait then
        local _utils = require("HUB:espark_sample/scripts/modules/utils")
        _utils.UpdateReachableState(device_id, false)
    end

elseif params.action == "get_status_report" then
    GetStatusReport(params.device_id)

elseif params.connected ~= nil then
    local _utils = require("HUB:espark_sample/scripts/modules/utils")
    _utils.UpdateReachableState(params.device_id, params.connected)

elseif params.session_established ~= nil then
    if params.session_established then
        _logger.info("Session established")
        UpdateMacAddress(params.device_id)
        GetStatusReport(params.device_id)
    else
        _logger.error("Incorrect password")
        _logger.debug("TODO: mark device as broken")
    end

else
    _logger.error("Action not supported for init script")
end
