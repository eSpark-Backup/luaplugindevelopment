local _logger = require("logging")
local _json = require("json")

local params = ...

if params.event == "http_connection_closed" then

    return
end

if params.event == "http_data_received" then
    local response = _json.decode(params.data.data)
    _logger.debug(params.data.data)
    if response[1] == error then
        _logger.error(_json.encode(response[1]))
        return
    end
    
    local set_item_table = _G.philips_hue.requests[params.data.id]

    local item_script = loadfile("HUB:ezlo.govee/scripts/items/" .. set_item_table.item_name)
    if not item_script then
        _logger.error("Failed to load handler for item: " .. set_item_table.item_name)
        _core.send_ui_broadcast ({
            status = "error",
            message = "Failed to set item: " .. set_item_table.item_name
        })
        return
    end
    
    local success, errmsg = pcall(item_script, set_item_table )

    if not success then
        _logger.error("Failed to set item: " .. set_item_table.item_name .. ", error: " .. errmsg)
        _core.send_ui_broadcast ({
            status = "error",
            message = "Failed to set item: " .. set_item_table.item_name
        })
    end
end

