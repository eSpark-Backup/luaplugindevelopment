local _logger = require("logging")
local _core = require("core")

local ITEM_NAME = "switch"

local params = ... or {}

local function CreateItem()
    _logger.debug("Create item switch: " .. ITEM_NAME)

    local item_id = _core.add_item({
        name = ITEM_NAME,
        value_type = "bool",
        value = params.value or false,
        has_getter = true,
        has_setter = true,
        info = {
            name = "on"
        },
        device_id = params.device_id
    })

    if item_id then
        _logger.debug("Created switch item ID: " .. item_id)
    else
        _logger.error("Failed to create item switch")
    end
end

---------------------------------------------------------------------

if params.action == "create" then
    return CreateItem()
elseif params.action == "set" then
    if not params.item_id then
        _logger.debug("There is no item to update switch")
        return
    end
    _logger.debug("Set item switch: " .. ITEM_NAME .. " value: " .. tostring(params.value))
    _core.update_item_value(params.item_id, params.value)
    
end
