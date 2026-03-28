-- ── lsp/sqlls ─────────────────────────────────────────────────────────────
-- Server  : sql-language-server (sqlls)
-- Language: SQL
-- Config  : Formatting + diagnostics disabled; custom K hover via dadbod
-- Note    : sqlls bundles sqlint which emits style diagnostics (uppercase
--           keywords, required linebreaks). These are redundant since
--           sql-formatter (conform) reformats on save. Suppress the whole
--           publishDiagnostics handler to keep the buffer noise-free.
--           sqlls advertises no hoverProvider, so K is overridden per-buffer
--           to query vim-dadbod-completion for live schema information.
-- ──────────────────────────────────────────────────────────────────────────
return {
	handlers = {
		-- Swallow sqlint style diagnostics entirely — sql-formatter handles style
		["textDocument/publishDiagnostics"] = function() end,
	},
	on_attach = function(client, bufnr)
		-- sql-formatter via conform owns SQL formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		-- sqlls has no hoverProvider. Override K to show schema info from
		-- vim-dadbod-completion (works when an active DB connection exists).
		vim.keymap.set("n", "K", function()
			local word = vim.fn.expand("<cword>")
			local ok, items = pcall(vim.fn["vim_dadbod_completion#omni"], 0, word)
			if ok and type(items) == "table" and #items > 0 then
				local lines = {}
				for _, item in ipairs(items) do
					local header = (item.menu ~= "" and (item.menu .. "  ") or "") .. (item.abbr or item.word)
					table.insert(lines, header)
					if item.info and item.info ~= "" then
						table.insert(lines, item.info)
					end
					table.insert(lines, "")
				end
				-- pop trailing blank line
				if lines[#lines] == "" then
					table.remove(lines)
				end
				local buf = vim.api.nvim_create_buf(false, true)
				vim.bo[buf].bufhidden = "wipe"
				vim.bo[buf].filetype = "plaintext"
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				local width = math.min(80, vim.o.columns - 4)
				local height = math.min(#lines, 15)
				vim.api.nvim_open_win(buf, false, {
					relative = "cursor",
					row = 1,
					col = 0,
					width = width,
					height = height,
					style = "minimal",
					border = "rounded",
				})
				return
			end
			-- fallback: let the LSP try (will usually return nothing for sqlls)
			vim.lsp.buf.hover()
		end, { buffer = bufnr, desc = "SQL schema hover (dadbod)" })
	end,
}
