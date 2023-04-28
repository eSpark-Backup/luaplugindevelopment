local _core = require("core")
local _logger = require("logging")

local _M = {}

function _M.CreateSetting(device_id, setting_name, setting_obj)

    local setting_ids = _core.get_setting_ids_by_device_id(device_id) or {}

    for _, setting_id in pairs(setting_ids) do
        local setting = _core.get_setting(setting_id)

        if setting.info.name == setting_name then
            return setting_id
        end
    end

    _logger.debug("Create setting: " .. setting_name .. " = " .. tostring(setting_obj.value))

    setting_obj.device_id = device_id

    local new_setting_id = _core.add_setting(setting_obj)

    if new_setting_id then
        _logger.debug("Created setting ID: " .. new_setting_id)
    else
        _logger.error("Failed to create setting")
    end

    return new_setting_id
end

return _M
