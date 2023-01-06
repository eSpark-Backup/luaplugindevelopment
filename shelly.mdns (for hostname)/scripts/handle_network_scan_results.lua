local logging = require("logging")
logging.info("Device Searching Started")

local params = ... or {}
    
for k,v in pairs(params) do
   logging.info("    Keys000===:" .. tostring(k)  .. "   values000==="   .. tostring(v) )
   if (type(v) == "table") then
      logging.info("    Keys111===:" .. tostring(k)  .. "   values111==="   .. tostring(v) )
      for s,t in pairs(v) do
         logging.info("    Keys123===:" .. tostring(s)  .. "   values123==="   .. tostring(t) )
         if (type(t) == "table") then
            logging.info("    Keys222===:" .. tostring(s)  .. "   values222==="   .. tostring(t) )
            for w,x in pairs(t) do
               logging.info("    Keys333===:" .. tostring(w)  .. "   values333==="   .. tostring(x) )
            end            
         end
      end
      
   end   

end
logging.info("  Search Ends Here" )
return 'OK'


