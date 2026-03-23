---@diagnostic disable: undefined-global
-- ── dotenv_source ────────────────────────────────────────────────────────
-- Purpose : Custom blink.cmp source that reads .env* files from the project root
-- Provides: KEY=VALUE pairs as completion items; values shown as documentation
-- Note    : NOT a lazy.nvim spec — loaded by blink_cmp.lua via
--             `module = "ls-devs.plugins.completion.completion_modules.dotenv_source"`
-- ─────────────────────────────────────────────────────────────────────────
---@class DotenvSource
local source = {}

---@return DotenvSource
function source.new()
	return setmetatable({}, { __index = source })
end

---@param self DotenvSource
---@param _ table
---@param callback function
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
