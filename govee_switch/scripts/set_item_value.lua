local _core = require("core")
local _logger = require("logging")
local _http = require("http")
local _storage = require("storage")

local params = ... or {}

local items = {}
local send_data_table = {}
local srchip = ""

-- recursively search the govee message for IP4
local function findrecr(str, substr, callback, init)
    init = init or 1
    local first, last = str:find(substr, init)
    if first then
        -- callback(str, first, last)
        srchip = string.sub(str, first, last)
        -- if the ip does not exist in the table then add it
        -- if not table.find(govee_devices_ip, srchip) then
        --     table.insert(govee_devices_ip, srchip)
        -- end
        --return findrecr(str, substr, callback, last + 1)
    end
end

-- {"item_id":"6149d46c128a2b67258f1218","value":30}
if type(params.item_id) == "string" then
    items[params.item_id] = { value = params.value }

    -- {"item_ids":["6149d46c12822a67258f121e","6149d46c1aa22ba7258f1218"],"value":0}
elseif type(params.item_ids) == "table" then
    for _, item_id in ipairs(params.item_ids) do
        items[item_id] = { value = params.value }
    end

    -- {"items":{"6149d46c12813b67258f1228":{"value":30},"6149d46c13322b67258f121e":{"value":1}}}
elseif type(params.items) == "table" then
    items = params.items
end

local ip
local set_item_table
for item_id, item_params in pairs(items) do
    local item = _core.get_item(item_id)
    local device = _core.get_device(item.device_id)

    if item.name == "switch" then
        _core.update_item_value(item.id, params.value)
        findrecr(device.name, "%d+%.%d+%.%d+%.%d+", print)

        if params.value then
            SetGoveeOnOff = 1
        else
            SetGoveeOnOff = 0
        end

        print("**********************Before sending network Packet for On/OFF",SetGoveeOnOff,item.id, PayloadStringOnOff)
        
