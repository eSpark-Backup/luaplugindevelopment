local _logger = require("logging")
local _core = require("core")

local ITEM_NAME = "rgbcolor"

local function CreateItem(device_id, value)
    _logger.debug("Create item: " .. ITEM_NAME)

    local item_id = _core.add_item {
        device_id = device_id,
        name = ITEM_NAME,
        value_type = "rgb",
        value = {
            red = value.red,
            green = value.green,
            blue = value.blue
        },
        has_getter = true,
        has_setter = true,
        info = {
            name = "xy"
        }
    }

    if item_id then
        _logger.debug("Created item ID: " .. item_id)
    else
        _logger.error("Failed to create item")
    end
end

local function SetItemValue(item_id, value)

    _core.update_item_value(item_id, { red = value.red, green = value.green, blue = value.blue })
end

---------------------------------------------------------------------

local params = ... or {}

if params.value[1] then
    local XYToRGB = loadfile("HUB:ezlo.govee/scripts/functions/xy_to_rgb")

    if not XYToRGB then
        _logger.error("Failed to load function xy_to_rgb")
        return
    end

    local brightness
    local items = _core.get_items_by_device_id(params.device_id)
    if items then
        for _, item in ipairs(items) do
            if item.name == "dimmer" then
                brightness = item.value
            end
        end
    end

    local success, RGB = pcall(XYToRGB, {
        value = params.value,
        brightness = brightness
    })
    if not success then
        _logger.error("Fail while transforming XY to RGB")
        return
    end

    params.value.red = RGB.red
    params.value.green = RGB.green
    params.value.blue = RGB.blue

end
params.value.red = params.value.red or 0
params.value.green = params.value.green or 0
params.value.blue = params.value.blue or 0

if params.action == "create" then
    return CreateItem(params.device_id, params.value)
elseif params.action == "set" then
    if not params.item_id then
        _logger.debug("There is no item to update")
        return
    end
    _logger.debug("Set item: " ..
        ITEM_NAME .. " value: " .. params.value.red .. " " .. params.value.green .. " " .. params.value.blue)
    SetItemValue(params.item_id, params.value)
end
