local logging = require("logging")
--logging.info("Device Searching Started")
--table.insert(targetedDeviceList, data)
local params = ... or {}

 -- handle events of a scanner
 local data = params.data
 if data.status ~= "finished" then


      for k,v in pairs(params) do
         totalPacketsReceived = totalPacketsReceived+1
         if (type(v) == "table") then
         --logging.info("    Found1=:" .. tostring(k)  .. "   with values="   .. tostring(v) )
            for s,t in pairs(v) do
               print(tostring(s)  .. " = "   .. tostring(t) )
            
            if(t) then
               if (type(s) == "string" and string.find(string.lower('host_name'), string.lower(s))) then
                  for l, m in ipairs(devicesSearch) do
                     myvar1,myvar2 = string.find(string.lower(t), string.lower(m))
                     if myvar1 then
                        --logging.info(l..' - '..m,myvar1,myvar2)
                        table.insert(targetedDeviceList, "******** Mdns Device Found = "..tostring(m))
                     end
                  end

               end
            end
               if (type(t) == "table") then
                  print(tostring(s)  .. " = "   .. tostring(t) )
                  for w,x in pairs(t) do
                     print("    Found4=:" .. tostring(w)  .. "   with values="   .. tostring(x) )
                  end            
               end
            end      
         end   
      end

   else -- data searching finished
               logging.info(" Shelly Search Ends Here" )
               logging.info("*********************************************************************************")
               logging.info("*****************Shelly Devices Searching Ended Here*************************")
               logging.info("*********************************************************************************")

               print("************************** Summary *************************************")
               print("Total UDP/Sonos Packets Received UDP = "..targetedUDPFoundDevs)
               print("Total MDns/Shelly Packets Received mDNS= "..totalPacketsReceived)
               print("Shelly Discovery Plugin has been Ended Configuring SucceSSfullY")
               print("Shelly Discovery Plugin has been Ended Configuring SucceSSfullY")
               print("Shelly Discovery Plugin has been Ended Configuring SucceSSfullY")

                  
               logging.info("*********************************************************************************")
               logging.info("*****************Final Summary for Targeted Founded Devices**********************")
               logging.info("*********************************************************************************")

               local iter1=0
               for l, m in ipairs(targetedDeviceList) do
                  print("Devices found "..l..' - '..m)
               end


               logging.info("*********************************************************************************")
               logging.info("*************************Program Ends Here***************************************")
               logging.info("*********************************************************************************")

end


return 'OK'


