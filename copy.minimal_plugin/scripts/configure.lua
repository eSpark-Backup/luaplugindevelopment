--[[ local logging = require("logging")

local args = ... or {}
	
	if type(args.url) == "string" and args.url ~= "" then
		http.request{
			url = args.url,
			handler = 'HUB:copy.minimal_plugin/scripts/http_handler'
		}
	else
		logging.info("The plugin has been configured After HTTP call successfully")
		return
	end ]]
	local logging = require("logging")
	local http = require ("http") 
	local timer = require("timer") 
	n1 = 0
	count = 0
   
   
   logging.info("The plugin has been configured before HTTP call successfully")
   
   

------------------------------------User Input String ---------------------------------------------------



	 --i have called in configure.lua
	--  local args = ... or {}
	
	-- if type(args.url) == "string" and args.url ~= "" then
	-- 	http.request{
	-- 		url = args.url,
	-- 		handler = 'HUB:copy.minimal_plugin/scripts/http_handler'
	-- 		--[[ handler = 'HUB:copy.minimal_plugin/scripts/timercall' ]]
	-- 	}

	-- else
	-- 	logging.info("The plugin has been configured After HTTP call successfully")
	-- 	return
	-- end

	-- logging.info("After user input")



------------------------------------User Input Digits ---------------------------------------------------



    numeric = ... or {}
	   
	   if type(numeric.num) == "number" and numeric.num ~= "" then
		   n1 = numeric.num
	   else
		   logging.info("No Sonos API Running on the URL specified")
		   return
	   end  
		if(n1 == 0) then
		   return
		end
   

    logging.info("arg_value"..numeric.num)

   timer_id = timer.set_interval(5000, "HUB:copy.minimal_plugin/scripts/timercall", {arg_name = "250"}) 
   
   
   logging.info("The plugin has been configured After HTTP call successfully")
   
   
   -------------------------- For Loop String Numeric Connection-------------------------------------------------


--    --[[ i = numeric.num ]]
--    for i=1, #numeric do
-- 	 --i have called in configure.lua
-- 	 numeric = ... or {}
	
-- 	if type(numeric.url) == "string" and numeric.url ~= "" then
-- 		http.request{
-- 			url = numeric.url,
-- 			handler = 'HUB:copy.minimal_plugin/scripts/http_handler'
-- 			--[[ handler = 'HUB:copy.minimal_plugin/scripts/timercall' ]]
-- 		}

-- 	else
-- 		logging.info("The plugin has been configured After HTTP call successfully")
-- 		return
-- 	end

-- 	logging.info("After user input")

--    end

--    print(numeric)
