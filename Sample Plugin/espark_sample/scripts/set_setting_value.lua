local _core = require("core")
local _logger = require("logging")
local _utils = require("HUB:espark_sample/scripts/modules/utils")


local function FindInList (value, array)
    for _, item in ipairs(array) do
        if value == item then
            return true
        end
    end

    return false
end


local function SyncChildrenDevices (type, setting, value)
    local dsc_id_list = {}

    for number in value:gmatch("%d+") do
        local dsc_id = type .. "_" .. number
        table.insert(dsc_id_list, dsc_id)
    end

    local devices_to_remove = {}

    for _, device in ipairs(_core.get_devices() or {}) do
        if device.parent_device_id == setting.device_id and device.device_type_id == "dsc_" .. type then
            if not FindInList(device.info.id, dsc_id_list) then
                table.insert(devices_to_remove, device.id)
            end
        end
    end

    local devices_to_add = {}

    for _, dsc_id in ipairs(dsc_id_list) do
        local found = false

        for _, device in ipairs(_core.get_devices() or {}) do
            if device.parent_device_id == setting.device_id and device.info.id == dsc_id then
                found = true
                break
            end
        end

        if not found then
            table.insert(devices_to_add, dsc_id)
        end
    end

    for _, device_id in ipairs(devices_to_remove) do
        _logger.info("Remove " .. _core.get_device(device_id).info.id .. " device " .. device_id)
        _core.remove_device(device_id)
    end

    for _, dsc_id in ipairs(devices_to_add) do
        local add_device_function

        if type == "zone" then
            add_device_function = _utils.AddZoneDevice
        else
            add_device_function = _utils.AddPartitionDevice
        end

        add_device_function(setting.device_id, dsc_id)
    end
end


--------------------------------------------------------------------------------

local params = ... or {}

_core.set_setting_value(params.setting_id, params.value, "synced")

local setting = _core.get_setting(params.setting_id)

local type

if setting.info.name == "zones" then
    type = "zone"
else
    type = "partition"
end

SyncChildrenDevices(type, setting, params.value)
