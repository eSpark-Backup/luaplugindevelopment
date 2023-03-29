local logging = require ("logging")
local http = require ("http")

logging.info("The plugin has been started successfully")

http.request{
	url = 'http://webhook.site/87fc6eb7-82e5-439d-ac3c-74d24fe9448e',
	handler = 'HUB:minhttpwaqar1.log_test/scripts/http_handler',
}

