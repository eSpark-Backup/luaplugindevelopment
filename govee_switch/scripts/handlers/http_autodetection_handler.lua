local params = ...

local _logger = require("logging")
local _core = require("core")
local _json = require("json")

--local TIMER_ID = "philips_lamps_update"

-- if params.event == "http_connection_closed" then
--     if params.data.reason.code == 2 then
--         _core.send_ui_broadcast({
--             status = "error",
--             message = "Govee SmartLEDs RGBIC not found"
--         })
--     end
--     return
-- end

-- if params.event == "http_data_received" then
--     local response = _json.decode(params.data.data)
--     if response[1] then

        local setting_id
        local setting_ids = _core.get_setting_ids_by_device_id(_G.govee_smartleds_rgbic)
        if setting_ids ~= nil then
            for _, _setting_id in pairs(setting_ids) do
                if _core.get_setting(_setting_id).info.name == "device_ip" then
                    setting_id = _setting_id
                end
            end
        end

        if not setting_ids then
            local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/settings/device_ip"), {
                device_id = _G.govee_smartleds_rgbic,
                value = response[1].internalipaddress
            })
            if not success then
                _logger.error("Failed to create setting: device_ip, error: " .. errmsg)
            end
        else
            local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/set_setting_value"), {
                setting_id = setting_id,
                value = response[1].internalipaddress
            })
            if not success then
                _logger.error("Failed to set setting: device_ip, error: " .. errmsg)
            end
        end

        local _timer = require("timer")
        if not _timer.exists(TIMER_ID) then
            _timer.set_interval_with_id(60000, TIMER_ID, "HUB:ezlo.govee/scripts/http_send_lamps_update_request",
                { ip = response[1].internalipaddress })
        end


--     end
-- end
