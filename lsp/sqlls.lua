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
				if lines[#lines] == "" then table.remove(lines) end
				vim.lsp.util.open_floating_preview(lines, "plaintext", {
					border = "rounded",
					max_width = 80,
				})
				return
			end
			-- fallback: let the LSP try (will usually return nothing for sqlls)
			vim.lsp.buf.hover()
		end, { buffer = bufnr, desc = "SQL schema hover (dadbod)" })
	end,
}
