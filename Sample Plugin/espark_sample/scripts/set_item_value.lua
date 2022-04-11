local _core = require("core")
local _logger = require("logging")


local params = ... or {}

local items = {}

-- {"item_id":"6149d46c12822b67258f1218","value":30}
if type(params.item_id) == "string" then
    items[params.item_id] = { value = params.value }

-- {"item_ids":["6149d46c12822b67258f121e","6149d46c12822b67258f1218"],"value":0}
elseif type(params.item_ids) == "table" then
    for _, item_id in ipairs(params.item_ids) do
        items[item_id] = { value = params.value }
    end

-- {"items":{"6149d46c12822b67258f1218":{"value":30},"6149d46c12822b67258f121e":{"value":1}}}
elseif type(params.items) == "table" then
    items = params.items
end


for item_id, item_params in pairs(items) do
    local item = _core.get_item(item_id)

    local item_script = loadfile("HUB:espark_sample/scripts/items/" .. item.name)
    if not item_script then
        _logger.error("Failed to load handler for item: " .. item.name)
        _core.send_ui_broadcast {
            status = "set_item_fail",
            error = "Failed to set item: " .. item.name
        }
        goto continue
    end

    local success, errmsg = pcall(item_script, {
            device_id = item.device_id,
            item_id = item_id,
            value = item_params.value
        })

    if not success then
        _logger.error("Failed to set item: " .. item.name .. ", error: " .. errmsg)
        _core.send_ui_broadcast {
            status = "set_item_fail",
            error = "Failed to set item: " .. item.name
        }
    end

    ::continue::
end
