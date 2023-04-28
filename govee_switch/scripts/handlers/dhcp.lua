local _storage = require("storage")
local _logger = require("logging")
local _core = require("core")
--local _network = require("network")

local params = ... or {}

-- if params.action == "start" then
--     if _G.philips_dhcp_subscription_id then
--         return
--     end
    
--     _logger.info("Start listening to DHCP 'request' messages")
--     local success, dhcp_subscription_id = pcall(_network.start_listening_dhcp,
--         "HUB:ezlo.govee/scripts/handlers/dhcp", { "request" })
--     _G.philips_dhcp_subscription_id = dhcp_subscription_id

--     if not success then
--         _logger.error("Failed to start DHCP monitoring: " .. (dhcp_subscription_id or ""))
--     end

--     return
-- end

-- if not params.event or params.event ~= "dhcp_request" then
--     _logger.warning("Unhandled event: " .. (params.event or "nil"))
--     return
-- end

-- if not params.data.client_address then
--     _logger.debug("Ignoring DHCP request because it's missing the MAC address")
--     return
-- end

-- if not params.data.params or not params.data.params.ip then
--     _logger.debug("Ignoring DHCP request because it's missing the IP address")
--     return
-- end

-- local mac = params.data.client_address:lower()
-- _logger.debug("DHCP event: mac = " .. mac .. ", ip = " .. params.data.params.ip)

-- if _storage.get_string("philips_hue_mac") == mac then
--     local setting
--     local device_id = _G.govee_smartleds_rgbic
--     local setting_ids = _core.get_setting_ids_by_device_id(device_id)
--     if setting_ids ~= nil then
--         for _, _setting_id in pairs(setting_ids) do
--             if _core.get_setting(_setting_id).info.name == "device_ip" then
--                 setting = _core.get_setting(_setting_id)
--             end
--         end
--     end

--     _logger.info("Device " .. device_id .. " IP new: " .. params.data.params.ip .. ", old: " .. setting.value)

--     local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/settings/device_ip"), {
--         device_id = device_id,
--         setting_id = setting.id,
--         value = params.data.params.ip
--     })

--     if not success then
--         _logger.error("Failed to set setting: " .. setting.info.name .. ", error: " .. errmsg)
--     end

--     return
-- end
