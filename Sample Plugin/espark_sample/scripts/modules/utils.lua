local _core = require("core")
local _logger = require("logging")


local _M = {}


function _M.AddPartitionDevice (panel_device_id, partition_id)
    _logger.info("Add " .. partition_id .. " device to panel device " .. panel_device_id)

    local partition_device_id = _core.add_device {
            parent_device_id = panel_device_id,
            type = "device",
            device_type_id = "device_sample",
            category = "general",
            name = "Device " .. partition_id:match("%d+"),
            info = {
                id = partition_id
            },
            battery_powered = false,
            gateway_id = _core.get_gateway().id,
            reachable = true,
            ready = true
        }

    if not partition_device_id then
        _logger.error("Failed to create " .. partition_id .. " device")
        return
    end

    _logger.info("Created " .. partition_id .. " device " .. partition_device_id)

    _M.AddItem(partition_device_id, "zones_status", "token", "disarmed", { "disarmed", "stay", "away" }, 3)
end


--[[function _M.AddZoneDevice (panel_device_id, zone_id)
    _logger.info("Add " .. zone_id .. " motion device to panel device " .. panel_device_id)

    local zone_device_id = _core.add_device {
            parent_device_id = panel_device_id,
            type = "sensor",
            device_type_id = "dsc_zone",
            category = "security_sensor",
            subcategory = "motion",
            name = "DSC Zone " .. zone_id:match("%d+"),
            info = {
                id = zone_id
            },
            battery_powered = false,
            gateway_id = _core.get_gateway().id,
            reachable = true
        }
--]]
    if not zone_device_id then
        _logger.error("Failed to create " .. zone_id .. " device")
        return
    end

    _logger.info("Created " .. zone_id .. " device " .. zone_device_id)

    _M.AddItem(zone_device_id, "motion", "bool", false)
end


function _M.AddItem (device_id, item_name, item_type, value, enum, options)
    -- options: Bit mask where bit 0 represents "has_getter" and bit 1 represents "has_setter".
    -- By default, items are getter only, so we'll set "options" to 1.
    if options == nil then
        options = 1
    end

    _logger.info("Add '" .. item_name .. "' item to device ".. device_id)

    local item_id = _core.add_item {
            device_id = device_id,
            name = item_name,
            value_type = item_type,
            enum = enum,
            has_getter = options & 1 > 0,
            has_setter = options & 2 > 0,
            show = true,
            value = value
        }

    if item_id then
        _logger.info("Created '" .. item_name .. "' item " .. item_id)
    else
        _logger.error("Failed to create '" .. item_name .. "' item")
    end
end


function _M.CalculateChecksum (command, data)
    local sum = 0

    for _, byte in ipairs(table.pack(string.byte(command, 1, -1))) do
        sum = sum + byte
    end

    for _, byte in ipairs(table.pack(string.byte(data, 1, -1))) do
        sum = sum + byte
    end

    -- Truncate the sum to 8 bits.
    return string.format("%02X", sum & 0xFF)
end


function _M.UpdateReachableState (device_id, reachable)
    if reachable then
        _logger.info("Device " .. device_id .. " is reachable")
    else
        _logger.warning("Device " .. device_id .. " is unreachable")
    end

    _core.update_reachable_state(device_id, reachable)

    for _, device in ipairs(_core.get_devices() or {}) do
        if device.parent_device_id == device_id then
            _core.update_reachable_state(device.id, reachable)
        end
    end
end


return _M
