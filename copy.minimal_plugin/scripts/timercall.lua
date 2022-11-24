local logging = require("logging")
local timer = require ("timer")

logging.info("The timercall started")


http.request{
    			url = numeric.url,
    			handler = 'HUB:copy.minimal_plugin/scripts/http_handler'
    			--[[ handler = 'HUB:copy.minimal_plugin/scripts/timercall' ]]
    		}

count = count + 1
--[[ logging.info("counter in working")
 ]]
 logging.info("counter in working")
if (count >= n1) then
    timer.cancel(timer_id)
    logging.info("timer has been cancelled")
end

logging.info("Cancelled !") 