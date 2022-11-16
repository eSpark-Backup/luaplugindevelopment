local logging = require ("logging")
local http = require ("http")

logging.info("The plugin has been started successfully")


--[[ 

http.request{
	url = 'https://webhook.site/28f14d74-c210-48d3-8477-5ed86a5fdf66',
	handler = 'HUB:minhttp.log_test/scripts/http_handler',
}



 ]]