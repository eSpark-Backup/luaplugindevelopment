local _logger = require("logging")


local function StartDhcpMonitoring()
    if _G.dsc.dhcp_subscription_id then
        _logger.debug("A subscription for DHCP messages already exists, won't start another")
        return
    end

    local _network = require("network")

    _logger.info("Start listening to DHCP 'request' messages")
    local success, dhcp_subscription_id = pcall(_network.start_listening_dhcp, "HUB:espark_sample/scripts/handlers/dhcp", { "request" })

    if not success then
        _logger.error("Failed to start DHCP monitoring: " .. (dhcp_subscription_id or ""))
        return
    end

    _G.dsc.dhcp_subscription_id = dhcp_subscription_id
end

--------------------------------------------------------------------------------

local params = ... or {}

if params.action == "start" then
    return StartDhcpMonitoring()
end

if not params.event or params.event ~= "dhcp_request" then
    _logger.warning("Unhandled event: " .. (params.event or "nil"))
    return
end

if not params.data.client_address then
    _logger.debug("Ignoring DHCP request because it's missing the MAC address")
    return
end

if not params.data.params or not params.data.params.ip then
    _logger.debug("Ignoring DHCP request because it's missing the IP address")
    return
end

local mac = params.data.client_address:lower()
_logger.debug("DHCP event: mac = " .. mac .. ", ip = " .. params.data.params.ip)

local _storage = require("storage")
local dsc_storage = _storage.get_table("dsc")

for device_id, device_storage in pairs(dsc_storage) do
    if type(device_storage) == "table" and device_storage.mac == mac then
        _logger.info("Device " .. device_id .. " IP n: " .. params.data.params.ip .. ", o: " .. (dsc_storage[device_id].ip or "nil"))

        local reinit = false

        if dsc_storage[device_id].ip ~= params.data.params.ip then
            _logger.info("Update stored IP")

            dsc_storage[device_id].ip = params.data.params.ip
            _storage.set_table("dsc", dsc_storage)

            reinit = true
        end

        local _core = require("core")

        if reinit == true or not _core.get_device(device_id).reachable then
            loadfile("HUB:espark_sample/scripts/init") {
                action = "start_init",
                device_id = device_id
            }
        end

        return
    end
end
