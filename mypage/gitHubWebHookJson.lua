local json  = require("json") 
local http  = require("socket.http")
local ltn12 = require("ltn12")

local payload = {}
table.insert(payload, 
  {   
      labels = { 
          alertname = "luaTest", 
          job = "test",
          cmd = "foo",
          args = "-t test -all -db localhost"
      },  
      annotations = { 
          summary = "cmd exec failed", 
          description = "cmd exec failed, exit code: 2"
      }   
  })  
local request_body = json.encode(payload)
local response_body = {}

local url = "http://webhook.site/9bdc1d9d-adfc-4404-b95d-5a631d14fbbf"

local res, code, response_headers = http.request{
    url = url,
    method = "POST",
    headers =
      {   
          --[[ ["Authorization"] = auth; ]]
          ["Content-Type"] = "application/json";
          ["Content-Length"] = #request_body;
      },  
      source = ltn12.source.string(request_body),
      sink = ltn12.sink.table(response_body),
}

print(res)
print(code)

if type(response_headers) == "table" then
  for k, v in pairs(response_headers) do
    print(k, v)
  end 
end

print("Response body:")
if type(response_body) == "table" then
  print(table.concat(response_body))
else
  print("Not a table:", type(response_body))
end