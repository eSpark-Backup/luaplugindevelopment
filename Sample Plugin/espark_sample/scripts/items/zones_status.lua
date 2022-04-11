local _core = require("core")
local _logger = require("logging")


local params = ... or {}

local partition_device = _core.get_device(params.device_id)
local panel_device_id = partition_device.parent_device_id

local command, pin_code

if params.value == "disarmed" then
    _logger.info("Disarm " .. partition_device.info.id)
    command = _G.dsc.commands.DISARM

    local _storage = require("storage")
    local dsc_storage = _storage.get_table("dsc") or {}

    pin_code = dsc_storage[panel_device_id].pin_code

else
    _logger.info("Arm " .. partition_device.info.id .. " in '" .. params.value .. "' mode")
    command = (params.value == "stay") and _G.dsc.commands.ARM_STAY or _G.dsc.commands.ARM_AWAY
end

local wait = loadfile("HUB:espark_sample/scripts/handlers/network") {
    action = "send",
    device_id = panel_device_id,
    command = command,
    data = partition_device.info.id:match("%d$") .. (pin_code or "")
}

if not wait then
    _logger.error("Failed to send arming/disarming command")
    return
end
