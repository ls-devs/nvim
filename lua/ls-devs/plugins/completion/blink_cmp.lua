---@diagnostic disable: undefined-global
return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	build = "cargo build --release",
	dependencies = {
		{ "saghen/blink.lib", lazy = true },
		{
			"L3MON4D3/LuaSnip",
			lazy = true,
			build = "make install_jsregexp",
			dependencies = {
				{ "rafamadriz/friendly-snippets", lazy = true },
			},
		},
		{
			"giuxtaposition/blink-cmp-copilot",
			lazy = true,
			dependencies = { "zbirenbaum/copilot.lua" },
		},
		{
			"saghen/blink.compat",
			version = "*",
			lazy = true,
			opts = {},
		},
		{ "pontusk/cmp-sass-variables", lazy = true },
	},
	opts = {
		enabled = function()
			if vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then
				return false
			end
			-- disable in comments via treesitter
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local ok, captures =
				pcall(vim.treesitter.get_captures_at_pos, 0, vim.fn.line(".") - 1, math.max(col - 1, 0))
			if ok then
				for _, cap in ipairs(captures) do
					if cap.capture:find("comment") then
						return false
					end
				end
			end
			-- fallback: syntax group
			local syn = vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), true), "name")
			if syn:lower():find("comment") then
				return false
			end
			return true
		end,

		snippets = { preset = "luasnip" },

		keymap = {
			preset = "none",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = {
				"select_next",
				"snippet_forward",
				function()
					require("neotab").tabout()
					return true
				end,
			},
			["<S-Tab>"] = {
				"select_prev",
				"snippet_backward",
				"fallback",
			},
		},

		cmdline = {
			keymap = {
				preset = "cmdline",
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<CR>"] = { "accept_and_enter", "fallback" },
				["<C-e>"] = { "cancel", "fallback" },
			},
			completion = {
				ghost_text = { enabled = true },
				list = {
					selection = { preselect = true, auto_insert = true },
				},
			},
		},

		completion = {
			accept = {
				auto_brackets = { enabled = true },
			},
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},
			menu = {
				border = "rounded",
				scrollbar = false,
				winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				-- noice.nvim wraps the cmdline in a bordered popup; blink's default formula
				-- (ui_cmdline_pos[1] - 1) + 1 lands exactly on noice's bottom border row.
				-- Using pos[1] directly (without -1) shifts the menu one row lower so it
				-- appears immediately BELOW noice's bottom border instead of overlapping it.
				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos
						return { pos[1], pos[2] }
					end
					local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
					return { vim.o.lines - height, 0 }
				end,
				draw = {
					columns = {
						{ "label" },
						{ "source_name" },
						{ "kind_icon" },
					},
					components = {
						label = {
							width = { fill = true, max = 60 },
							text = function(ctx)
								return " " .. ctx.label .. (ctx.label_detail or "") .. " "
							end,
							highlight = function(ctx)
								local label_len = #ctx.label + (ctx.label_detail and #ctx.label_detail or 0)
								local highlights = {
									{
										0,
										label_len + 2,
										group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
									},
								}
								if ctx.label_detail then
									table.insert(highlights, {
										#ctx.label + 1,
										label_len + 1,
										group = "BlinkCmpLabelDetail",
									})
								end
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx + 1, idx + 2, group = "BlinkCmpLabelMatch" })
								end
								return highlights
							end,
						},
						source_name = {
							width = { max = 12 },
							text = function(ctx)
								local labels = {
									LSP = "[LSP]",
									Snippets = "[SNIPPET]",
									Buffer = "[BUFFER]",
									copilot = "[COPILOT]",
									LazyDev = "[LAZY]",
									["sass-variables"] = "[SASS]",
									dotenv = "[ENV]",
									Cmdline = "[CMD]",
								}
								return labels[ctx.source_name] or ""
							end,
							highlight = "CmpItemMenu",
						},
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local symbol_map = {
									Text = "󰉿",
									Method = "󰆧",
									Function = "󰊕",
									Field = "󰜢",
									Variable = "󰀫",
									Constructor = "󰒓",
									Interface = "󰜰",
									Module = "󰅩",
									EnumMember = "󰎒",
									Event = "󱐋",
									Class = "󰠱",
									Property = "󰜢",
									Unit = "󰑭",
									Value = "󰎠",
									Enum = "󰖽",
									Keyword = "󰌋",
									Snippet = "󱄽",
									Color = "󰏘",
									File = "󰈙",
									Reference = "󰈇",
									Folder = "󰉋",
									Constant = "󰏿",
									Struct = "󰙅",
									Operator = "󰆕",
									TypeParameter = "󰬛",
									Unknown = "󰉿",
									Copilot = "",
								}
								local icon = symbol_map[ctx.kind] or symbol_map["Unknown"]
								return "  " .. icon .. "  "
							end,
							highlight = function(ctx)
								return "CmpItemKind" .. ctx.kind
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "rounded",
					scrollbar = false,
					winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder",
				},
			},
			ghost_text = { enabled = false },
		},

		sources = {
			default = { "copilot", "lsp", "lazydev", "snippets", "buffer", "dotenv" },
			per_filetype = {
				gitcommit = { "buffer" },
				css = { inherit_defaults = true, "sass-variables" },
				scss = { inherit_defaults = true, "sass-variables" },
			},
			providers = {
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					score_offset = 90,
				},
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					score_offset = 80,
					max_items = 5,
				},
				buffer = {
					name = "Buffer",
					module = "blink.cmp.sources.buffer",
					max_items = 5,
				},
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 100,
					async = true,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				dotenv = {
					name = "dotenv",
					module = "ls-devs.plugins.completion.completion_modules.dotenv_source",
					score_offset = -5,
				},
				["sass-variables"] = {
					name = "sass-variables",
					module = "blink.compat.source",
					score_offset = -5,
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },

		signature = { enabled = false },
	},
	config = function(_, opts)
		vim.g.sass_variables_file = "_variables.scss"
		-- Register blink capabilities with all LSP servers (nvim 0.11 lsp/ dir)
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		require("luasnip.loaders.from_vscode").lazy_load()
		require("blink.cmp").setup(opts)
	end,
}
