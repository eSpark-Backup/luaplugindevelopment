params = ... or {}
local logging = require("logging")
network = require("network")

logging.info("Logger1 called before network.udp();")

--if (not isNetworkHandleExist) then
    handle = network.udp()
  --  isNetworkHandleExist = true
--else
    --return
--end

local params = ... or {}
targetedUDPFoundDevs = 0
totalPacketsReceived = 0
local ipaddress = ""

multicastIP = "239.255.255.250"
multicastPort = 4001
multicastPortCommand = 4003

print("************************************************")
print("Select value for Client network.handle =" .. handle)
print("************************************************")

multicastServerPort = 4002
local multicastDuration = 20 -- 26.6666 = 1sec

if (not isSocketName) then
    logging.info("Logger1 called before *************setsockname on port 4001!!!!!!!!!!!!!!!!!!! ")
    network.setoption(handle, "broadcast")
    network.setsockname(handle, "*", multicastServerPort) -- "*", "4002"
    isSocketName = true
end

SetGoveeOnOff = params.DevOnOff or 0 -- 0 for off and 1 for ON
local SetGoveeBrightness = params.Devbrightness or 0 -- range from 0-100 and 101 is not to use this variable
local SetDevRed = params.DevRed or 0 -- range from 0-255 and 256 is not to use this variable
local SetDevGreen = params.DevGreen or 0 -- range from 0-255 and 256 is not to use this variable
local SetDevBlue = params.DevBlue or 0 -- range from 0-255 and 256 is not to use this variable
local SetDevColorTemp = params.DevColorTemp or 0 -- range from 0-9000 and 9001 is not to use this variable
local GoveeIP = params.GoveeIP or '' -- string , seperated values
-- close a network connection if payload parameter has value "close"

-- --if type(params.DevOnOff) == "number" then
--     SetGoveeOnOff = params.DevOnOff or 0
-- --end
-- --if type(params.Devbrightness) == "number" and params.Devbrightness ~= 101 then
--     SetGoveeBrightness = params.Devbrightness or 0
-- --end
-- --if type(params.DevRed) == "number" and params.DevRed ~= 256 then
--     SetDevRed = params.DevRed or 0
-- --end
-- --if type(params.DevGreen) == "number" and params.DevGreen ~= 256 then
--     SetDevGreen = params.DevGreen or 0
-- --end
-- --if type(params.DevBlue) == "number" and params.DevBlue ~= 256 then
--     SetDevBlue = params.DevBlue or 0
-- --end
-- --if type(params.DevColorTemp) == "number" and params.DevColorTemp ~= 9001 then
--     SetDevColorTemp = params.DevColorTemp or 0
-- --end

-- GoveeIP = params.GoveeIP or ''

if SetGoveeOnOff > 1 or SetGoveeOnOff < 0 then
    print(" Parameter incorrect for Device On/Off 1 or 0")
    --network.close(handle)
    return
end

if SetGoveeBrightness > 101 or SetGoveeBrightness < 0 then
    print(" Parameter incorrect for Brightness ")
    --network.close(handle)
    return
end

if SetDevRed > 256 or SetDevRed < 0 then
    print(" Parameter incorrect for Device Color RED ")
    --network.close(handle)
    return
end

if SetDevGreen > 256 or SetDevGreen < 0 then
    print(" Parameter incorrect for Device Color GREEN ")
    --network.close(handle)
    return
end

if SetDevBlue > 256 or SetDevBlue < 0 then
    print(" Parameter incorrect for Device Color BLUE ")
    --network.close(handle)
    return
end

if SetDevColorTemp > 9001 or SetDevColorTemp < 0 then
    print(" Parameter incorrect for Device Color Temperature")
    --network.close(handle)
    return
end



local PayloadString ='{' .. 
'  "msg":{' .. 
'    "cmd":"scan",' .. 
'    "data":{' .. 
'      "account_topic":"reserve"' .. 
'    }' .. 
'  }' ..
'}';

