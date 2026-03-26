-- ── nvim-treesitter ───────────────────────────────────────────────────────
-- Purpose : Syntax parsing, highlighting, indentation, and text objects
-- Note    : Uses the main branch (full rewrite for Neovim 0.12+).
--           The master branch is archived and incompatible with Neovim 0.12.
--           Loaded on BufReadPre/BufNewFile (fires before FileType — safe).
--           Highlighting is native Neovim (queries on rtp via install_dir).
--           Indentation uses nvim-treesitter's indentexpr per FileType.
--           wildfire.nvim owns <C-Space> incremental selection.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		require("nvim-treesitter").install({
			"swift",
			"vimdoc",
			"lua",
			"markdown",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"json",
			"scss",
			"python",
			"requirements",
			"ini",
			"dockerfile",
			"yaml",
			"toml",
			"http",
			"markdown_inline",
			"regex",
			"bash",
			"gitcommit",
			"gitignore",
			"git_rebase",
			"gitattributes",
			"sql",
			"graphql",
			"c_sharp",
			"comment",
			"jsdoc",
		})

		-- Enable nvim-treesitter indentexpr for supported filetypes.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"html",
				"css",
				"scss",
				"json",
				"yaml",
				"toml",
				"lua",
				"python",
				"bash",
				"dockerfile",
				"graphql",
				"sql",
			},
			group = vim.api.nvim_create_augroup("treesitter_indent", { clear = true }),
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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

				local sel = require("nvim-treesitter-textobjects.select")
				local swap = require("nvim-treesitter-textobjects.swap")
				local move = require("nvim-treesitter-textobjects.move")
				local rep = require("nvim-treesitter-textobjects.repeatable_move")

				-- ── Select ───────────────────────────────────────────────────────────
				local select_maps = {
					{ "a=", "@assignment.outer", "Select outer part of an assignment" },
					{ "i=", "@assignment.inner", "Select inner part of an assignment" },
					{ "l=", "@assignment.lhs", "Select left hand side of an assignment" },
					{ "r=", "@assignment.rhs", "Select right hand side of an assignment" },
					{ "aa", "@parameter.outer", "Select outer part of a parameter/argument" },
					{ "ia", "@parameter.inner", "Select inner part of a parameter/argument" },
					{ "ac", "@conditional.outer", "Select outer part of a conditional" },
					{ "ic", "@conditional.inner", "Select inner part of a conditional" },
					{ "al", "@loop.outer", "Select outer part of a loop" },
					{ "il", "@loop.inner", "Select inner part of a loop" },
					{ "af", "@call.outer", "Select outer part of a function call" },
					{ "if", "@call.inner", "Select inner part of a function call" },
					{ "am", "@function.outer", "Select outer part of a method/function def" },
					{ "im", "@function.inner", "Select inner part of a method/function def" },
					{ "at", "@class.outer", "Select outer part of a class" },
					{ "it", "@class.inner", "Select inner part of a class" },
				}
				for _, m in ipairs(select_maps) do
					vim.keymap.set({ "o", "x" }, m[1], function()
						sel.select_textobject(m[2], "textobjects")
					end, { desc = m[3] })
				end

				-- ── Swap ─────────────────────────────────────────────────────────────
				vim.keymap.set("n", "<leader>na", function()
					swap.swap_next("@parameter.inner")
				end, { desc = "Swap next parameter" })
				vim.keymap.set("n", "<leader>n:", function()
					swap.swap_next("@property.outer")
				end, { desc = "Swap next property" })
				vim.keymap.set("n", "<leader>nm", function()
					swap.swap_next("@function.outer")
				end, { desc = "Swap next function" })
				vim.keymap.set("n", "<leader>pa", function()
					swap.swap_previous("@parameter.inner")
				end, { desc = "Swap previous parameter" })
				vim.keymap.set("n", "<leader>p:", function()
					swap.swap_previous("@property.outer")
				end, { desc = "Swap previous property" })
				vim.keymap.set("n", "<leader>pm", function()
					swap.swap_previous("@function.outer")
				end, { desc = "Swap previous function" })

				-- ── Move (all repeatable via ; and ,) ────────────────────────────────
				local move_maps = {
					{ "]f", "next_start", "@call.outer", "textobjects", "Next function call start" },
					{ "]m", "next_start", "@function.outer", "textobjects", "Next method/function def start" },
					{ "]i", "next_start", "@conditional.outer", "textobjects", "Next conditional start" },
					{ "]l", "next_start", "@loop.outer", "textobjects", "Next loop start" },
					{ "]s", "next_start", "@scope", "locals", "Next scope start" },
					{ "]z", "next_start", "@fold", "folds", "Next fold start" },
					{ "]F", "next_end", "@call.outer", "textobjects", "Next function call end" },
					{ "]M", "next_end", "@function.outer", "textobjects", "Next method/function def end" },
					{ "]I", "next_end", "@conditional.outer", "textobjects", "Next conditional end" },
					{ "]L", "next_end", "@loop.outer", "textobjects", "Next loop end" },
					{ "]S", "next_end", "@scope", "locals", "Next scope end" },
					{ "]Z", "next_end", "@fold", "folds", "Next fold end" },
					{ "[f", "previous_start", "@call.outer", "textobjects", "Prev function call start" },
					{ "[m", "previous_start", "@function.outer", "textobjects", "Prev method/function def start" },
					{ "[c", "previous_start", "@class.outer", "textobjects", "Prev class start" },
					{ "[i", "previous_start", "@conditional.outer", "textobjects", "Prev conditional start" },
					{ "[l", "previous_start", "@loop.outer", "textobjects", "Prev loop start" },
					{ "[s", "previous_start", "@scope", "locals", "Prev scope start" },
					{ "[z", "previous_start", "@fold", "folds", "Prev fold start" },
					{ "[F", "previous_end", "@call.outer", "textobjects", "Prev function call end" },
					{ "[M", "previous_end", "@function.outer", "textobjects", "Prev method/function def end" },
					{ "[C", "previous_end", "@class.outer", "textobjects", "Prev class end" },
					{ "[I", "previous_end", "@conditional.outer", "textobjects", "Prev conditional end" },
					{ "[L", "previous_end", "@loop.outer", "textobjects", "Prev loop end" },
					{ "[S", "previous_end", "@scope", "locals", "Prev scope end" },
					{ "[Z", "previous_end", "@fold", "folds", "Prev fold end" },
				}
				local move_fns = {
					next_start = move.goto_next_start,
					next_end = move.goto_next_end,
					previous_start = move.goto_previous_start,
					previous_end = move.goto_previous_end,
				}
				for _, m in ipairs(move_maps) do
					local fn = move_fns[m[2]]
					vim.keymap.set({ "n", "x", "o" }, m[1], function()
						fn(m[3], m[4])
					end, { desc = m[5] })
				end

				-- ── Repeatable ; and , ───────────────────────────────────────────────
				vim.keymap.set({ "n", "x", "o" }, ";", rep.repeat_last_move, { desc = "TS Repeat Last Move" })
				vim.keymap.set(
					{ "n", "x", "o" },
					",",
					rep.repeat_last_move_opposite,
					{ desc = "TS Repeat Last Move Backward" }
				)
			end,
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
				require("various-textobjs.utils").notFoundMsg = function() end
			end,
			keys = {
				{
					"ii",
					mode = { "o", "x" },
					function()
						if vim.fn.indent(".") == 0 then
							require("various-textobjs").entirebuffer()
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
								if vim.fn.exists("Browse") then
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
				{
					"il",
					mode = { "o", "x" },
					function()
						require("various-textobjs").mdlink("inner")
					end,
					buffer = true,
				},
				{
					"al",
					mode = { "o", "x" },
					function()
						require("various-textobjs").mdlink("outer")
					end,
					buffer = true,
				},
				{
					"ie",
					mode = { "o", "x" },
					function()
						require("various-textobjs").mdEmphasis("inner")
					end,
					buffer = true,
				},
				{
					"ae",
					mode = { "o", "x" },
					function()
						require("various-textobjs").mdEmphasis("outer")
					end,
					buffer = true,
				},
				{
					"iC",
					mode = { "o", "x" },
					function()
						require("various-textobjs").mdFencedCodeBlock("inner")
					end,
					buffer = true,
				},
				{
					"aC",
					mode = { "o", "x" },
					function()
						require("various-textobjs").mdFencedCodeBlock("outer")
					end,
					buffer = true,
				},
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
