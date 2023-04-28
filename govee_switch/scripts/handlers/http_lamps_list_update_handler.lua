-- local params = ...

-- local _logger = require("logging")
-- local _core = require("core")
-- local _storage = require("storage")
-- local _json = require("json")
-- local _timer = require("timer")

-- local TIMER_ID = "philips_lamps_update"

-- if params.event == "http_connection_closed" then
--     if params.data.reason.code == 2 then
--         local devices = _core.get_devices()
--         local gateway_id = _core.get_gateway().id
--         if devices then
--             for _, device in ipairs(devices) do
--                 if device.gateway_id == gateway_id and device.reachable == true then
--                     _core.update_reachable_state(device.id, false)
--                 end
--             end
--         end
--     end
--     return
-- end

-- if params.event == "http_data_received" then
--     local response = _json.decode(params.data.data)
    
--     if _G.govee_smartleds_rgbic then
--         local device = _core.get_device(_G.govee_smartleds_rgbic)
--         if device.reachable == false then
--             _core.update_reachable_state(_G.govee_smartleds_rgbic, true)
--         end
--     end

--     for key, value in pairs(response) do
--         if value.error and value.error.type == 101 and not _storage.get_string("username") then
--             _core.send_ui_broadcast({
--                 status = "error",
--                 message = "Press the button on your Govee SmartLEDs RGBIC and then push 'configure' button"
--             })
--             _logger.debug("Error 101, Its ok, just push the button and repeat request")
--             _timer.cancel(TIMER_ID)

--         elseif value.state and value.name then

--             local device_id
--             local action = "set"
--             local devices = _core.get_devices()
--             if devices then
--                 for _, dev in ipairs(devices) do
--                     if dev.info.id == key and dev.info.parent_device_id == _G.govee_smartleds_rgbic then
--                         device_id = dev.id
--                     end
--                 end
--             end

--             local item_id_map = {}

--             if not device_id and _G.govee_smartleds_rgbic then

--                 device_id = _core.add_device {
--                     name = "(Phillips Hue) " .. value.name,
--                     type = "light.bulb",
--                     category = "dimmable_light",
--                     subcategory = "dimmable_bulb",
--                     device_type_id = "ezlo.govee_lamp",
--                     battery_powered = false,
--                     gateway_id = _core.get_gateway().id,
--                     info = {
--                         id = key,
--                         parent_device_id = _G.govee_smartleds_rgbic
--                     }
--                 }

--                 if not device_id then
--                     _logger.error("Failed to create device")
--                     return
--                 end

--                 action = "create"

--                 _logger.info("Created device with ID: " .. device_id)
--             elseif _G.govee_smartleds_rgbic then
--                 local items = _core.get_items_by_device_id(device_id)
--                 if items then
--                     for _, item in ipairs(items) do
--                         item_id_map[item.name] = item.id
--                     end
--                 end
--             else
--                 return
--             end

--             local old_bri
--             local success, errmsg
--             if value.state.on ~= nil then
--                 if value.state.on == false then

--                     old_bri = math.tointeger(value.state.bri / 2.54 - value.state.bri / 2.54 % 1)
--                     value.state.bri = 0
--                 end

--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/switch"), {
--                     device_id = device_id,
--                     action = action,
--                     value = value.state.on,
--                     item_id = item_id_map["switch"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item: switch, error: " .. errmsg)
--                 end
--             end

--             if (value.state.bri) then
--                 local brightness = math.tointeger(value.state.bri / 2.54 - value.state.bri / 2.54 % 1)
--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/dimmer"), {
--                     device_id = device_id,
--                     action = action,
--                     value = brightness,
--                     item_id = item_id_map["dimmer"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item: brightness, error: " .. errmsg)
--                 end

--                 local dimmer
--                 local items = _core.get_items_by_device_id(device_id)
--                 if items then
--                     for _, item in ipairs(items) do
--                         if item.name == "dimmer" then
--                             dimmer = item
--                         end
--                     end
--                 end
--                 if old_bri then

--                     _storage.set_number(dimmer.id, old_bri)
--                 end
--             end

--             if value.state.hue then
--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/hue"), {
--                     device_id = device_id,
--                     action = action,
--                     value = value.state.hue,
--                     item_id = item_id_map["hue"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item: hue, error: " .. errmsg)
--                 end
--             end

--             if value.state.sat then
--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/saturation"), {
--                     device_id = device_id,
--                     action = action,
--                     value = value.state.sat,
--                     item_id = item_id_map["saturation"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item: saturator, error: " .. errmsg)
--                 end
--             end

--             if value.state.effect then
--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/effect"), {
--                     device_id = device_id,
--                     action = action, value = value.state.effect,
--                     item_id = item_id_map["effect"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item:effect, error: " .. errmsg)
--                 end
--             end

--             if value.state.xy then
--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/rgbcolor"), {
--                     device_id = device_id,
--                     action = action, value = value.state.xy,
--                     item_id = item_id_map["rgbcolor"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item: color, error: " .. errmsg)
--                 end
--             end

--             if value.state.ct then
--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/color_temperature"), {
--                     device_id = device_id,
--                     action = action,
--                     value = value.state.ct,
--                     item_id = item_id_map["temperature"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item: temperature, error: " .. errmsg)
--                 end
--             end

--             if value.state.alert then
--                 success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/alert"), {
--                     device_id = device_id,
--                     action = action,
--                     value = value.state.alert,
--                     item_id = item_id_map["alert"]
--                 })
--                 if not success then
--                     _logger.error("Failed to " .. action .. " item: alert, error: " .. errmsg)
--                 end
--             end

--             success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/get_scenes"), { action = "send" })
--             if not success then
--                 _logger.error("Failed to " .. action .. " get scenes request. Error: " .. errmsg)
--             end

--             if value.state.reachable ~= nil then
--                 local device = _core.get_device(device_id)
--                 if device.reachable ~= value.state.reachable then
--                     _core.update_reachable_state(device.id, value.state.reachable)
--                 end
--             end
--         end
--     end

-- end
