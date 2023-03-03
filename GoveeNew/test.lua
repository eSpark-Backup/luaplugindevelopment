--https://gist.github.com/filewalkwithme/2865500

function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
      table.insert(t,cap)
       end
       last_end = e+1
       s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
       cap = str:sub(last_end)
       table.insert(t, cap)
    end
    return t
 end
 
 
mac_dest = "FC:3F:DB:08:F8:3F"   --here use the MAC Address of your LAN interface
 
 socket = require("socket")
 ip="239.255.255.250"
 port=4002     --6000 can also be used
 udp = assert(socket.udp())
 udp:setoption('broadcast', true)
 udp:setsockname("*", 0)   -- commenting this may result refuse
 udp:settimeout(0)   


 mac_array=split(mac_dest, ":")
 mac = ""
 for i,v in ipairs(mac_array) do mac = mac..string.char(tonumber("0x"..v));  end
 mac1=""
 for i=1,16 do
  mac1 = mac1..mac
 end
mac2 = string.char(0xff,0xff,0xff,0xff,0xff,0xff)..mac1		--This is a magic packet data
assert(udp:sendto(mac2, ip, port))
 print("Wake-On-Lan packet sent to MAC address ")