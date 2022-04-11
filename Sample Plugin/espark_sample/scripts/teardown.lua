local _logger = require("logging")
local _core = require("core")
local _storage = require("storage")

_logger.warning("Start DSC alarm panel plugin teardown")

_logger.warning("Remove all devices")
_core.remove_gateway_devices(_core.get_gateway().id)

_logger.warning("Clear storage")
_storage.delete_all()

_logger.warning("The sample plugin teardown complete")
