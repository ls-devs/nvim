---@diagnostic disable: undefined-global
-- Native blink.cmp source for .env* files in the current workspace.
-- Reads all .env* files from cwd, parses KEY=VALUE pairs, and returns
-- them as completions with the value shown as documentation.
local source = {}

function source.new()
	return setmetatable({}, { __index = source })
end

function source:get_completions(_, callback)
	local items = {}
	local seen = {}
	local files = vim.fn.glob(vim.fn.getcwd() .. "/.env*", false, true)

	for _, file in ipairs(files) do
		local f = io.open(file, "r")
		if f then
			for line in f:lines() do
				-- support: KEY=val, export KEY=val, KEY="val", KEY='val'
				local key, value = line:match("^%s*export%s+([%w_]+)%s*=%s*(.-)%s*$")
				if not key then
					key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
				end
				if key and not seen[key] then
					seen[key] = true
					value = (value or ""):gsub("^[\"'](.-)[\"'%s]*$", "%1")
					table.insert(items, {
						label = key,
						kind = vim.lsp.protocol.CompletionItemKind.Variable,
						detail = value ~= "" and value or nil,
						documentation = value ~= "" and { kind = "plaintext", value = value } or nil,
					})
				end
			end
			f:close()
		end
	end

	callback({
		is_incomplete_forward = false,
		is_incomplete_backward = false,
		items = items,
	})
end

return source