PayloadStringOnOff = '{' .. 
'	"msg":{' .. 
'	  "cmd":"turn",' .. 
'	  "data":{' .. 
'		"value":' .. SetGoveeOnOff ..
'	  }' .. 
'	}' .. 
'  }';


        network.sendto(handle, PayloadStringOnOff, srchip, multicastPortCommand) -- set device On/Off "at specific ip address?"
        print("**********************After sending network Packet for On/OFF")

    end
    

    -- --ip is stored in parent device setting
    -- local setting_ids = _core.get_setting_ids_by_device_id(_G.govee_smartleds_rgbic)
    -- for _, setting_id in pairs(setting_ids) do
    --     if _core.get_setting(setting_id).info.name == "device_ip" and
    --         _core.get_setting(setting_id).device_id == _G.govee_smartleds_rgbic then
    --         ip = _core.get_setting(setting_id).value
    --     end
    -- end

    -- -- names of items on Govee SmartLEDs RGBIC sometimes differ from our hub, it stored in item "info" field
    -- -- id also differ from id on our hub, it stored in device "info" field
    -- -- to send data there is necessary to know to which lamp, which setting and which value to send
    -- if device.info.id then

    --     send_data_table[device.info.id] = {}
    -- end

    -- if item.name == "scene" then
    --      local id
    --      local send_data
    --     -- for scene_id, value in pairs(item.info.subdata) do
    --     --     if value.name == params.value then
    --     --         send_data = '{"scene":"' .. scene_id .. '"}'
    --     --         id = value.group
    --     --     end
    --     -- end

    --     -- local content_length = #send_data
    --     -- local username = _storage.get_string("username")
    --     -- if username then
    --     --     local success, message = pcall(_http.request, {
    --     --         skip_security = true,
    --     --         url = "http://" .. ip .. "/api/" .. username .. "/groups/" .. id .. "/action",
    --     --         handler = "HUB:ezlo.govee/scripts/handlers/http_set_item_receive",
    --     --         data = send_data,
    --     --         type = "PUT",
    --     --         content_type = "application/json",
    --     --         content_length = content_length,
    --     --         headers = {
    --     --             ["Expect"] = "",
    --     --             ["Transfer-Encoding"] = ""
    --     --         }
    --     --     })

    --     --     if not success then
    --     --         _logger.error("Failed to make HTTP request: " .. message)
    --     --         return false
    --     --     end
    --     --     _core.update_item_value(item.id, params.value)
    --     -- end
    --     -- return
    -- elseif item.name == "rgbcolor" then
    --     local RGBToXY = loadfile("HUB:ezlo.govee/scripts/functions/rgb_to_xy")

    --     if not RGBToXY then
    --         _logger.error("Failed to load function rgb_to_xy")
    --         return
    --     end

    --     local success, XY = pcall(RGBToXY, {
    --         value = item_params.value
    --     })

    --     if success then
    --         send_data_table[device.info.id][item.info.name] = XY
    --     end
    -- elseif item.name == "dimmer" then
    --     --search for switch item
    --     local switch
    --     local items = _core.get_items_by_device_id(item.device_id)
    --     if items then
    --         for _, item in ipairs(items) do
    --             if item.name == "switch" then
    --                 switch = item
    --             end
    --         end
    --     end

    --     if switch then
    --         --when we set dimmer and lamp is OFF, then turn it ON
    --         if item_params.value > 1 and switch.value == false then
    --             send_data_table[device.info.id][switch.info.name] = true
    --             _core.update_item_value(switch.id, true)

    --             -- when we set dimmer to 0  and lamp is ON, then turn it OFF
    --         elseif item_params.value < 1 and switch.value == true then
    --             send_data_table[device.info.id][switch.info.name] = false
    --             _core.update_item_value(switch.id, false)
    --         end
    --     end

    --     local brightness = math.tointeger(item_params.value * 2.54 - item_params.value * 2.54 % 1)
    --     send_data_table[device.info.id][item.info.name] = brightness

    -- elseif item.name == "switch" then
    --     send_data_table[device.info.id][item.info.name] = item_params.value
    --     --search for dimmer item
    --     local dimmer
    --     local items = _core.get_items_by_device_id(item.device_id)
    --     if items then
    --         for _, item in ipairs(items) do
    --             if item.name == "dimmer" then
    --                 dimmer = item
    --             end
    --         end
    --     end

    --     if dimmer then
    --         -- if we turn lamp ON it brightness will be as it was last time
    --         if item_params.value == true then
    --             local storage_dimmer_value = _storage.get_number(dimmer.id)
    --             local brightness = math.tointeger(storage_dimmer_value * 2.54 - storage_dimmer_value * 2.54 % 1)
    --             send_data_table[device.info.id][dimmer.info.name] = brightness
    --             _core.update_item_value(dimmer.id, storage_dimmer_value)

    --             -- if we turn lamp OFF it brightness will be 0
    --         else
    --             send_data_table[device.info.id][dimmer.info.name] = 0
    --             _storage.set_number(dimmer.id, dimmer.value)
    --             _core.update_item_value(dimmer.id, 0)
    --         end
    --     end
    -- else
    --     send_data_table[device.info.id][item.info.name] = item_params.value
    -- end

    set_item_table = {
        item_name = item.name,
        device_id = item.device_id,
        item_id = item_id,
        value = item_params.value,
        action = "set"
    }

end

-- local json_script = loadfile("HUB:ezlo.govee/scripts/modules/json")

-- -- sending data to hue bridge
-- for id, data in pairs(send_data_table) do

--     local success, send_data = pcall(json_script, {
--         event = "encode",
--         value = data
--     })

--     if not success then
--         _logger.error("Failed to set encode: , error: " .. send_data)
--     end

--     local content_length = #send_data
--     local username = _storage.get_string("username")
--     if username then
--         local success, message = pcall(_http.request, {
--             skip_security = true,
--             url = "http://" .. ip .. "/api/" .. _storage.get_string("username") .. "/lights/" .. id .. "/state",
--             handler = "HUB:ezlo.govee/scripts/handlers/http_set_item_receive",
--             data = send_data,
--             type = "PUT",
--             content_type = "application/json",
--             content_length = content_length,
--             headers = {
--                 ["Expect"] = "",
--                 ["Transfer-Encoding"] = ""
--             }
--         })

--         if not success then
--             _logger.error("Failed to make HTTP request: " .. message)
--             return false
--         end

--         if not _G.philips_hue.requests then
--             _G.philips_hue.requests = {}
--         end

--         _G.philips_hue.requests[message] = set_item_table
--     end
-- end
