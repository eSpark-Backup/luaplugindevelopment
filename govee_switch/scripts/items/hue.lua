local _logger = require("logging")
local _core = require("core")

local ITEM_NAME = "hue"

local params = ... or {}

local function CreateItem()
    _logger.debug("Create item: " .. ITEM_NAME)

    local item_id = _core.add_item({
        name = ITEM_NAME,
        value_type = "int",
        has_getter = true,
        has_setter = true,
        value = params.value,
        value_min = 1,
        value_max = 65535,
        device_id = params.device_id,
        info = {
            name = "hue"
        }
    })

    if item_id then
        _logger.debug("Created item ID: " .. item_id)
    else
        _logger.error("Failed to create item")
    end
end

--------------------------------------------------------------------------

if params.action == "create" then
    return CreateItem()
elseif params.action == "set" then
    if not params.item_id then
        _logger.debug("There is no item to update")
        return
    end
    _logger.debug("Set item: " .. ITEM_NAME .. " value: " .. params.value)
    _core.update_item_value(params.item_id, params.value)
end
