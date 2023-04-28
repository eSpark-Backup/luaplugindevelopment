print("test govee deice setup000")
local _logger = require("logging")
local _http = require("http")
local _storage = require("storage")

local params = ... or {}

if not params.ip or params.ip == "" then
    _logger.error("Empty device ip. Cannot continue")
    return
end

-- local username = _storage.get_string("username")
-- if username then
--     _logger.debug("Start sending request to device with user_id:" .. username)
--     local success, msg = pcall(_http.request, {
--         skip_security = true,
--         url = "http://" .. params.ip .. "/api/" .. username .. "/lights",
--         handler = "HUB:ezlo.govee/scripts/handlers/http_setup_handler",
--         data = '',
--         type = "GET",
--         headers = {
--             ["Expect"] = "",
--             ["Transfer-Encoding"] = ""
--         }
--     })

--     if not success then
--         _logger.error("Failed to make HTTP request: " .. msg)
--         return false
--     end
-- else
--     _logger.error("No username")
-- end
