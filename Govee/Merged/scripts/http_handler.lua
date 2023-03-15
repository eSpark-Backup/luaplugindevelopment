
-- -- local govee_devices_ip = {}

-- -- -- recursively search the govee message for IP4
-- -- local function findrecr(str, substr, callback, init)
-- --     init = init or 1
-- --     local first, last = str:find(substr, init)
-- --     if first then
-- --         -- callback(str, first, last)
-- --         table.insert(govee_devices_ip, string.sub(str, first, last))
-- --         return findrecr(str, substr, callback, last + 1)
-- --     end
-- -- end



-- -- findrecr('Some Data 192.168.18.44 after some data', "%d+%.%d+%.%d+%.%d+",print)
-- -- findrecr('Some Data2 192.168.18.244 after some data', "%d+%.%d+%.%d+%.%d+",print)
-- -- findrecr('Some Data3 192.168.18.150 after some data', "%d+%.%d+%.%d+%.%d+",print)
-- -- findrecr('Some Data4 192.168.18.85 after some data', "%d+%.%d+%.%d+%.%d+",print)
-- -- findrecr('Some Data5 192.168.18.22 after some data', "%d+%.%d+%.%d+%.%d+",print)

-- -- print(#govee_devices_ip)

-- -- if #govee_devices_ip > 0 then

-- --     for k, ip4Ditionary in pairs(govee_devices_ip) do        
-- --         print(k, ip4Ditionary)
-- --     end
-- -- end


-- -- function table.set(t) -- set of list
-- --     local u = { }
-- --     for _, v in ipairs(t) do u[v] = true end
-- --     return u
-- --   end
  
-- --   function table.find(f, l) -- find element v of l satisfying f(v)
-- --     --print(f[2])
-- --     --print(l)
-- --     for _, v in ipairs(l) do
-- --         print(_,v)
-- --       if f(v) then
-- --         return v
-- --       end
-- --     end
-- --     return 'notFoind'--nil
-- --   end

-- -- function sleep (a) 
-- --     local sec = tonumber(os.clock() + a); 
-- --     while (os.clock() < sec) do 
-- -- 		--just do sleep for a sec
-- --     end 
-- -- end

-- --   function table.find(t,value)
-- --     if t and type(t)=="table" and value then
-- --         for _, v in ipairs (t) do
-- --             if v == value then
-- --                 return true;
-- --             end
-- --         end
-- --         return false;
-- --     end
-- --     return false;
-- -- end


-- -- local myitems = { 'a', 'b' }
-- -- -- for k,v in pairs(myitems) do 
-- -- -- print(k,v)
-- -- -- end

-- --   print(table.find(govee_devices_ip,'192.168.18.41'))
-- -- sleep(2)
-- -- print("after sleeping!!!!!!!!!!!")
-- -- sleep(0.5)
-- -- print("after sleeping!!!!!!!!!!!")
-- -- sleep(1)
-- -- print("after sleeping!!!!!!!!!!!")

-- local myvarPayload='{'..
-- '   "msg":{'..
-- '      "cmd":"devStatus",'..
-- '      "data":{'..
-- '        "onOff":1,'..
-- '        "brightness":100,'..
-- '        "color":{'..
-- '          "r":255,'..
-- '          "g":0,'..
-- '          "b":0'..
-- '        },'..
-- '        "colorTemInKelvin":7200'..
-- '      }'..
-- '    }'..
-- '  }';

-- --print(json.encode(myvarPayload))

-- -- recursively search the govee message for r,g,b,brightness,colorTemInKelvin
-- -- local function findrecrRGB(str, substr, callback, init)
-- --     init = init or 1
-- --     local first, last = str:find(substr, init)
-- --     if first then
-- --         -- callback(str, first, last)
-- -- 		local srchip =  string.sub(str, first, last)
		
-- --         --if the ip does not exist in the table then add it
-- -- 		if table.find(govee_devices_ip,srchip) then
-- -- 			table.insert(govee_devices_ip, srchip)	
-- -- 		end        
        
-- --         return findrecr(str, substr, callback, last + 1)
-- --     end
-- -- end

-- --findrecrRGB(myvarPayload,"r\":\d+",print)



-- --local first, last = myvarPayload:find(substr, init)
-- -- search govee message for IP4 and adds to array
-- --findrecr(data, "%d+%.%d+%.%d+%.%d+", print)

-- function replace_char(pos, str, r)
--     return str:sub(1, pos-1) .. r .. str:sub(pos+1)
-- end

-- --string.gsub (s, pattern, repl [, n])

-- local testvar =  string.gsub(string.sub(myvarPayload,string.find(myvarPayload, "onOff\":%d+")),"onOff\":","")
-- print(testvar)
-- --print(string.gsub(string.sub(myvarPayload,string.find(myvarPayload, "onOff\":%d+")),"onOff\":",""))
-- testvar =  string.gsub(string.sub( myvarPayload,string.find(myvarPayload, "brightness\":%d+")),"brightness\":","")
-- print(testvar)


-- print(string.sub( myvarPayload,string.find(myvarPayload, "brightness\":%d+")))
-- print(string.sub( myvarPayload,string.find(myvarPayload, "colorTemInKelvin\":%d+")))
-- print(string.sub( myvarPayload,string.find(myvarPayload, "r\":%d+")))
-- print(string.sub( myvarPayload,string.find(myvarPayload, "g\":%d+")))
-- print(string.sub( myvarPayload,string.find(myvarPayload, "b\":%d+")))

local SetGoveeBrightness=0
local PayloadStringBrightness = '{' .. '	"msg":{' .. '	  "cmd":"brightness",' .. '	  "data":{' .. '		"value":' ..
                                    SetGoveeBrightness .. '	  }' .. '	}' .. ' }';
local govee_devices_ip ={}
local testnil = 9002
print(#govee_devices_ip.."  *********Devicessssssssssssss Found on network!")

print(not true)


print(tonumber("0"))
print(tonumber(0))
print(tonumber(testnil or 0))

print(testnil)

if not testnil then
    print('value of testnil')
    print(testnil or 0)
end

print('test for string nil')
print(testnil or "0")

if testnil ~= 9001 then
     print("******************************8")
end

print(PayloadStringBrightness)
SetGoveeBrightness=90
PayloadStringBrightness = '{' .. '	"msg":{' .. '	  "cmd":"brightness",' .. '	  "data":{' .. '		"value":' ..
                                    SetGoveeBrightness .. '	  }' .. '	}' .. ' }';
                                    
print(PayloadStringBrightness)


--print(tonumber(nil)==nil ? "0":"1")

-- if there are some devices found with ip4 addresses then continue
    -- if #govee_devices_ip > 0 then
    
    --     for k, ip4Ditionary in pairs(govee_devices_ip) do
    --         logging.info("Logger1 Commmmmmmmmmmmmmmmmmmmmmmmandddd called for " .. ip4Ditionary .. " setting value to " ..
    --                          SetGoveeOnOff)
    --         multicastIP = ip4Ditionary
    --         -- print(k, ip4Ditionary)
    --         network.sendto(handle, PayloadStringOnOff, ip4Ditionary, multicastPortCommand) -- set device On/Off "at specific ip address?"
    
    --         sleep(0.5) -- wait for 500ms between sending multiple commands
    
    --         network.sendto(handle, PayloadStringStatus, ip4Ditionary, multicastPortCommand) -- set gets the status of 
    --     end
    