local logging = require ("logging")
local http = require ("http")

logging.info("The plugin has been started successfully")

http.request{
	url = 'www.google.com',
	handler = 'HUB:ezlo.log_test/scripts/http_handler',
}