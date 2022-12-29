local mdns = {}

local socket = require('socket')


local function mdns_make_query(service)
    -- header: transaction id, flags, qdcount, ancount, nscount, nrcount
    local data = '\000\000'..'\000\000'..'\000\001'..'\000\000'..'\000\000'..'\000\000'
    -- question section: qname, qtype, qclass
    for n in service:gmatch('([^%.]+)') do
        data = data..string.char(#n)..n
    end
    return data..string.char(0)..'\000\012'..'\000\001'
end


local function mdns_parse(service, data, answers)

    --- Helper function: parse DNS name field, supports pointers
    -- @param data     received datagram
    -- @param offset    offset within datagram (1-based)
    -- @return  parsed name
    -- @return  offset of first byte behind name (1-based)
    local function parse_name(data, offset)
        local n,d,l = '', '', data:byte(offset)
        while (l > 0) do
            if (l >= 192) then -- pointer
                local p = (l % 192) * 256 + data:byte(offset + 1)
                return n..d..parse_name(data, p + 1), offset + 2
            end
            n = n..d..data:sub(offset + 1, offset + l)
            offset = offset + l + 1
            l = data:byte(offset)
            d = '.'
        end
        return n, offset + 1
    end

    --- Helper function: check if a single bit is set in a number
    -- @param val       number
    -- @param mask      mask (single bit only)
    -- @return  true if bit is set, false if not
    local function bit_set(val, mask)
        return val % (mask + mask) >= mask
    end

    -- decode and check header
    if (not data) then
        return nil, 'no data'
    end
    local len = #data
    if (len < 12) then
        return nil, 'truncated'
    end

    local header = {
        id = data:byte(1) * 256 + data:byte(2),
        flags = data:byte(3) * 256 + data:byte(4),
        qdcount = data:byte(5) * 256 + data:byte(6),
        ancount = data:byte(7) * 256 + data:byte(8),
        nscount = data:byte(9) * 256 + data:byte(10),
        arcount = data:byte(11) * 256 + data:byte(12),
    }
    if (not bit_set(header.flags, 0x8000)) then
        return nil, 'not a reply'
    end
    if (bit_set(header.flags, 0x0200)) then
        return nil, 'TC bit is set'
    end
    if (header.ancount == 0) then
        return nil, 'no answer records'
    end

    -- skip question section
    local name
    local offset = 13
    if (header.qdcount > 0) then
        for i=1, header.qdcount do
            if (offset > len) then
                return nil, 'truncated'
            end
            name, offset = parse_name(data, offset)
            offset = offset + 4
        end
    end


	local function process_answer(answers, data, offset)
        local type = data:byte(offset + 0) * 256 + data:byte(offset + 1)
        local rdlength = data:byte(offset + 8) * 256 + data:byte(offset + 9)
        local rdoffset = offset + 10

        -- A record (IPv4 address)
        if (type == 1) then
            if (rdlength ~= 4) then
                return nil, 'bad RDLENGTH with A record'
            end
            answers.a[name] = string.format('%d.%d.%d.%d', data:byte(rdoffset + 0), data:byte(rdoffset + 1), data:byte(rdoffset + 2), data:byte(rdoffset + 3))
        end

        -- PTR record (pointer)
        if (type == 12) then
            local target = parse_name(data, rdoffset)
            table.insert(answers.ptr, target)
        end

        -- AAAA record (IPv6 address)
        if (type == 28) then
            if (rdlength ~= 16) then
                return nil, 'bad RDLENGTH with AAAA record'
            end
            local offs = rdoffset
            local aaaa = string.format('%x', data:byte(offs) * 256 + data:byte(offs + 1))
            while (offs < rdoffset + 14) do
                offs = offs + 2
                aaaa = aaaa..':'..string.format('%x', data:byte(offs) * 256 + data:byte(offs + 1))
            end

            -- compress IPv6 address
            for _, s in ipairs({ ':0:0:0:0:0:0:0:', ':0:0:0:0:0:0:', ':0:0:0:0:0:', ':0:0:0:0:', ':0:0:0:', ':0:0:' }) do
                local r = aaaa:gsub(s, '::')
                if (r ~= aaaa) then
                    aaaa = r
                    break
                end
            end
            answers.aaaa[name] = aaaa
        end

        -- SRV record (service location)
        if (type == 33) then
            if (rdlength < 6) then
                return nil, 'bad RDLENGTH with SRV record'
            end
            answers.srv[name] = {
                target = parse_name(data, rdoffset + 6),
                port = data:byte(rdoffset + 4) * 256 + data:byte(rdoffset + 5)
            }
        end
		return true
	end
    -- evaluate answer section
    for i=1, header.ancount do
        if (offset > len) then
            return nil, 'truncated'
        end

        name, offset = parse_name(data, offset)
		local worked, err = process_answer(answers, data, offset)
		if worked == nil then return nil, err end 
        -- next answer record
        offset = offset + 10 + (data:byte(offset + 8) * 256 + data:byte(offset + 9))
    end
-- evaluate additionals section
	if (header.arcount > 0) then
		for i=1, header.arcount do
			if (offset > len) then
				return nil, 'truncated'
			end

			name, offset = parse_name(data, offset)
			local worked, err = process_answer(answers, data, offset)
			if worked == nil then return nil, err end 
			-- next answer record
			offset = offset + 10 + (data:byte(offset + 8) * 256 + data:byte(offset + 9))
		end
	end
    return answers
end

--
function mdns.query(service, timeout)

    -- browse all services if no service name specified
    local browse = false
    if (not service) then
        service = '_services._dns-sd._udp'
        browse = true
    end

    -- append .local if needed
    if (service:sub(-6) ~= '.local') then
        service = service..'.local'
    end

    -- default timeout: 2 seconds
    local timeout = timeout or 2.0

    -- create IPv4 socket for multicast DNS
    local ip, port, udp = '224.0.0.251', 5353, socket.udp()
    assert(udp:setsockname('*', 0))
    assert(udp:setoption('ip-add-membership', { interface = '*', multiaddr = ip }))
    assert(udp:settimeout(0.1))

    -- send query
    assert(udp:sendto(mdns_make_query(service), ip, port))

    -- collect responses until timeout
    local answers = { srv = {}, a = {}, aaaa = {}, ptr = {} }
    local start = os.time()
    while (os.time() - start < timeout) do
        local data, peeraddr, peerport = udp:receivefrom()
        if data and (peerport == port) then
            mdns_parse(service, data, answers)
            if (browse) then
                for _, ptr in ipairs(answers.ptr) do
                    assert(udp:sendto(mdns_make_query(ptr), ip, port))
                end
                answers.ptr = {}
            end
        end
    end

    -- cleanup socket
    assert(udp:setoption("ip-drop-membership", { interface = "*", multiaddr = ip }))
    assert(udp:close())
    udp = nil

    -- extract target services from answers, resolve hostnames
    local services = {}
    for k,v in pairs(answers.srv) do
        --print("****************************data, peeraddr, peerport************************************")		
        --print(k,v)
        --print("****************************data, peeraddr, peerport************************************")		
        
        local pos = k:find('%.')
        if (pos and (pos > 1) and (pos < #k)) then
            local name, svc = k:sub(1, pos - 1), k:sub(pos + 1)
            if (browse) or (svc == service) then
                if (v.target) then
                    if (answers.a[v.target]) then
                        v.ipv4 = answers.a[v.target]
                    end
                    if (answers.aaaa[v.target]) then
                        v.ipv6 = answers.aaaa[v.target]
                    end
                    if (v.target:sub(-6) == '.local') then
                        v.hostname = v.target:sub(1, #v.target - 6)
                    end
                    v.target = nil
                end
                v.service = svc
                v.name = name
                services[k] = v
            end
        end
    end

    return services
end




function findLast(haystack, needle)
    local i=haystack:match(".*"..needle.."()")
    if i==nil then return nil else return i-1 end
end

local listBrands = {'masb','teamviewer','sonos','shelly','lutron','sonoff','somfy','apple','macbook','airTunes','airplay','honeywell','dmp','alk','venstar','harman','doorbird','hayward','milight','samsung','roku','ipbridge','android','philips','hue'}


local StoreSingleIp=false   --set true to filter unique devices [devices exist with diffent ports on same IP]
local listBrandsfilter=false --set this true to filter from "listBrands"


local booldevFound = false
local StoreSingleIpArr={}

local remoteDevAttr ={DevType="",DevName="",DevIP4="",DevIP6="",DevPort="",DevServ="",DevPacket=""}
local DeviceArray={}
local DeviceArrayFiltered={}
local PacketStr =""
local devIdentifier={}
local devicesCounter=0

local res = mdns.query(false, 20)
if (res) then
    local devtype = "mDns"
    for k,v in pairs(res) do
        --print(1,k)
        remoteDevAttr.DevType = devtype
        devicesCounter = devicesCounter+1

        for k1,v1 in pairs(v) do
            --print(2,'  '..k1..': '..v1)
            PacketStr = PacketStr .. tostring(v1) .. ", "            
            if string.find(k1, "hostname") then

   
                    remoteDevAttr.DevName = tostring(v1)  

                    booldevFound=false
                    if listBrandsfilter then
                      for k,v in pairs(listBrands) do
                        if string.find(string.lower(v1), string.lower(v)) then
                            booldevFound = true
                        end
                      end
                    
                      if not booldevFound then
                        PacketStr =""
                        goto continue
                      end

                    end
                
            elseif string.find(k1, "ipv4") then
                remoteDevAttr.DevIP4 = tostring(v1)
            elseif string.find(k1, "ipv6") then
                remoteDevAttr.DevIP6 = tostring(v1)
            elseif string.find(k1, "port") then
                remoteDevAttr.DevPort = tostring(v1)
            elseif string.find(k1, "service") then
                remoteDevAttr.DevServ = tostring(v1)
            end
            
        end

        remoteDevAttr.DevPacket = string.sub(PacketStr,1,#PacketStr -2)        
        PacketStr=""                
        
        if(StoreSingleIp) then
            if StoreSingleIpArr[remoteDevAttr.DevIP4]==nil then
                --local ip4LastOct = string.sub(remoteDevAttr.DevIP4,findLast(remoteDevAttr.DevIP4,'%.')+1,#remoteDevAttr.DevIP4)                
                table.insert(DeviceArrayFiltered,remoteDevAttr)--remoteDevAttr.DevIP4,                
                StoreSingleIpArr[remoteDevAttr.DevIP4]= remoteDevAttr.DevIP4
                print("Filtered",#StoreSingleIpArr,#DeviceArrayFiltered,remoteDevAttr.DevPacket,ip4LastOct)
            else
                print("Filtered","Already Found",remoteDevAttr.DevPacket)
            end
        
        else
            --print(remoteDevAttr.DevIP4)
            table.insert(DeviceArray,remoteDevAttr)
            print("UnFiltered",#DeviceArray,remoteDevAttr.DevPacket)
        end

        --            print(#DeviceArray,remoteDevAttr.DevPacket)
        ::continue::
    end
else    
    print('no result')
end
