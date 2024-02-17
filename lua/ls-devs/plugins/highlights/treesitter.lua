return {
	"nvim-treesitter/nvim-treesitter",
	cmd = { "TSUpdate", "TSInstall" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		ignore_install = {},
		modules = {},
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
		rainbow = {
			enable = true,
			extended_mode = true,
		},
		autotag = {
			enable = true,
		},
		indent = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				},
				selection_modes = {
					["@parameter.outer"] = "v",
					["@function.outer"] = "V",
					["@class.outer"] = "<c-v>",
				},
				include_surrounding_whitespace = false,
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "chrisgrieser/nvim-various-textobjs", opts = { useDefaultKeymaps = true } },
		{
			"HiPhish/rainbow-delimiters.nvim",
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
