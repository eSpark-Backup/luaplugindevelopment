local params = ...

local _logger = require("logging")
local _core = require("core")
local _storage = require("storage")
local _json = require("json")


-- if params.event == "http_connection_closed" then

--     return
-- end

-- if params.event == "http_data_received" then
--     local response = _json.decode(params.data.data)

--     for id, lamp in pairs(response) do
--         if lamp.error and lamp.error.type == 101 and not _storage.get_string("username") then 
--             _core.send_ui_broadcast({
--                 status = "error",
--                 message = "Press the button on your Govee SmartLEDs RGBIC and then push 'configure' button"
--             })
--             _logger.debug("Error 101, Its ok, just push the button and repeat")

        --elseif lamp.state and lamp.name and _G.govee_smartleds_rgbic then

        
            print("In creating device function,")
            local device_id = _core.add_device {
                name = "(Govee SmartLEDs RGBIC) " .. params.ip,
                type = "light.bulb",
                category = "dimmable_light",
                subcategory = "dimmable_colored", --"dimmable_bulb",
                device_type_id = "ezlo.govee_lamp",
                battery_powered = false,
                gateway_id = _core.get_gateway().id,
                info = {
                    id = id,
                    parent_device_id = _G.govee_smartleds_rgbic
                }

                -- "reachable": true,
                -- "persistent": false,
                -- "serviceNotification": false,
                -- "roomId": "",
                -- "security": "no",
                -- "ready": true,
                -- "status": "idle"
    
            }

            if not device_id then
                _logger.error("Failed to create device")
                return
            end

            --_G.govee_smartleds_rgbic = device_id
            
            print("Created device with ID: " .. device_id)

            local success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/switch"), { device_id = device_id, action = "create"})--, value = lamp.state.on
            if not success then
                _logger.error("Failed to set item: switch, error: " .. errmsg)
            end
            print("In creating switch function,")

            local brightness = 50 --math.tointeger(lamp.state.bri / 2.54 - lamp.state.bri / 2.54 % 1)
            success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/dimmer"), { device_id = device_id, action = "create", value = brightness })
            if not success then
                _logger.error("Failed to set item: brightness, error: " .. errmsg)
            end
            print("In creating dimmer function,")

            local hue = 80
            success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/hue"), { device_id = device_id, action = "create", value = hue })
            if not success then
                _logger.error("Failed to set item: hue, error: " .. errmsg)
            end
            print("In creating gue function,")

            local sat = 90
            success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/saturation"), { device_id = device_id, action = "create", value = sat}) 
            if not success then
                _logger.error("Failed to set item: saturator, error: " .. errmsg)
            end
            print("In creating saturator function,")

            local effect = "none"
            success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/effect"), { device_id = device_id, action = "create", value = effect })
            if not success then
                _logger.error("Failed to set item:effect, error: " .. errmsg)
            end
            print("In creating effect function,")

            local xy={red=255,green=0,blue=0}
            success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/rgbcolor"), { device_id = device_id, action = "create", value = xy })
            if not success then
                _logger.error("Failed to set item: rgbcolor, error: " .. errmsg)
            end
            print("In creating rgbcolor function,")

            local ct=5000
            success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/color_temperature"), { device_id = device_id, action = "create", value = ct })
            if not success then
                _logger.error("Failed to set item: temperature, error: " .. errmsg)
            end
            print("In creating color_temperature function,")

            local alert="none"
            success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/alert"), { device_id = device_id, action = "create", value = alert })
            if not success then
                _logger.error("Failed to set item: alert, error: " .. errmsg)
            end
            print("In creating alert function,")

            _logger.info("Created device with ID: " .. device_id)
            print("Created device with ID: " .. device_id)
        --end
--     end

-- end
