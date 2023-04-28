local params = ...

local _logger = require("logging")
local _core = require("core")
local _storage = require("storage")
local _json = require("json")
local _timer = require("timer")
local TIMER_ID = "philips_lamps_update"

if params.event == "http_connection_closed" then
    if params.data.reason.code == 6 then
        local ip = string.sub(params.data.url, 8, 20)
        _core.send_ui_broadcast({
            status = "error",
            message = "Failed to connect to device with ip: " .. ip
        })

        local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/autodetection"))
        if not success then
            _logger.error("Failed to set setting: device_ip, error: " .. errmsg)
        end

        if _timer.exists(TIMER_ID) then
            _timer.cancel(TIMER_ID)
        end
    end

    return
end

if params.event == "http_data_received" then
    local response = _json.decode(params.data.data)

    for _, value in pairs(response) do
        if value.success then
            if value.success.username then
                _storage.set_string("username", value.success.username)

                local ip
                --getting ip from setting of device
                for _, setting_id in pairs(_core.get_setting_ids_by_device_id(_G.govee_smartleds_rgbic)) do
                    if _core.get_setting(setting_id).info.name == "device_ip" then
                        ip = _core.get_setting(setting_id).value
                    end
                end

                local setup = loadfile("HUB:ezlo.govee/scripts/setup")
                local success, errmsg = pcall(setup, { ip = ip })

                if not success then
                    _logger.error("Failed to setup device with new ip: " .. ip .. ", error: " .. errmsg)
                end
            end

        elseif value.error and value.error.type == 101 and not _storage.get_string("username") then
            _core.send_ui_broadcast({
                status = "info",
                message = "Press the button on your Govee SmartLEDs RGBIC and then push 'configure' button"
            })
            _logger.debug("Error 101, Its ok, just push the button and repeat")

        end
    end

end


loadfile("HUB:ezlo.govee/scripts/init") {
    action = "start_init",
    device_id = _G.govee_smartleds_rgbic
}

loadfile("HUB:ezlo.govee/scripts/handlers/dhcp")({ action = "start" })
