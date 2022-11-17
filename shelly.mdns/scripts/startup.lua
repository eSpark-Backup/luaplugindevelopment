local logging = require ("logging")
--local http = require ("http")
logging.info("The plugin has been started successfully")



require "network"

handle = network.connect( { ip = "127.0.0.1", port = "80", connection_type = "TCP" } )
if not handle then
   print( "fail to connect" )
else
   print( "connection successful" )
end




 