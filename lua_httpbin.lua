http = require("socket.http")
ltn12 = require("ltn12")


--Helper for priniting nested table
function deep_print(tbl)
    for i, v in pairs(tbl) do
        if type(v) == "table" then 
            deep_print(v)
        else 
            print(i, v) 
        end
    end
end

function http_request( args )
--http.request(url [, body])
  http.request{
    url = "https://webhook.site/06eac22e-c8cd-48fb-80b0-a8ad2f6a5fcf",
    sink = ltn12.sink.table(body),
    method = "POST"
--  [headers = header-table,]
--  [source = LTN12 source],
--  [step = LTN12 pump step,]
--  [proxy = string,]
--  [redirect = boolean,]
--  [create = function]
  }
--
--
    local resp, r = {}, {}
    if args.endpoint then
        local params = ""
        if args.method == nil or args.method == "GET" then
            -- prepare query parameters like http://xyz.com?q=23&a=2
            if args.params then
                for i, v in pairs(args.params) do
                    params = params .. i .. "=" .. v .. "&"
                end
            end
        end
        params = string.sub(params, 1, -2)
        local url = "https://webhook.site/06eac22e-c8cd-48fb-80b0-a8ad2f6a5fcf"

        client, code, headers, status = http.request{url=url, sink=ltn12.sink.table(resp),
                                                method=args.method or "GET", headers=args.headers, source=args.source,
                                                step=args.step,     proxy=args.proxy, redirect=args.redirect, create=args.create }
        r['code'], r['headers'], r['status'], r['response'] = code, headers, status, resp
    else
        error("endpoint is missing")
    end
    return r
end



function main()
    local endpoint = "/ip"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/user-agent"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/get"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint, params={age=23, name="kracekumar"}})
    endpoint = "/"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/post"
    print(endpoint)
    local req_body = "a=2"
    deep_print(http_request{endpoint=endpoint, method="POST", source=ltn12.source.string(req_body)})
    endpoint = "/patch"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint, method="PATCH"})
    endpoint = "/put"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint, method="PUT", source=ltn12.source.string("a=23")})
    endpoint = "/delete"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint, method="DELETE", source=ltn12.source.string("a=23")})
    endpoint = "/gzip"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint, method="GET", source=ltn12.source.string("a=23&b=12")})
    endpoint = "/status/205"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/response-headers?key=val"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/redirect/3"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/redirect/5"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint, redirect=5})
    endpoint = "/cookies"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/cookies/set?name=kracekumar&age=23"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint, source=ltn12.source.string("name=kracekumar&age=23")})
    endpoint = "/basic-auth/kracekumar/kracekumar"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/stream/23"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/delay/12"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/robots.txt"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/deny"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})
    endpoint = "/cache"
    print(endpoint)
    deep_print(http_request{endpoint=endpoint})

end

main()
