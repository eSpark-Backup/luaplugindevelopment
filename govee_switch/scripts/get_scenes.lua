local _logger = require("logging")
local _http = require("http")
local _storage = require("storage")
local _core = require("core")

local params = ... or {}

local function sendRequest()

    local username = _storage.get_string("username")
    local ip
    local setting_ids = _core.get_setting_ids_by_device_id(_G.govee_smartleds_rgbic)
    for _, setting_id in pairs(setting_ids) do
        if _core.get_setting(setting_id).info.name == "device_ip" then
            ip = _core.get_setting(setting_id).value
        end
    end

    _logger.debug("Start sending request to device with ip:" .. ip)
    local success, msg = pcall(_http.request, {
        skip_security = true,
        url = "http://" .. ip .. "/api/" .. username .. "/scenes",
        handler = "HUB:ezlo.govee/scripts/get_scenes",
        type = "GET",
        headers = {
            ["Expect"] = "",
            ["Transfer-Encoding"] = ""
        }
    })

    if not success then
        _logger.error("Failed to make HTTP request: " .. msg)
    end
end

local function receiveData()
    local _json = require("json")

    local response = _json.decode(params.data.data)

    if response == nil then
        _logger.info("Empty scene list")
        return
    end

    local names = { "-" }
    local data = {}

    for key, value in pairs(response) do
        table.insert(names, value.name)
        data[key] = value
    end

    local scene_item
    local items = _core.get_items_by_device_id(_G.govee_smartleds_rgbic)
    if items then
        for _, item in ipairs(items) do
            if item.name == "scene" then
                scene_item = item
            end
        end
    end

    local value, item_id
    local action = "create"
    if scene_item then
        action = "set"
        value = scene_item.value
        item_id = scene_item.id
    end
    success, errmsg = pcall(loadfile("HUB:ezlo.govee/scripts/items/scene"), {
        device_id = _G.govee_smartleds_rgbic,
        action = action,
        data = data,
        enum = names,
        value = value,
        item_id = item_id
    })
    if not success then
        _logger.error("Failed to " .. action .. " item: switch, error: " .. errmsg)
    end
end

----------------------------------------------------------------------

if params.action == "send" then
    sendRequest()
elseif params.event == "http_data_received" then
    receiveData()
end
