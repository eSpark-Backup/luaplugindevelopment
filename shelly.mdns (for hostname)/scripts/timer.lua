--[[ 


local timer = require("timer")
local network = require("network")


 
local sockets = network.get_sockets()
print(type(sockets))
print(sockets)

for k,v in pairs(sockets) do
     print(k,v)
end

for i,j in ipairs(sockets) do
     print(i,j)
end


 ]]