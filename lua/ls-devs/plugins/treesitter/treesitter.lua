return {
	"nvim-treesitter/nvim-treesitter",
	cmd = { "TSUpdate", "TSInstall" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		ensure_installed = {
			"swift",
			"vimdoc",
			"kotlin",
			"lua",
			"markdown",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"prisma",
			"json",
			"svelte",
			"scss",
			"c",
			"python",
			"pug",
			"php",
			"java",
			"astro",
			"vue",
			"dockerfile",
			"graphql",
			"yaml",
			"toml",
			"rust",
			"http",
			"cpp",
			"markdown_inline",
			"regex",
			"bash",
			"cmake",
			"http",
			"gitcommit",
			"gitignore",
			"git_rebase",
			"gitattributes",
			"go",
			"make",
			"gomod",
			"graphql",
			"v",
		},
		sync_install = true,
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		rainbow = {
			enable = true,
			extended_mode = true,
		},
		autotag = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
					["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
					["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
					["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

					["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
					["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
					["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
					["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },

					["aa"] = { query = "@arameter.outer", desc = "Select outer part of a parameter/argument" },
					["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

					["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
					["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

					["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
					["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

					["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
					["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

					["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
					["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

					["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
					["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>na"] = "@parameter.inner",
					["<leader>n:"] = "@property.outer",
					["<leader>nm"] = "@function.outer",
				},
				swap_previous = {
					["<leader>pa"] = "@parameter.inner",
					["<leader>p:"] = "@property.outer",
					["<leader>pm"] = "@function.outer",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = { query = "@call.outer", desc = "Next function call start" },
					["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
					["]c"] = { query = "@class.outer", desc = "Next class start" },
					["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["]l"] = { query = "@loop.outer", desc = "Next loop start" },

					["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
					["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
				},
				goto_next_end = {
					["]F"] = { query = "@call.outer", desc = "Next function call end" },
					["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
					["]C"] = { query = "@class.outer", desc = "Next class end" },
					["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
					["]L"] = { query = "@loop.outer", desc = "Next loop end" },
				},
				goto_previous_start = {
					["[f"] = { query = "@call.outer", desc = "Prev function call start" },
					["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
					["[c"] = { query = "@class.outer", desc = "Prev class start" },
					["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
					["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
				},
				goto_previous_end = {
					["[F"] = { query = "@call.outer", desc = "Prev function call end" },
					["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
					["[C"] = { query = "@class.outer", desc = "Prev class end" },
					["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
					["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
				},
			},
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scrope_incremental = false,
				node_decremental = "<bs>",
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
	keys = {
		{
			";",
			mode = { "n", "x", "o" },
			function()
				require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move()
			end,
			desc = "TS Repeat Last Move",
		},
		{
			",",
			mode = { "n", "x", "o" },
			function()
				require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_opposite()
			end,
			desc = "TS Repeat Last Move Backward",
		},
	},
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
		{
			"chrisgrieser/nvim-various-textobjs",
			lazy = true,
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
					function()
						require("various-textobjs").greedyOuterIndentation("inner")
					end,
				},
				{
					"ig",
					mode = { "o", "x" },
					function()
						require("various-textobjs").greedyOuterIndentation("outer")
					end,
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
							local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
							local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
							local urls = {}
							for url in bufText:gmatch(urlPattern) do
								table.insert(urls, url)
							end
							if #urls == 0 then
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
					"gX",
					mode = { "o", "x" },
					function()
						require("various-textobjs").restOfWindow()
					end,
				},
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
					"ic",
					mode = { "o", "x" },
					function()
						require("various-textobjs").cssSelector("inner")
					end,
					buffer = true,
				},
				{
					"ac",
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
	build = ":TSUpdate",
}
