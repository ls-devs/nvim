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
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
	end,
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
		{
			"chrisgrieser/nvim-various-textobjs",
			lazy = true,
			init = function()
				local keymap = vim.keymap.set

				keymap({ "o", "x" }, "ii", function()
					if vim.fn.indent(".") == 0 then
						require("various-textobjs").entireBuffer()
					else
						require("various-textobjs").indentation("inner", "inner")
					end
				end)

				keymap({ "o", "x" }, "ai", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>")
				keymap({ "o", "x" }, "iI", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>")
				keymap({ "o", "x" }, "aI", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>")

				keymap({ "o", "x" }, "R", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>")

				keymap({ "o", "x" }, "ag", "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>")
				keymap({ "o", "x" }, "ig", "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>")

				keymap({ "o", "x" }, "iS", "<cmd>lua require('various-textobjs').subword('inner')<CR>")
				keymap({ "o", "x" }, "aS", "<cmd>lua require('various-textobjs').subword('outer')<CR>")

				keymap({ "o", "x" }, "C", "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>")

				keymap({ "o", "x" }, "Q", "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>")

				keymap({ "o", "x" }, "iq", "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>")
				keymap({ "o", "x" }, "aq", "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>")

				keymap({ "o", "x" }, "io", "<cmd>lua require('various-textobjs').anyBracket('inner')<CR>")
				keymap({ "o", "x" }, "ao", "<cmd>lua require('various-textobjs').anyBracket('outer')<CR>")

				keymap({ "o", "x" }, "r", "<cmd>lua require('various-textobjs').restOfParagraph()<CR>")

				keymap({ "o", "x" }, "gG", "<cmd>lua require('various-textobjs').entireBuffer()<CR>")

				keymap({ "o", "x" }, "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>")

				keymap({ "o", "x" }, "g;", "<cmd>lua require('various-textobjs').lastChange()<CR>")

				keymap({ "o", "x" }, "i_", "<cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>")
				keymap({ "o", "x" }, "a_", "<cmd>lua require('various-textobjs').lineCharacterwise('outer')<CR>")

				keymap({ "o", "x" }, "|", "<cmd>lua require('various-textobjs').column()<CR>")

				keymap({ "o", "x" }, "qc", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>")

				keymap({ "o", "x" }, "iN", "<cmd>lua require('various-textobjs').notebookCell('inner')<CR>")
				keymap({ "o", "x" }, "aN", "<cmd>lua require('various-textobjs').notebookCell('outer')<CR>")

				keymap({ "o", "x" }, "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>")
				keymap({ "o", "x" }, "av", "<cmd>lua require('various-textobjs').value('outer')<CR>")

				keymap({ "o", "x" }, "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>")
				keymap({ "o", "x" }, "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>")

				keymap({ "o", "x", "n" }, "gx", function()
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
				end)

				keymap({ "o", "x" }, "in", "<cmd>lua require('various-textobjs').number('inner')<CR>")
				keymap({ "o", "x" }, "an", "<cmd>lua require('various-textobjs').number('outer')<CR>")

				keymap({ "o", "x" }, "!", "<cmd>lua require('various-textobjs').diagnostic()<CR>")

				keymap({ "o", "x" }, "iz", "<cmd>lua require('various-textobjs').closedFold('inner')<CR>")
				keymap({ "o", "x" }, "az", "<cmd>lua require('various-textobjs').closedFold('outer')<CR>")

				keymap({ "o", "x" }, "im", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>")
				keymap({ "o", "x" }, "am", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>")

				keymap({ "o", "x" }, "gw", "<cmd>lua require('various-textobjs').visibleInWindow()<CR>")
				keymap({ "o", "x" }, "gW", "<cmd>lua require('various-textobjs').restOfWindow()<CR>")

				keymap(
					{ "o", "x" },
					"il",
					"<cmd>lua require('various-textobjs').mdlink('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"al",
					"<cmd>lua require('various-textobjs').mdlink('outer')<CR>",
					{ buffer = true }
				)

				keymap(
					{ "o", "x" },
					"ie",
					"<cmd>lua require('various-textobjs').mdEmphasis('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"ae",
					"<cmd>lua require('various-textobjs').mdEmphasis('outer')<CR>",
					{ buffer = true }
				)

				keymap(
					{ "o", "x" },
					"iC",
					"<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"aC",
					"<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<CR>",
					{ buffer = true }
				)

				keymap(
					{ "o", "x" },
					"iy",
					"<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"ay",
					"<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>",
					{ buffer = true }
				)

				keymap(
					{ "o", "x" },
					"ic",
					"<cmd>lua require('various-textobjs').cssSelector('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"ac",
					"<cmd>lua require('various-textobjs').cssSelector('outer')<CR>",
					{ buffer = true }
				)

				keymap(
					{ "o", "x" },
					"ix",
					"<cmd>lua require('various-textobjs').htmlAttribute('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"ax",
					"<cmd>lua require('various-textobjs').htmlAttribute('outer')<CR>",
					{ buffer = true }
				)

				keymap(
					{ "o", "x" },
					"iD",
					"<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"aD",
					"<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>",
					{ buffer = true }
				)

				keymap(
					{ "o", "x" },
					"iP",
					"<cmd>lua require('various-textobjs').shellPipe('inner')<CR>",
					{ buffer = true }
				)
				keymap(
					{ "o", "x" },
					"aP",
					"<cmd>lua require('various-textobjs').shellPipe('outer')<CR>",
					{ buffer = true }
				)
			end,
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
