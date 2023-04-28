-- scripts from govee startup starts
isSocketName = false
isNetworkHandleExist = false
totalPacketsReceived=0
govee_devices_ip = {}
local devices_ondashboard = false
-- scripts from govee startup Ends


local _logger = require("logging")
local _core = require("core")
--local _network = require("network")
local TIMER_ID = "philips_lamps_update"

_logger.info("**************************")
 print("test govee deice start")

-- _network.subscribe events not studied 
 -- _network.subscribe("HUB:ezlo.govee/scripts/autodetection")
--print("test govee deice start1")

_G.philips_hue = { reuests = {} }
local devices = _core.get_devices()

if devices then
    print("number of devices found=")
    print(#devices)

    for _, device in ipairs(devices) do
        --print(_, device,device.name,device.id)

            if device.name == "Govee SmartLEDs RGBIC" then
                _logger.debug("***************Device Found")
            _logger.info("Govee SmartLEDs RGBIC exists, starting timer")
            devices_ondashboard =true
            --_G.govee_smartleds_rgbic = device.id
            local setting_ids = _core.get_setting_ids_by_device_id(device.id)
            local ip

            -- Search for ip in stored in setting
            if setting_ids ~= nil then
                for _, setting_id in pairs(setting_ids) do
                    if _core.get_setting(setting_id).info.name == "device_ip" then
                        ip = _core.get_setting(setting_id).value
                    end
                end
            end

            -- Method on philips notrequired--DHCP listening on if we have ip of Govee SmartLEDs RGBIC
            -- if ip then
            --     loadfile("HUB:ezlo.govee/scripts/handlers/dhcp")({ action = "start" })
            --     local _timer = require("timer")
            --     if not _timer.exists(TIMER_ID) then
            --         _timer.set_interval_with_id(60000, TIMER_ID,
            --             "HUB:ezlo.govee/scripts/http_send_lamps_update_request", { ip = ip })
            --     end
            -- end
        end
    end
end


print("********Before calling discover_govee")

local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/discover_govee"))
if not success then
    _logger.error("No devices on the network found! " .. errmsg)
end


print("********After calling discover_govee")

