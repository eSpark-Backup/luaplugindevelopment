local _core = require("core")
local _logger = require("logging")
local _timer = require("timer")

local THIS_SCRIPT = "HUB:espark_sample/scripts/setup"
local DEFAULT_PORT = 4025
local TIMER_ID = "dsc_test"


local function TestConfiguration (params)
    if _timer.exists(TIMER_ID) then
        return _core.send_ui_broadcast {
            status = "test_in_progress",
            error = "A test is already in progress"
        }
    end

    local port = tonumber(params.port) or DEFAULT_PORT

    local wait = loadfile("HUB:espark_sample/scripts/handlers/network") {
            action = "connect",
            device_id = _G.dsc.const.TEST_DEV_ID,
            ip = params.ip,
            port = port,
            password = params.password
        }

    if not wait then
        return _core.send_ui_broadcast {
            status = "tcp_connection_error",
            error = "An internal error occurred while trying to connect to the EnvisaLink"
        }
    end

    _G.dsc.test_params = {
        ip = params.ip,
        port = port,
        password = params.password,
        name = params.name,
        pin_code = params.pin_code
    }

    _timer.set_timeout_with_id(15000, TIMER_ID, THIS_SCRIPT, { connected = false })
end


local function AddPanelDevice (params)
    local _storage = require("storage")

    local dsc_storage = _storage.get_table("dsc") or {}

    for device_id, device_storage in pairs(dsc_storage) do
        if params.ip == device_storage.ip then
            return _core.send_ui_broadcast {
                status = "add_device_fail",
                error = "A device with the same IP already exists & this is setup"
            }
        end
    end

    _logger.info("Add new alarm panel device")

    local device_id = _core.add_device {
            type = "device",
            device_type_id = "dsc_alarm_panel",
            category = "alarm_panel",
            battery_powered = false,
            gateway_id = _core.get_gateway().id,
            name = params.name,
            reachable = true
        }

    if not device_id then
        _logger.error("Failed to create alarm panel device")
        return _core.send_ui_broadcast {
            status = "add_device_fail",
            error = "Failed to add device"
        }
    end

    _logger.info("Created device with ID: " .. device_id)

    dsc_storage[device_id] = {
        ip = params.ip,
        port = params.port,
        password = params.password,
        pin_code = params.pin_code
    }

    _storage.set_table("dsc", dsc_storage)

    _core.send_ui_broadcast {
        status = "ok",
        device_id = device_id
    }

    loadfile("HUB:espark_sample/scripts/init") {
        action = "start_init",
        device_id = device_id
    }
end


local function AddZoneDevice_Motion (params)
    local zone_id = "zone_" .. params.zone_number

    _logger.info("Add " .. zone_id .. " motion device to panel device " .. params.panel_device_id)

    local device_id = _core.add_device {
            parent_device_id = params.panel_device_id,
            type = "sensor",
            device_type_id = "dsc_zone",
            category = "security_sensor",
            subcategory = "motion",
            name = params.name,
            info = {
                id = zone_id
            },
            battery_powered = false,
            gateway_id = _core.get_gateway().id,
            reachable = true
        }

    if not device_id then
        _logger.error("Failed to create " .. zone_id .. " device")
        return _core.send_ui_broadcast {
            status = "add_device_fail",
            error = "Failed to add device"
        }
    end

    _logger.info("Created " .. zone_id .. " device " .. device_id)

    _core.send_ui_broadcast {
        status = "ok",
        device_id = device_id
    }

    local _utils = require("HUB:ezlo_dsc/scripts/modules/utils")
    _utils.AddItem(device_id, "motion", "bool", false)

    loadfile("HUB:ezlo_dsc/scripts/init") {
        action = "get_status_report",
        device_id = params.panel_device_id
    }
end


local function UpdateConfiguration (params)
    local _storage = require("storage")

    local dsc_storage = _storage.get_table("dsc") or {}
    local device_id = params.device_id

    if not dsc_storage[device_id] then
        return _core.send_ui_broadcast {
            status = "configuration_not_found",
            error = "No configuration found for this device"
        }
    end

    local reinit = false

    if params.ip then
        if not params.ip:match("%d+%.%d+%.%d+%.%d+") then
            return _core.send_ui_broadcast {
                status = "invalid_ip",
                error = "Invalid IP address"
            }
        end

        dsc_storage[device_id].ip = params.ip
        reinit = true
    end

    if params.port then
        dsc_storage[device_id].port = params.port
        reinit = true
    end

    if params.password then
        dsc_storage[device_id].password = params.password
        reinit = true
    end

    if params.pin_code then
        dsc_storage[device_id].pin_code = params.pin_code
    end

    _storage.set_table("dsc", dsc_storage)

    _core.send_ui_broadcast {
        status = "ok",
        device_id = device_id
    }

    if reinit then
        loadfile("HUB:espark_sample/scripts/init") {
            action = "start_init",
            device_id = device_id
        }
    end
end


local function ValidateInput (params, required_params)
    for _, req_param in ipairs(required_params) do

        if (params[req_param] or "") == "" then
            _core.send_ui_broadcast {
                status = "missing_parameter",
                error = "Missing '" .. req_param .. "' parameter"
            }

            return false
        end

        if req_param == "ip" and not params.ip:match("%d+%.%d+%.%d+%.%d+") then
            _core.send_ui_broadcast {
                status = "invalid_ip",
                error = "Invalid IP address"
            }

            return false
        end
    end

    return true
end

--------------------------------------------------------------------------------

local params = ... or {}

if params.action == "add_panel_device" then
    if not ValidateInput(params, { "ip", "password", "name", "pin_code" }) then
        return
    end

    return TestConfiguration(params)

elseif params.action == "add_zone_device_motion" then
    if not ValidateInput(params, { "panel_device_id", "zone_number", "name" }) then
        return
    end

    return AddZoneDevice_Motion(params)

elseif params.action == "update_configuration" then
    if not ValidateInput(params, { "device_id" }) then
        return
    end

    return UpdateConfiguration(params)

elseif params.connected ~= nil then
    if params.connected == false then
        _timer.cancel(TIMER_ID)

        _core.send_ui_broadcast  {
            status = "invalid_ip",
            error = "Failed to connect to the given IP and port"
        }

        _G.dsc.test_params = nil
    end

elseif params.session_established ~= nil then
    _timer.cancel(TIMER_ID)

    loadfile("HUB:ezlo_dsc/scripts/handlers/network") {
        action = "disconnect",
        device_id = _G.dsc.const.TEST_DEV_ID
    }

    if params.session_established then
        AddPanelDevice(_G.dsc.test_params)
    else
        _core.send_ui_broadcast  {
            status = "invalid_password",
            error = "Invalid password"
        }
    end

    _G.dsc.test_params = nil

else
    return _core.send_ui_broadcast {
        status = "missing_parameter",
        error = "Missing or invalid 'action' parameter"
    }
end
