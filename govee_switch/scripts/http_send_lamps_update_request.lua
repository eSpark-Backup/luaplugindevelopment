local _logger = require("logging")
local _http = require("http")
local _storage = require("storage")

local params = ... or {}

if not params.ip or params.ip == "0.0.0.0" then
    _logger.error("Empty device ip. Set the device ip, current is: " .. params.ip)
    return
end

local username = _storage.get_string("username")

if username then
    _logger.debug("Start sending update request with user_id:" .. username .. " to device: " .. params.ip)

    local success, msg = pcall(_http.request, {
        skip_security = true,
        url = "http://" .. params.ip .. "/api/" .. username .. "/lights",
        handler = "HUB:ezlo.govee/scripts/handlers/http_lamps_list_update_handler",
        headers = {
            ["Expect"] = "",
            ["Transfer-Encoding"] = ""
        }
    })

    if not success then
        _logger.error("Failed to make HTTP request: " .. msg)
        return false
    end
end
