print("test govee deice Configyre111000")
local _core = require("core")
local _logger = require("logging")
local TIMER_ID = "philips_lamps_update"

local params = ... or {}
local setting_id

if _G.govee_smartleds_rgbic == nil then --create if not detected
    local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/create_device"),
        { device_name = "Govee SmartLEDs RGBIC" })
    if not success then
        _logger.error("Failed to create device, error: " .. errmsg)
    end
end

--detecting ip address setting
local setting_ids = _core.get_setting_ids_by_device_id(_G.govee_smartleds_rgbic)
if setting_ids ~= nil then
    for _, _setting_id in pairs(setting_ids) do
        print("_core.get_setting_ids_by_device_id(_G.govee_smartleds_rgbic)")
        print(_,_setting_id)
        if _core.get_setting(_setting_id).info.name == "device_ip" then
            setting_id = _setting_id
        end
    end
end

if params.ip and string.match(params.ip, "^%d+%.%d+%.%d+%.%d+$") then

    if not setting_id then
        local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/settings/device_ip"),
            { device_id = _G.govee_smartleds_rgbic, value = params.ip })
        if not success then
            _logger.error("Failed to set setting: device_ip, error: " .. errmsg)
            return
        end
    end

        local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/set_setting_value"), {
            setting_id = setting_id,
            value = params.ip
        })
        if not success then
            _logger.error("Failed to set setting: device_ip, error: " .. errmsg)
            return
        end

    --     --start dhcp monitoring
    --     loadfile("HUB:ezlo.govee/scripts/handlers/dhcp")({ action = "start" })

    --     --start update timer
    --     local _timer = require("timer")
    --     if not _timer.exists(TIMER_ID) then
    --         _timer.set_interval_with_id(60000, TIMER_ID, "HUB:ezlo.govee/scripts/http_send_lamps_update_request",
    --             { ip = params.ip })
    --     end

    --     --DHCP listening on
    --     loadfile("HUB:ezlo.govee/scripts/init") {
    --         action = "start_init",
    --         device_id = _G.govee_smartleds_rgbic
    --     }
    --     loadfile("HUB:ezlo.govee/scripts/handlers/dhcp")({ action = "start" })
    --     return
end

local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/autodetection"))
if not success then
    _logger.error("Failed to set setting: device_ip, error: " .. errmsg)
end

_logger.info("In configure ENDENDENDENDENDENDENDEND")