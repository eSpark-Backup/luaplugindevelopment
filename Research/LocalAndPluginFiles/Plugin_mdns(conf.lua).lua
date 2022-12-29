-- local logging = require("logging")

-- logging.info("The plugin has been configured successfully")


 

-- param = ... or {}

-- local ip_addresses = "192.168.18.1 - 192.168.18.200"
-- local ports = "" --80  2020, 30, 8080
-- local ip_version = "IPv4" -- or IPv6
-- local script = "HUB:shelly.mdns/scripts/handle_network_scan_results"

-- --If user has entered any of the following variables then use them
-- 	if type(param.version) == "string" and (param.version) then
-- 		logging.info("Selected version of IP ="..param.version)
-- 		ip_version = param.version
--     else
--         logging.info("Selected version of IP ="..ip_version)
-- 	end
-- 	if type(param.ports) == "number" and (param.ports) then               -- 80
-- 		logging.info("Selected value for param.ports ="..param.ports)
-- 		ports = param.ports
--     else        
--         logging.info("Selected value for param.ports ="..ports)
-- 	end
-- 	if type(param.range) == "string" and (param.range) then                 --192.168.18.1 - 192.168.18.254
-- 		logging.info("Selected value for param.range ="..param.range)
-- 		ip_addresses = param.range
--     else
--         logging.info("Selected value for param.range ="..ip_addresses)
-- 	end

--     logging.info("Starting scanning network for ipranges ="..ip_addresses .." and port(s) = "..ports)
--     scan_id = network.start_scan_network(script, ip_addresses, ip_version, ports)
    
--     network.dns.tohostname(ip_addresses)
-- 	--socket.dns.tohostname(address)


--local socket = require('socket')

local network = require("network")
local mdns = {}

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


--- Locate MDNS services in local network
--
-- @param service   MDNS service name to search for (e.g. _ipps._tcp). A .local postfix will 
--                  be appended if needed. If this parameter is not specified, all services
--                  will be queried.
--
-- @param timeout   Number of seconds to wait for MDNS responses. The default timeout is 2 
--                  seconds if this parameter is not specified.
--
-- @return          Table of MDNS services. Entry keys are service identifiers. Each entry
--                  is a table containing all or a subset of the following elements:
--
--                      name: MDNS service name (e.g. HP Laserjet 4L @ server.example.com)
--                      service: MDNS service type (e.g. _ipps._tcp.local)
--                      hostname: hostname
--                      port: port number
--                      ipv4: IPv4 address
--                      ipv6: IPv6 address
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
        service = service..'.local'--_services._dns-sd._udp.local
    end

    -- default timeout: 20 seconds
    local timeout = timeout or 20.0

	local ip = '224.0.0.251'
	local port = 5353
	local handle = network.udp()

    --assert(udp:setsockname(handle,'*', 0))
	network.setsockname(handle, "*",5353)--"*", "5353"--8021,5353, 80  2020, 30, 8080
                                                --'224.0.0.251', "239.192.1.1"

    network.setoption(handle, 'ip-add-membership')--ip-add-membership

	assert(network.sendto(handle,mdns_make_query(service), ip, port))

    -- collect responses until timeout
    local answers = { srv = {}, a = {}, aaaa = {}, ptr = {} }
    local start = os.time()
    while (os.time() - start < timeout) do
        local data, peeraddr, peerport = network.receivefrom(handle)
        print("*************************111111111111111111111111111111************************** ")
        print(data, peeraddr, peerport)
        print("*************************222222222222222222222222222222************************** ")
        if data and (peerport == port) then
            mdns_parse(service, data, answers)
            if (browse) then
                for _, ptr in ipairs(answers.ptr) do
                    assert(network.sendto(handle,mdns_make_query(ptr), ip, port))
                end
                answers.ptr = {}
            end
        end
    end

    -- cleanup socket
	print("network.setoption network.setoption network.setoption network.setoption ")
    --assert(network.setoption(handle,"ip-drop-membership", { interface = "*", multiaddr = ip }))
    network.setoption(handle, "ip-drop-membership")
    network.close(handle)
    udp = nil
    print("networkClosed networkClosed networkClosed networkClosed networkClosed networkClosed networkClosed")

    -- extract target services from answers, resolve hostnames
    local services = {}
    print("****************************data, peeraddr, peerport************************************")		
    print(#answers.srv)
    for k,v in pairs(answers.srv) do
print("****************************************************************")		
print(k,v)
print("****************************************************************")		
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

--return mdns

print("***********************************************************************************************************")
print("mdns.query(false,20) mdns.query(false,20) mdns.query(false,20) mdns.query(false,20) mdns.query(false,20)")
local res = mdns.query(false,20)
print("***********************************************************************************************************")
print(res)

if (res) then
	print("*******************************In IF CONDITION*******************************")
	print(#res)
	for k,v in ipairs(res) do
		-- output key name
		print('************************************Results Found************************************')	
		print(k) 
		for k1,v1 in ipairs(v) do
			-- output service descriptor fields
			print('  '..k1..': '..v1)
		end
	end
else
	print('************************************no result************************************')
end

print("***********************************************************************************************************")
print("***********************************************************************************************************")
print("***********************************************************************************************************")