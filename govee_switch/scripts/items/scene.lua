local _logger = require("logging")
local _core = require("core")

local ITEM_NAME = "scene"

local params = ... or {}

local function CreateItem()
    _logger.debug("Create item: " .. ITEM_NAME)

    local item_id = _core.add_item({
        device_id = params.device_id,
        name = ITEM_NAME,
        value_type = "token",
        value = params.enum[1],
        has_getter = true,
        has_setter = true,
        enum = params.enum,
        info = {
            subdata = params.data
        }
    })

    if item_id then
        _logger.debug("Created item ID: " .. item_id)
    else
        _logger.error("Failed to create item")
    end
end

local function UpdateItem()
    if not params.item_id then
        _logger.debug("There is no item to update")
        return
    end
    _logger.debug("Set item: " .. ITEM_NAME .. " value: " .. params.value)
    local item = _core.get_item(params.item_id)

    local modify_flag = false
    for i, value in ipairs(params.enum) do
        if item.enum[i] ~= value then
            modify_flag = true
        end
    end

    if modify_flag then
        _core.modify_item(item.id, {
            device_id = params.device_id,
            name = ITEM_NAME,
            value_type = "token",
            value = params.value,
            has_getter = true,
            has_setter = true,
            enum = params.enum,
            info = {
                subdata = params.data
            }
        })
    else
        _core.update_item_value(params.item_id, params.value)

    end
end

--------------------------------------------------------------------------

if params.action == "create" then
    return CreateItem()
elseif params.action == "set" then
    return UpdateItem()
end