PayloadStringOnOff = '{' .. 
'	"msg":{' .. 
'	  "cmd":"turn",' .. 
'	  "data":{' .. 
'		"value":' .. SetGoveeOnOff ..
'	  }' .. 
'	}' .. 
'  }';

local PayloadStringBrightness = '{' .. 
'	"msg":{' .. 
'	  "cmd":"brightness",' .. 
'	  "data":{' .. 
'		"value":' ..SetGoveeBrightness .. 
'	  }' .. 
'	}' .. 
' }';

local PayloadStringStatus = '{' .. 
'	"msg":{' .. 
'	  "cmd":"devStatus",' .. 
'	  "data":{' .. 
'	  }' .. 
'	}' .. 
' }';

local PayloadStringRGBtemp ='{' .. 
'	"msg":{' .. 
'	  "cmd":"colorwc",' .. 
'	  "data":{' .. 
'		"color":{' .. 
'		  "r":' .. SetDevRed .. 
',' ..
'		  "g":' .. SetDevGreen .. 
',' .. 
'		  "b":' .. SetDevBlue .. 
'		},' .. 
'		"colorTemInKelvin":' ..SetDevColorTemp .. 
'	  }' .. 
'	}' .. 
'  }';

function table.find(t, value)
    if t and type(t) == "table" and value then
        for _, v in ipairs(t) do
            if v == value then
                return true;
            end
        end
        return false;
    end
    return false;
end

