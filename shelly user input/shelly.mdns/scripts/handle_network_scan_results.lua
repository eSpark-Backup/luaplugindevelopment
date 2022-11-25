


local logging = require("logging")
logging.info("Device Searching Started")





local params = ... or {}
logging.info("Callback =   "..#params)
    
for k,v in pairs(params) do
   if (type(v) == "table") then
      for s,t in pairs(v) do
         logging.info("    TableDetails:         " .. tostring(s)  .. "     "   .. tostring(t) )
      end                        
   end
   
   logging.info("  Keys:  " .. tostring(k) .. "   Values=   " .. tostring(v) )

end

return 'OK'


