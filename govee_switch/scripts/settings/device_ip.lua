local _logger = require("logging")
local _core = require("core")
local _storage = require("storage")
local _timer = require("timer")

--local TIMER_ID = "philips_lamps_update"
local SETTING_NAME = "device_ip"

local function updateChildDevices(device_id, ip, script)
    local setup = loadfile("HUB:ezlo.govee/scripts/" .. script)
    local success, errmsg = pcall(setup, { ip = ip })

    if not success then
        _logger.error("Failed to setup device with new ip: " .. ip .. ", error: " .. errmsg)
    end
end

local function CreateOrUpdateSetting(device_id, setting_id, value)

    value = value or "0.0.0.0"

    if setting_id then
        -- ip validation
        if not string.match(value, "^%d+%.%d+%.%d+%.%d+$") then
            _logger.error("Incorrect ip. Cannot continue.")
            return
        end

        _logger.debug("Update setting value: " .. SETTING_NAME .. " = " .. tostring(value))
        _core.set_setting_value(setting_id, value, "synced")

        -- if _storage.get_string("username") then
        --     updateChildDevices(device_id, value, "http_send_lamps_update_request")
        -- else
        --     updateChildDevices(device_id, value, "get_username")
        -- end

        -- _timer.reset_arguments(TIMER_ID, { ip = value })
        return
    end

    local _setting_utils = require("HUB:ezlo.govee/scripts/settings/setting_utils")

    local setting = {
        label = {
            text = "Change device IP"
        },
        description = {
            text = "Change device IP"
        },
        value_type = "string",
        value = value,
        status = "synced",
        has_setter = true,
        info = {
            name = SETTING_NAME
        }
    }
    _setting_utils.CreateSetting(device_id, SETTING_NAME, setting)
    updateChildDevices(device_id, value, "get_username")
end

--------------------------------------------------------------------------------

local params = ... or {}

local setting_ids = _core.get_setting_ids_by_device_id(params.device_id)
if setting_ids ~= nil then
    for _, setting_id in pairs(setting_ids) do
        if _core.get_setting(setting_id).info.name == "device_ip" then
            params.setting_id = setting_id
        end
    end
end

CreateOrUpdateSetting(params.device_id, params.setting_id, params.value)
