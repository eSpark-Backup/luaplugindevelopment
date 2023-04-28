local _logger = require("logging")
local _http = require("http")

local params = ... or {}

if not params.ip or params.ip == "" then
    _logger.error("Empty device ip. Cannot create device")
    return
end

local data = '{"devicetype":"Ezlo_HUE_plugin"}'
local content_length = #data

_logger.debug("Start sending request to device with ip:" .. params.ip)
local success, msg = pcall(_http.request, {
    skip_security = true,
    url = "http://" .. params.ip .. "/api",
    handler = "HUB:ezlo.govee/scripts/handlers/http_get_username_handler",
    data = data,
    type = "POST",
    content_type = "application/json",
    content_length = content_length,
    headers = {
        ["Expect"] = "",
        ["Transfer-Encoding"] = ""
    }
})

if not success then
    _logger.error("Failed to make HTTP request: " .. msg)
end
