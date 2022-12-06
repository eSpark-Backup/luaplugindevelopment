local network = require("network")
local logging = require ("logging")
logging.info("Plugins Discovery Has Been STARTED SUCCECCFULLY")

isSocketName = false
isNetworkHandleExist = false
totalPacketsReceived=0

print("*******************************Start Details*******************************")

--core.get_setting()
--print(os.execute('hostname -I'))

local mynetDetails2 = hub.network.get
local mynetDetails = hub.network.get()
print(mynetDetails)
print(tostring(mynetDetails))

for k,v in pairs(mynetDetails) do
    
    if (type(v) == "table") then
    --logging.info("    Found1=:" .. tostring(k)  .. "   with values="   .. tostring(v) )
       for s,t in pairs(v) do
          print(tostring(s)  .. " = "   .. tostring(t) )

          if (type(t) == "table") then
             print(tostring(s)  .. " = "   .. tostring(t) )
             for w,x in pairs(t) do
                print("    Found4=:" .. tostring(w)  .. "   with values="   .. tostring(x) )
             end            
          end
       end      
    end   
 end