-- ── nvim-ufo ─────────────────────────────────────────────────────────────────
-- Purpose : Enhanced folding with treesitter/LSP providers and virtual-text
--           summaries showing the number of hidden lines per fold.
-- Trigger : BufRead, BufNewFile
-- Note    : statuscol.nvim renders the fold column (▼ open / ▶ closed).
--           CustomHover in custom_functions.lua calls UFO's peek fold feature.
--           zR/zM keymaps are wired in legendary.lua.
--           UFO is re-enabled on SessionLoadPost via autocmd in legendary.lua.
-- ─────────────────────────────────────────────────────────────────────────────
return {
	"kevinhwang91/nvim-ufo",
	event = { "BufRead", "BufNewFile" },
	opts = {
		-- Use treesitter first; fall back to indent-based folding when no parser is available.
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
		-- Snappier visual feedback when opening a fold (ms the highlight persists).
		open_fold_hl_timeout = 200,
		-- Appends a " 󱞤 N " count badge to the virtual text of each closed fold,
		-- where N is the number of hidden lines. Remaining first-line text is truncated to fit.
		fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = (" 󱞤 %d "):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end,
		preview = {
			win_config = {
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},
	},
	dependencies = {
		{ "kevinhwang91/promise-async", lazy = true },
		{
			"luukvbaal/statuscol.nvim",
			lazy = true,
			opts = {
				relculright = true,
				setopt = true,
			},
			config = function(_, opts)
				require("statuscol").setup(vim.tbl_deep_extend("force", opts, {
					-- Three-column status column: sign → line number → fold indicator.
					segments = {
						{ text = { "%s" }, click = "v:lua.ScSa" }, -- signs (diagnostics, git)
						{ text = { require("statuscol.builtin").lnumfunc, " " }, click = "v:lua.ScLa" }, -- line numbers
						{ text = { require("statuscol.builtin").foldfunc, "  " }, click = "v:lua.ScFa" }, -- fold column (▼/▶)
					},
				}))
			end,
		},
	},
}
