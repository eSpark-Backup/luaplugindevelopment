local _core = require("core")
local _logger = require("logging")
local _storage = require("storage")
local _utils = require("HUB:espark_sample/scripts/modules/utils")

--local DEFAULT_PORT = 4025


local params = ... or {}

local dsc_storage = _storage.get_table("dsc") or {}

--[[for _, device_storage in pairs(dsc_storage) do
    if params.ip == device_storage.ip then
        _logger.error("A device with the same IP already exists")

        _core.send_ui_broadcast {
            status = "add_device_fail",
            error = "A device with the same IP already exists"
        }

        return
    end
end--]]

_logger.info("Add new sample device")

local panel_device_id = _core.add_device {
        type = "device",
        device_type_id = "device_sample",
        category = "general",
        battery_powered = false,
        gateway_id = _core.get_gateway().id,
        name = params.name,
        reachable = true
    }

if not panel_device_id then
    _logger.error("Failed to create sample device")

    _core.send_ui_broadcast {
        status = "add_device_fail",
        error = "Failed to add device"
    }

    return
end

_logger.info("Created device with ID: " .. panel_device_id)

--if (params.port or "") == "" then
  --  params.port = DEFAULT_PORT
--end

dsc_storage[panel_device_id] = {
    ip = params.ip,
    --port = params.port,
    password = params.password,
    --pin_code = params.pin_code
}

_storage.set_table("dsc", dsc_storage)

if (params.partitions or "") == "" then
    params.partitions = "1"
end

_logger.info("Add device setting for partitions: " .. params.partitions)

_core.add_setting {
        device_id = panel_device_id,
        label = {
            text = "Partitions"
        },
        description = {
            text = "Comma separated list of active partition numbers, e.g. if only partitions 1 and 2 are in use, you should write: 1,2"
        },
        value_type = "string",
        value = params.partitions,
        info = {
            name = "partitions"
        }
    }

if (params.zones or "") == "" then
    params.zones = "1"
end

--_logger.info("Add device setting for zones: " .. params.zones)

--_core.add_setting {
    --device_id = panel_device_id,
    --label = {
    --    text = "Zones"
    --},
    --description = {
    --    text = "Comma separated list of active zone numbers, e.g. if only zones 2, 4, and 5 are in use, you should write: 2,4,5"
    --},
    --value_type = "string",
    --value = params.zones,
    --info = {
     --   name = "zones"
    --}
--}

for partition_number in params.partitions:gmatch("%d+") do
    _utils.AddPartitionDevice(panel_device_id, "partition_" .. partition_number)
end

for zone_number in params.zones:gmatch("%d+") do
    _utils.AddZoneDevice(panel_device_id, "zone_" .. zone_number)
end

_core.send_ui_broadcast {
    status = "ok",
    device_id = panel_device_id
}

loadfile("HUB:espark_sample/scripts/init") {
    action = "start_init",
    device_id = panel_device_id
}
