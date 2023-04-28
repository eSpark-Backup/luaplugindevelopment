print("test govee deice autodetection000")
local _logger = require("logging")
local _http = require("http")
local params = ... or {}

_logger.debug("***************Start autodetection hue devices, sending http request to the Hue Cloud")
_logger.debug("***************Start autodetection hue devices, sending http request to the Hue Cloud")
_logger.debug("***************Start autodetection hue devices, sending http request to the Hue Cloud")
print(params)

-- local success, msg = pcall(_http.request, {
--     skip_security = true,
--     url = "https://discovery.meethue.com/",
--     handler = "HUB:ezlo.govee/scripts/handlers/http_autodetection_handler",
--     data = '',
--     type = "GET",
--     headers = {
--         ["Expect"] = "",
--         ["Transfer-Encoding"] = ""
--     }
-- })

-- if not success then
--     _logger.error("Failed to make HTTP request: " .. msg)
--     return false
-- end
