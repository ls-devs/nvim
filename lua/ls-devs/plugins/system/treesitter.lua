-- ── nvim-treesitter ───────────────────────────────────────────────────────
-- Purpose : Syntax parsing, highlighting, and text objects
-- Note    : Uses the main branch (full rewrite for Neovim 0.12+).
--           The master branch is archived and incompatible with Neovim 0.12.
--           wildfire.nvim owns <C-Space> incremental selection.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "TSInstall", "TSInstallFromGrammar", "TSUpdate" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			config = function()
				require("nvim-treesitter-textobjects").setup({
					select = { lookahead = true },
					move = { set_jumps = true },
				})
			end,
			-- All keymaps live here so lazy.nvim registers stubs immediately,
			-- making every binding visible in which-key before the plugin loads.
			keys = {
				-- ── Select (operator-pending / visual) ───────────────────────────
				{
					"a=",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@assignment.outer",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select outer assignment",
				},
				{
					"i=",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@assignment.inner",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select inner assignment",
				},
				{
					"l=",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@assignment.lhs",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select assignment LHS",
				},
				{
					"r=",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@assignment.rhs",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select assignment RHS",
				},
				{
					"aa",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@parameter.outer",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select outer parameter",
				},
				{
					"ia",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@parameter.inner",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select inner parameter",
				},
				{
					"ac",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@conditional.outer",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select outer conditional",
				},
				{
					"ic",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@conditional.inner",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select inner conditional",
				},
				{
					"al",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects")
					end,
					mode = { "o", "x" },
					desc = "Select outer loop",
				},
				{
					"il",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects")
					end,
					mode = { "o", "x" },
					desc = "Select inner loop",
				},
				{
					"af",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")
					end,
					mode = { "o", "x" },
					desc = "Select outer function call",
				},
				{
					"if",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects")
					end,
					mode = { "o", "x" },
					desc = "Select inner function call",
				},
				{
					"am",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@function.outer",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select outer method/function",
				},
				{
					"im",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@function.inner",
							"textobjects"
						)
					end,
					mode = { "o", "x" },
					desc = "Select inner method/function",
				},
				{
					"at",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
					end,
					mode = { "o", "x" },
					desc = "Select outer class",
				},
				{
					"it",
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
					end,
					mode = { "o", "x" },
					desc = "Select inner class",
				},
				-- ── Swap ─────────────────────────────────────────────────────────
				{
					"<leader>na",
					function()
						require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
					end,
					desc = "Swap next parameter",
				},
				{
					"<leader>n:",
					function()
						require("nvim-treesitter-textobjects.swap").swap_next("@property.outer")
					end,
					desc = "Swap next property",
				},
				{
					"<leader>nm",
					function()
						require("nvim-treesitter-textobjects.swap").swap_next("@function.outer")
					end,
					desc = "Swap next function",
				},
				{
					"<leader>pa",
					function()
						require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
					end,
					desc = "Swap previous parameter",
				},
				{
					"<leader>p:",
					function()
						require("nvim-treesitter-textobjects.swap").swap_previous("@property.outer")
					end,
					desc = "Swap previous property",
				},
				{
					"<leader>pm",
					function()
						require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer")
					end,
					desc = "Swap previous function",
				},
				-- ── Move next (repeatable via ; and ,) ───────────────────────────
				{
					"]f",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next function call start",
				},
				{
					"]m",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next method/function def start",
				},
				{
					"]i",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next conditional start",
				},
				{
					"]l",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next loop start",
				},
				{
					"]s",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@scope", "locals")
					end,
					mode = { "n", "x", "o" },
					desc = "Next scope start",
				},
				{
					"]z",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
					end,
					mode = { "n", "x", "o" },
					desc = "Next fold start",
				},
				{
					"]F",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@call.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next function call end",
				},
				{
					"]M",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next method/function def end",
				},
				{
					"]I",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@conditional.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next conditional end",
				},
				{
					"]L",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@loop.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Next loop end",
				},
				{
					"]S",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@scope", "locals")
					end,
					mode = { "n", "x", "o" },
					desc = "Next scope end",
				},
				{
					"]Z",
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@fold", "folds")
					end,
					mode = { "n", "x", "o" },
					desc = "Next fold end",
				},
				-- ── Move prev (repeatable via ; and ,) ───────────────────────────
				{
					"[f",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev function call start",
				},
				{
					"[m",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start(
							"@function.outer",
							"textobjects"
						)
					end,
					mode = { "n", "x", "o" },
					desc = "Prev method/function def start",
				},
				{
					"[c",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev class start",
				},
				{
					"[i",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start(
							"@conditional.outer",
							"textobjects"
						)
					end,
					mode = { "n", "x", "o" },
					desc = "Prev conditional start",
				},
				{
					"[l",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev loop start",
				},
				{
					"[s",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start("@scope", "locals")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev scope start",
				},
				{
					"[z",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev fold start",
				},
				{
					"[F",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@call.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev function call end",
				},
				{
					"[M",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev method/function def end",
				},
				{
					"[C",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev class end",
				},
				{
					"[I",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end(
							"@conditional.outer",
							"textobjects"
						)
					end,
					mode = { "n", "x", "o" },
					desc = "Prev conditional end",
				},
				{
					"[L",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@loop.outer", "textobjects")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev loop end",
				},
				{
					"[S",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@scope", "locals")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev scope end",
				},
				{
					"[Z",
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@fold", "folds")
					end,
					mode = { "n", "x", "o" },
					desc = "Prev fold end",
				},
				-- ── Repeatable ; and , ───────────────────────────────────────────
				{
					";",
					function()
						require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move()
					end,
					mode = { "n", "x", "o" },
					desc = "TS Repeat Last Move",
				},
				{
					",",
					function()
						require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_opposite()
					end,
					mode = { "n", "x", "o" },
					desc = "TS Repeat Last Move Backward",
				},
			},
		},
		-- Provides an extensive set of extra text objects: indentation (ii/ai),
		-- subword (iS/aS), quotes (iq/aq), brackets (io/ao), key/value (ik/ak),
		-- URL (gx), fold (iz/az), chain member (im/am), and many language-specific
		-- objects (markdown, Python, CSS, HTML, shell pipe, wikilinks).
		{
			"chrisgrieser/nvim-various-textobjs",
			lazy = true,
			config = function()
				---@diagnostic disable-next-line: duplicate-set-field
				require("various-textobjs").setup({ notify = { whenObjectNotFound = false } })
			end,
			keys = {
				{
					"ii",
					mode = { "o", "x" },
					function()
						if vim.fn.indent(".") == 0 then
							require("various-textobjs").entireBuffer()
						else
							require("various-textobjs").indentation("inner", "inner")
						end
					end,
				},
				{
					"ai",
					mode = { "o", "x" },
					function()
						require("various-textobjs").indentation("outer", "inner")
					end,
				},
				{
					"iI",
					mode = { "o", "x" },
					function()
						require("various-textobjs").indentation("inner", "inner")
					end,
				},
				{
					"aI",
					mode = { "o", "x" },
					function()
						require("various-textobjs").indentation("outer", "outer")
					end,
				},
				{
					"R",
					mode = { "o", "x" },
					function()
						require("various-textobjs").restOfIndentation()
					end,
				},
				{
					"ag",
					mode = { "o", "x" },
					"<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>",
				},
				{
					"ig",
					mode = { "o", "x" },
					"<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>",
				},
				{
					"iS",
					mode = { "o", "x" },
					function()
						require("various-textobjs").subword("inner")
					end,
				},
				{
					"aS",
					mode = { "o", "x" },
					function()
						require("various-textobjs").subword("outer")
					end,
				},
				{
					"C",
					mode = { "o", "x" },
					function()
						require("various-textobjs").toNextClosingBracket()
					end,
				},
				{
					"Q",
					mode = { "o", "x" },
					function()
						require("various-textobjs").toNextQuotationMark()
					end,
				},
				{
					"iq",
					mode = { "o", "x" },
					function()
						require("various-textobjs").anyQuote("inner")
					end,
				},
				{
					"aq",
					mode = { "o", "x" },
					function()
						require("various-textobjs").anyQuote("outer")
					end,
				},
				{
					"io",
					mode = { "o", "x" },
					function()
						require("various-textobjs").anyBracket("inner")
					end,
				},
				{
					"ao",
					mode = { "o", "x" },
					function()
						require("various-textobjs").anyBracket("outer")
					end,
				},
				{
					"r",
					mode = { "o", "x" },
					function()
						require("various-textobjs").restOfParagraph()
					end,
				},
				{
					"gG",
					mode = { "o", "x" },
					function()
						require("various-textobjs").entireBuffer()
					end,
				},
				{
					"n",
					mode = { "o", "x" },
					function()
						require("various-textobjs").nearEoL()
					end,
				},
				{
					"g;",
					mode = { "o", "x" },
					function()
						require("various-textobjs").lastChange()
					end,
				},
				{
					"i_",
					mode = { "o", "x" },
					function()
						require("various-textobjs").lineCharacterwise("inner")
					end,
				},
				{
					"a_",
					mode = { "o", "x" },
					function()
						require("various-textobjs").lineCharacterwise("outer")
					end,
				},
				{
					"|",
					mode = { "o", "x" },
					function()
						require("various-textobjs").column()
					end,
				},
				{
					"qc",
					mode = { "o", "x" },
					function()
						require("various-textobjs").multiCommentedLines()
					end,
				},
				{
					"iN",
					mode = { "o", "x" },
					function()
						require("various-textobjs").notebookCell("inner")
					end,
				},
				{
					"aN",
					mode = { "o", "x" },
					function()
						require("various-textobjs").notebookCell("outer")
					end,
				},
				{
					"iv",
					mode = { "o", "x" },
					function()
						require("various-textobjs").value("inner")
					end,
				},
				{
					"av",
					mode = { "o", "x" },
					function()
						require("various-textobjs").value("outer")
					end,
				},
				{
					"ik",
					mode = { "o", "x" },
					function()
						require("various-textobjs").key("inner")
					end,
				},
				{
					"ak",
					mode = { "o", "x" },
					function()
						require("various-textobjs").key("outer")
					end,
				},
				{
					"in",
					mode = { "o", "x" },
					function()
						require("various-textobjs").number("inner")
					end,
				},
				{
					"an",
					mode = { "o", "x" },
					function()
						require("various-textobjs").number("outer")
					end,
				},
				{
					"!",
					mode = { "o", "x" },
					function()
						require("various-textobjs").diagnostic()
					end,
				},
				{
					"iz",
					mode = { "o", "x" },
					function()
						require("various-textobjs").closedFold("inner")
					end,
				},
				{
					"az",
					mode = { "o", "x" },
					function()
						require("various-textobjs").closedFold("outer")
					end,
				},
				{
					"im",
					mode = { "o", "x" },
					function()
						require("various-textobjs").chainMember("inner")
					end,
				},
				{
					"am",
					mode = { "o", "x" },
					function()
						require("various-textobjs").chainMember("outer")
					end,
				},
				{
					"gw",
					mode = { "o", "x" },
					function()
						require("various-textobjs").visibleInWindow()
					end,
				},
				{
					"gW",
					mode = { "o", "x" },
					function()
						require("various-textobjs").restOfWindow()
					end,
				},
				-- Smart URL handler
				{
					"gx",
					mode = { "o", "x", "n" },
					function()
						require("various-textobjs").url()
						local foundURL = vim.fn.mode():find("v")
						if foundURL then
							vim.cmd.normal('"zy')
							local url = vim.fn.getreg("z")
							require("ls-devs.utils.custom_functions").OpenURLs(url)
						else
							local urlPattern = "%l%l%l-://[^%s)]+"
							local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
							local urls = {}
							for url in bufText:gmatch(urlPattern) do
								table.insert(urls, url)
							end
							if #urls == 0 then
								if vim.fn.exists(":Browse") ~= 0 then
									vim.cmd("Browse")
								end
								return
							end
							vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
								if choice then
									require("ls-devs.utils.custom_functions").OpenURLs(choice)
								end
							end)
						end
					end,
				},
				-- Language-specific (buffer-local)
				-- mdlink/mdEmphasis/mdFencedCodeBlock deprecated (2025-11-30): removed to avoid runtime warnings
				{
					"iy",
					mode = { "o", "x" },
					function()
						require("various-textobjs").pyTripleQuotes("inner")
					end,
					buffer = true,
				},
				{
					"ay",
					mode = { "o", "x" },
					function()
						require("various-textobjs").pyTripleQuotes("outer")
					end,
					buffer = true,
				},
				{
					"is",
					mode = { "o", "x" },
					function()
						require("various-textobjs").cssSelector("inner")
					end,
					buffer = true,
				},
				{
					"as",
					mode = { "o", "x" },
					function()
						require("various-textobjs").cssSelector("outer")
					end,
					buffer = true,
				},
				{
					"ix",
					mode = { "o", "x" },
					function()
						require("various-textobjs").htmlAttribute("inner")
					end,
					buffer = true,
				},
				{
					"ax",
					mode = { "o", "x" },
					function()
						require("various-textobjs").htmlAttribute("outer")
					end,
					buffer = true,
				},
				{
					"iD",
					mode = { "o", "x" },
					function()
						require("various-textobjs").doubleSquareBrackets("inner")
					end,
					buffer = true,
				},
				{
					"aD",
					mode = { "o", "x" },
					function()
						require("various-textobjs").doubleSquareBrackets("outer")
					end,
					buffer = true,
				},
				{
					"iP",
					mode = { "o", "x" },
					function()
						require("various-textobjs").shellPipe("inner")
					end,
					buffer = true,
				},
				{
					"aP",
					mode = { "o", "x" },
					function()
						require("various-textobjs").shellPipe("outer")
					end,
					buffer = true,
				},
			},
		},
		{
			"HiPhish/rainbow-delimiters.nvim",
			lazy = true,
			config = function()
				local rainbow_delimiters = require("rainbow-delimiters")
				vim.g.rainbow_delimiters = {
					strategy = {
						[""] = rainbow_delimiters.strategy["global"],
						vim = rainbow_delimiters.strategy["local"],
					},
					query = {
						[""] = "rainbow-delimiters",
						lua = "rainbow-blocks",
					},
					highlight = {
						"RainbowDelimiterRed",
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
					},
				}
			end,
		},
	},
}
