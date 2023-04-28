local _core = require("core")
local _logger = require("logging")

local function CreateDevice(device_name)

    if not device_name or device_name == "" then
        _logger.error("Empty device name. Cannot create device")
        return
    end

    local device_id = _core.add_device {
        -- name = device_name,
        -- type = "controller.remote",
        -- device_type_id = "ezlo.govee",
        -- category = "remote",
        -- battery_powered = false,
        -- gateway_id = _core.get_gateway().id
    
        name = device_name,
        type = "switch.outlet",
        device_type_id = "ezlo.govee",
        category = "switch",
        subcategory = "interior_plugin",
        battery_powered = false,
        gateway_id = _core.get_gateway().id
    }
    
    if not device_id then
        _logger.error("Failed to create device")
        return
    end

    _G.govee_smartleds_rgbic = device_id
    _logger.info("**************Created " .. device_name .. " with ID: " .. device_id)

end

local params = ... or {}

if params.devices and type(params.devices) == "table" then
    for _, hue_params in ipairs(params.devices) do
        CreateDevice(hue_params.device_name)
    end
else
    CreateDevice(params.device_name)
end