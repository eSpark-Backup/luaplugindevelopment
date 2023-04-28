local _core = require("core")
local _logger = require("logging")

_logger.debug("Philips HUE set_setting_value")

local params = ... or {}

if not params.setting_id then
    _logger.error("Invalid setting id. Setting id: " .. tostring(params.setting_id))
    return
end

local setting = _core.get_setting(params.setting_id)

if not setting then
    _logger.error("Invalid setting id. Setting id: " .. params.setting_id)

    return
end

local setting_script = loadfile("HUB:ezlo.govee/scripts/settings/" .. setting.info.name)

if not setting_script then
    _logger.error("Failed to load script for setting " .. setting.info.name)
end

local success, errmsg = pcall(setting_script, {
    device_id = setting.device_id,
    setting_id = setting.id,
    value = params.value
})

if not success then
    _logger.error("Failed to set setting: " .. setting.info.name .. ", error: " .. errmsg)
end
