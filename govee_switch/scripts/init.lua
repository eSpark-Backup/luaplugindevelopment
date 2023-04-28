print("test govee deice Initialize000")
local _logger = require("logging")
local _core = require("core")
local _storage = require("storage")

local function UpdateMacAddress(device_id)
    local mac_storage = _storage.get_string("philips_hue_mac")

    if mac_storage ~= nil then
        return
    end

    _logger.info("Try to find MAC address for device " .. device_id)

    local fh = io.open("/proc/net/arp")
    if not fh then
        _logger.error("Failed to open /proc/net/arp")
        return
    end

    local mac
    local ip
    --getting ip from setting called device_ip
    for _, setting_id in pairs(_core.get_setting_ids_by_device_id(device_id)) do
        if _core.get_setting(setting_id).info.name == "device_ip" then
            ip = _core.get_setting(setting_id).value
        end
    end

    for line in fh:lines("l") do
        if line:find("^" .. ip:gsub("%.", "%%.") .. "%s") then
            mac = line:match("(%S+)%s+%S+%s+%S+$")
        end
    end

    fh:close()

    if not mac then
        _logger.error("MAC address not found")
        return
    end

    _logger.info("Found MAC address: " .. (mac or "nil"))

    _storage.set_string("philips_hue_mac", mac)
end

--------------------------------------------------------------------------------

local params = ... or {}

if params.action == "start_init" then
    _logger.info("Start initializing device " .. params.device_id)
    UpdateMacAddress(params.device_id)

else
    _logger.error("Action not supported for init script")
end
