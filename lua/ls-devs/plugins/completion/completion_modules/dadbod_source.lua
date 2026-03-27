---@diagnostic disable: undefined-global
-- ── dadbod_source ────────────────────────────────────────────────────────
-- Purpose : Native blink.cmp source for vim-dadbod-completion.
--           Replaces the blink.compat wrapper to fix a systematic offset bug:
--           blink.compat sets offset=cursor.col when the cmp source has no
--           get_keyword_pattern, so on every re-request (isIncomplete=true)
--           the input becomes "" and dadbod returns nothing → list vanishes.
-- Fix     : Extract the full table.column input ourselves, return results
--           with is_incomplete_forward=false so blink.cmp owns fuzzy-matching
--           instead of re-requesting on each keystroke.
-- Provides: Table names, column names, schema names from the active DB conn.
-- ─────────────────────────────────────────────────────────────────────────

---@class DadbodSource
local source = {}

---@return DadbodSource
function source.new()
	return setmetatable({}, { __index = source })
end

---@return string[]
function source:get_trigger_characters()
	return { '"', "`", "[", "]", "." }
end

local kind_map = {
	F = vim.lsp.protocol.CompletionItemKind.Function,  -- Function
	C = vim.lsp.protocol.CompletionItemKind.Field,     -- Column
	A = vim.lsp.protocol.CompletionItemKind.Variable,  -- Alias
	T = vim.lsp.protocol.CompletionItemKind.Class,     -- Table
	R = vim.lsp.protocol.CompletionItemKind.Keyword,   -- Reserved word
	S = vim.lsp.protocol.CompletionItemKind.Module,    -- Schema
}

---@param ctx table  blink.cmp context (cursor, line, bufnr, trigger, …)
---@param callback function
function source:get_completions(ctx, callback)
	-- ctx.cursor is {row, col} with col 0-indexed (nvim convention)
	-- sub(1, col) gives text strictly before the cursor
	local before_cursor = ctx.line:sub(1, ctx.cursor[2])

	-- Capture the full schema.table.column prefix, e.g. "public.users."
	-- or just a partial word so dadbod can match keywords / table names.
	local input = before_cursor:match("[%w_%.]+$") or ""

	local ok, results = pcall(vim.fn["vim_dadbod_completion#omni"], 0, input)
	if not ok or type(results) ~= "table" then
		callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
		return
	end

	local items = {}
	for _, item in ipairs(results) do
		local doc = (item.info and item.info ~= "") and { kind = "plaintext", value = item.info } or nil
		table.insert(items, {
			label = item.abbr or item.word,
			insertText = item.word,
			labelDetails = item.menu ~= "" and { description = item.menu } or nil,
			documentation = doc,
			kind = kind_map[item.kind],
		})
	end

	-- is_incomplete_forward = true → blink.cmp re-calls this source on every
	-- keystroke instead of caching. The VimScript omni reads live Vim state
	-- (getline('.'), col('.')) to detect SQL context (after FROM/JOIN = tables,
	-- after table. = columns). Re-requesting ensures context is always fresh.
	-- The VimScript function has its own schema cache so re-calling is cheap.
	callback({
		is_incomplete_forward = true,
		is_incomplete_backward = false,
		items = items,
	})
end

return source
