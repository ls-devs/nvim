local http_request = require("http.request")
local cjson = require("cjson")
local headers, stream = assert(http_request.new_from_uri("https://api.quotable.io/random"):go())
local body = assert(stream:get_body_as_string())
if headers:get(":status") ~= "200" then
	error(body)
end
local body_json = cjson.decode(body)

local opts = {
	content = body_json["content"],
	author = body_json["author"],
}

return opts