function sleep(a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
        -- just do sleep for a sec
    end
end

-- recursively search the govee message for IP4
local function findrecr(str, substr, callback, init)
    init = init or 1
    local first, last = str:find(substr, init)
    if first then
        -- callback(str, first, last)
        local srchip = string.sub(str, first, last)
        -- if the ip does not exist in the table then add it
        if not table.find(govee_devices_ip, srchip) then
            table.insert(govee_devices_ip, srchip)
        end
        return findrecr(str, substr, callback, last + 1)
    end
end

logging.info("Sending Discovery packet to the port 4001!!!!!!!!!!!!!!!!!!")
network.sendto(handle, PayloadString, multicastIP, multicastPort) -- "4001"

-- logging.info("Logger1 SERVERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRr called before network.udp();")
logging.info("Started Receiving discovery ON port 4002!!!!!!!!!!!!!!!!!!!!!")

targetedUDPFoundDevs = 0
local ipaddress = ""
local beginTime = os.time()


-- Collect all the ip addresses by user defined values
findrecr(GoveeIP, "%d+%.%d+%.%d+%.%d+", print)

while os.time() - beginTime < multicastDuration do
    local data, address, port = network.receivefrom(handle)
    if #address > 1 and data then -- received any UDP packet?
        targetedUDPFoundDevs = targetedUDPFoundDevs + 1
        print("Message: " .. data)
        -- search govee message for IP4 and adds to array
        findrecr(data, "%d+%.%d+%.%d+%.%d+", print)
        print("Address: " .. address)
        print("Port: " .. port)
    end
end

--closing network because we need to use different port
--network.close(handle)

print("Govee SET COMMAND ON/OFF starting!")
print("Govee SET COMMAND ON/OFF starting!")
print("Govee SET COMMAND ON/OFF starting!")

-- reusing network handle for govee command initiative
--if (isNetworkHandleExist) then
    --network = require("network")
    --handle = network.udp()
--    isNetworkHandleExist = false
--end

-- payload to Set ON/OFF
if #govee_devices_ip < 1 then
    print("*********No Devices found on network")
else
    print(#govee_devices_ip .. "  *********Devicessssssssssssss Found on network!")
    
    if _G.govee_smartleds_rgbic == nil then --create if not detected
        --local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/create_device"),
        local cntr = 1
        for k, ip4Ditionary in pairs(govee_devices_ip) do
            local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/handlers/http_setup_handler"),
            { device_name = "Govee SmartLEDs RGBIC-"..cntr,
            ip = ip4Ditionary })
            cntr = cntr+1
            if not success then
                logging.error("Failed to create device, error: " .. errmsg)
            end
        end

    end
    
end

-- if #govee_devices_ip > 0 then
--     print("************************************************")
--     print("Select value for Client network.handle =" .. handle)
--     print("************************************************")

-- --    if (not isSocketName) then
-- --        logging.info("Logger2 called before GoveeCommand *****************setsockname on port 4003!!!!!!!!!")
-- --        network.setoption(handle, "broadcast")
-- --        network.setsockname(handle, "*", multicastPortCommand) -- "*", "4003"
-- --        isSocketName = true
-- --    end

--     -- if there are some devices found with ip4 addresses then continue

--     for k, ip4Ditionary in pairs(govee_devices_ip) do
--         -- logging.info("Logger1 Commmmmmmmmmmmmmmmmmmmmmmmandddd called for " .. ip4Ditionary .. " setting value to " ..SetGoveeOnOff)
--         logging.info("Setting devices On/Off for IP= " .. ip4Ditionary .. " setting value to " .. SetGoveeOnOff)
--         multicastIP = ip4Ditionary
--         -- send on off to the port 4001
--         network.sendto(handle, PayloadStringOnOff, ip4Ditionary, multicastPortCommand) -- set device On/Off "at specific ip address?"

--         sleep(0.5) -- wait for 500ms between sending multiple commands

--         logging.info(" Sending Get Status command to port 4003!!!!!!!!!!!!!!!!!!!!!!")
--         network.sendto(handle, PayloadStringStatus, ip4Ditionary, multicastPortCommand) -- set gets the status of 
--     end

-- if SetGoveeOnOff==0 then
--     print("Device(s) set off Program exiting!")
--     network.close(handle)
--     return
-- end

--     -- following status will be returned
--     -- {
--     -- 	"msg":{
--     -- 	  "cmd":"devStatus",
--     -- 	  "data":{
--     -- 		"onOff":1,
--     -- 		"brightness":100,
--     -- 		"color":{
--     -- 		  "r":255,
--     -- 		  "g":0,
--     -- 		  "b":0
--     -- 		},
--     -- 		"colorTemInKelvin":7200
--     -- 	  }
--     -- 	}
--     --   }
--     -- targetedUDPFoundDevs = 0

--     multicastDuration = 20
--     ipaddress = ""
--     beginTime = os.time()


--     print("Started Receiving RGB and Temperature Values!!!!!!!!!!!!!!!")

--     while os.time() - beginTime < multicastDuration do
--         local data, address, port = network.receivefrom(handle)
--         if #address > 1 and data then -- received any UDP packet?
--             -- targetedUDPFoundDevs = targetedUDPFoundDevs + 1
--             print("Message: " .. data)
--             if #data > 20 then -- there is some valid data and its length greater than 20
--                 -- for i, v in ipairs(devicesSearch) do
--                 --     myvar1, myvar2 = string.find(string.lower(data), string.lower(v))
--                 --     if myvar1 then
--                 --         print(i .. ' - ' .. v, myvar1, myvar2)
--                 --         table.insert(targetedDeviceList, data)
--                 --     end
--                 -- end

--                 -- SetGoveeOnOff = 0 -- 0 for off and 1 for ON
--                 -- SetGoveeBrightness = 101 -- range from 0-100 and 101 is not to use this variable
--                 -- SetDevRed = 256 -- range from 0-255 and 256 is not to use this variable
--                 -- SetDevGreen = 256 -- range from 0-255 and 256 is not to use this variable
--                 -- SetDevBlue = 256 -- range from 0-255 and 256 is not to use this variable
--                 -- SetDevColorTemp = 9001 -- range from 0-9000 and 9001 is not to use this variable

--                 -- SetGoveeOnOff      = string.sub( data,string.find(data, "onOff\":%d+"))
--                 if (SetGoveeBrightness == 101) then
--                     SetGoveeBrightness = string.gsub(string.sub(data, string.find(data, "brightness\":%d+")),
--                         "brightness\":", "")
--                     print("Setting Brightness value to " .. SetGoveeBrightness)
--                 end


--                     if (SetDevColorTemp == 9001) then
--                         SetDevColorTemp = string.gsub(string.sub(data, string.find(data, "colorTemInKelvin\":%d+")),
--                             "colorTemInKelvin\":", "")
--                         print("Setting DevColorTemp value to " .. SetDevColorTemp)
--                     end

--                     if (SetDevRed == 256) then
--                         SetDevRed = string.gsub(string.sub(data, string.find(data, "r\":%d+")), "r\":", "")
--                         print("Setting SetDevRed value to " .. SetDevRed)
--                     end

--                     if (SetDevGreen == 256) then
--                         SetDevGreen = string.gsub(string.sub(data, string.find(data, "g\":%d+")), "g\":", "")
--                         print("Setting SetDevGreen value to " .. SetDevGreen)
--                     end

--                     if (SetDevBlue == 256) then
--                         SetDevBlue = string.gsub(string.sub(data, string.find(data, "b\":%d+")), "b\":", "")
--                         print("Setting SetDevBlue value to " .. SetDevBlue)
--                     end
--             end

--             print("Address: " .. address)
--             print("Port: " .. port)
--         end
--     end


-- print("Ending Receiving RGB and Temperature Values!!!!!!!!!!!!!!!")

--     sleep(1) -- wait for a second between sending multiple commands

--     PayloadStringBrightness = '{' .. '	"msg":{' .. '	  "cmd":"brightness",' .. '	  "data":{' .. '		"value":' ..
--                                   SetGoveeBrightness .. '	  }' .. '	}' .. ' }';

--     -- set Brightness , RGB , colorTemInKelvin
--     for k, ip4Ditionary in pairs(govee_devices_ip) do
--         -- logging.info("Logger2 Commmmmmmmmmmmmmmmmmmmmmmmandddd called for " .. ip4Ditionary .. " setting Brightness ")
--         logging.info("Sending set Brighness to value " .. SetGoveeBrightness .. " port 4003 at IP  " .. ip4Ditionary)
--         -- print(SetGoveeBrightness)

--         sleep(0.5) -- wait for 500ms between sending multiple commands
--         network.sendto(handle, PayloadStringBrightness, ip4Ditionary, multicastPortCommand) -- set gets the status of 
--     end

--     PayloadStringRGBtemp = '{' .. '	"msg":{' .. '	  "cmd":"colorwc",' .. '	  "data":{' .. '		"color":{' .. '		  "r":' ..
--                                SetDevRed .. ',' .. '		  "g":' .. SetDevGreen .. ',' .. '		  "b":' .. SetDevBlue ..
--                                '		},' .. '		"colorTemInKelvin":' .. SetDevColorTemp .. '	  }' .. '	}' .. '  }';

--     sleep(1) -- wait for 2seconds between sending multiple commands
--     -- set RGB , colorTemInKelvin

--     for k, ip4Ditionary in pairs(govee_devices_ip) do
--         -- logging.info("Logger3 Commmmmmmmmmmmmmmmmmmmmmmmandddd called for " .. ip4Ditionary .. " setting R,G,B , colorTemInKelvin ")
--         logging.info("Sending set RGB value and Set Temperature values to Device IP= " .. ip4Ditionary ..
--                          " setting R,G,B , colorTemInKelvin ")
--         print(SetDevRed, SetDevGreen, SetDevBlue, SetDevColorTemp)

--         sleep(0.5) -- wait for 500ms between sending multiple commands to different IPs
--         network.sendto(handle, PayloadStringRGBtemp, ip4Ditionary, multicastPortCommand) -- set gets the status of 
--     end

-- end -- end of if condition when devices are available

print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")

-- network.close(handle)
-- network.close(handle)
-- network.close(handle)

return
-- do clear the server port
--print(os.execute("kill $(lsof -t -i:4002)"))

