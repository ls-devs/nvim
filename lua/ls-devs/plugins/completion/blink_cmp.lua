---@diagnostic disable: undefined-global
-- ── blink.cmp ────────────────────────────────────────────────────────────
-- Purpose : Fast async completion engine with a Rust-backed fuzzy matcher
-- Trigger : InsertEnter, CmdlineEnter
-- Provides: LSP / snippet / Copilot / buffer / dotenv / cmdline completions
-- Note    : Built with `cargo build --release`; blink.lib provides Rust fuzzy
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
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
		{ "Kaiser-Yang/blink-cmp-git", lazy = true },
	},
	opts = {
		---@return boolean
		enabled = function()
			-- Disable in snacks picker input to prevent interference with search typing.
			if vim.bo.filetype == "snacks_picker_input" then
				return false
			end
			-- Disable during macro recording/playback to avoid polluting the register
			-- and interfering with dot-repeat behaviour.
			if vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then
				return false
			end
			return true
		end,

		snippets = { preset = "luasnip" },

		-- ── Keymaps ───────────────────────────────────────────────────────────
		keymap = {
			preset = "none",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			-- Tab: explicit priority chain in a single function to prevent
			-- act_as_tab from inserting spaces when the menu is open.
			-- 1. Menu visible → select next item (Tab consumed even if no items)
			-- 2. Active snippet → jump to next tabstop
			-- 3. Otherwise → neotab bracket escape (or real tab for indentation)
			["<Tab>"] = {
				---@param cmp table
				---@return boolean
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.select_next()
					end
					if cmp.snippet_active() then
						return cmp.snippet_forward()
					end
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

		-- ── Cmdline ───────────────────────────────────────────────────────────
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
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = {},
				},
				list = {
					selection = { preselect = false, auto_insert = true },
				},
				menu = {
					auto_show = true,
				},
			},
		},

		-- ── Completion ────────────────────────────────────────────────────────
		completion = {
			accept = {
				auto_brackets = { enabled = true },
			},
			list = {
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},
			menu = {
				border = "rounded",
				scrollbar = false,
				auto_show_delay_ms = 100, -- increased from 0 to reduce popup aggression on every keystroke
				winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				-- noice.nvim wraps the cmdline in a bordered popup; blink's default formula
				-- (ui_cmdline_pos[1] - 1) + 1 lands exactly on noice's bottom border row.
				-- Using pos[1] directly (without -1) shifts the menu one row lower so it
				-- appears immediately BELOW noice's bottom border instead of overlapping it.
				---@return integer[]
				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos
						return { pos[1], pos[2] }
					end
					local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
					return { vim.o.lines - height, 0 }
				end,
				draw = {
					align_to = "cursor",
					columns = {
						{ "label" },
						{ "source_name" },
						{ "kind_icon" },
					},
					components = {
						label = {
							width = { fill = true, max = 60 },
							---@param ctx table
							---@return string
							text = function(ctx)
								return " " .. ctx.label .. (ctx.label_detail or "") .. " "
							end,
							---@param ctx table
							---@return table[]
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
							---@param ctx table
							---@return string
							text = function(ctx)
								local labels = {
									LSP = "[LSP]",
									Snippets = "[SNIPPET]",
									Buffer = "[BUFFER]",
									copilot = "[COPILOT]",
									LazyDev = "[LAZY]",
									Git = "[GIT]",
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
							---@param ctx table
							---@return string
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
							---@param ctx table
							---@return string
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
			ghost_text = { enabled = false }, -- off: Copilot suggestions appear inside the menu instead
		},

		-- ── Sources ───────────────────────────────────────────────────────────
		-- Priority ladder: lazydev=100 (Lua API docs) > lsp=90 > snippets=85
		-- Suppress completions when cursor is inside a comment by checking treesitter
		-- captures. Putting this check in sources.default (not enabled()) keeps all
		-- blink keymaps active — enabled()=false would also disable Tab, causing the
		-- "insert whitespace instead of select" bug when pressing Tab in a comment.
		-- per_filetype is handled here too so lazydev/sass-variables are also
		-- suppressed in comments (inherit_defaults bypasses the default function).
		sources = {
			---@return string[]
			default = function()
				local col = vim.api.nvim_win_get_cursor(0)[2]
				local ok, captures =
					pcall(vim.treesitter.get_captures_at_pos, 0, vim.fn.line(".") - 1, math.max(col - 1, 0))
				if ok then
					for _, cap in ipairs(captures) do
						if cap.capture:find("comment") then
							return {}
						end
					end
				end
				local ft = vim.bo.filetype
				if ft == "lua" then
					return { "lsp", "path", "snippets", "copilot", "buffer", "dotenv", "lazydev" }
				elseif ft == "gitcommit" then
					return { "git", "buffer" }
				elseif ft == "css" or ft == "scss" then
					return { "lsp", "path", "snippets", "copilot", "buffer", "dotenv", "sass-variables" }
				end
				return { "lsp", "path", "snippets", "copilot", "buffer", "dotenv" }
			end,
			providers = {
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					score_offset = 90,
					fallbacks = { "buffer" },
				},
				path = {
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 3,
					fallbacks = { "buffer" },
				},
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					score_offset = 85,
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
					score_offset = 80,
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
				git = {
					name = "Git",
					module = "blink-cmp-git",
					score_offset = 80,
					opts = {},
				},
			},
		},

		-- Use Rust fuzzy (blink.lib) when available; falls back to Lua with a warning.
		fuzzy = { implementation = "prefer_rust_with_warning" },

		signature = { enabled = false }, -- signature help is invoked manually via <C-s> instead of auto-show
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		vim.g.sass_variables_file = "_variables.scss"
		-- Register blink capabilities with all LSP servers (nvim 0.11 lsp/ dir)
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		require("luasnip.loaders.from_vscode").lazy_load()
		require("blink.cmp").setup(opts)

		-- ── Noice Flash Workaround ────────────────────────────────────────────
		-- blink.cmp creates floating windows at a placeholder position (row=1,col=1)
		-- then calls update_position() separately. Noice's forced redraws
		-- (vim.cmd.redraw / nvim__redraw) flush the screen between these two calls,
		-- causing a visible flash at the wrong size/position.
		-- Fix: intercept nvim_open_win to create blink windows hidden from birth,
		-- and wrap docs.update_position to always hide→reposition→unhide atomically.
		-- Re-entrancy guard prevents WinResized callbacks from nesting.
		local win_mod = require("blink.cmp.lib.window")
		local menu = require("blink.cmp.completion.windows.menu")
		local docs = require("blink.cmp.completion.windows.documentation")

		local _blink_hiding_win = false
		local orig_nvim_open_win = vim.api.nvim_open_win
		---@param buf integer
		---@param enter boolean
		---@param cfg vim.api.keyset.win_config
		---@return integer
		---@diagnostic disable-next-line: duplicate-set-field
		vim.api.nvim_open_win = function(buf, enter, cfg)
			if _blink_hiding_win then
				cfg = vim.tbl_extend("force", cfg, { hide = true })
			end
			return orig_nvim_open_win(buf, enter, cfg)
		end

		local orig_win_open = win_mod.open
		---@param self table
		---@diagnostic disable-next-line: duplicate-set-field
		win_mod.open = function(self)
			local was_open = self:is_open()
			if not was_open and (self == menu.win or self == docs.win) then
				_blink_hiding_win = true
				orig_win_open(self)
				_blink_hiding_win = false
			else
				orig_win_open(self)
			end
			if was_open or not self.id then
				return
			end
			if self == menu.win then
				if menu.context ~= nil and menu.renderer ~= nil then
					menu.update_position()
				end
				vim.api.nvim_win_set_config(self.id, { hide = false })
			end
		end

		local orig_docs_update_position = docs.update_position
		local docs_update_in_progress = false
		---@diagnostic disable-next-line: duplicate-set-field
		docs.update_position = function()
			if docs_update_in_progress then
				orig_docs_update_position()
				return
			end
			local win_id = docs.win:is_open() and docs.win.id or nil
			if win_id then
				vim.api.nvim_win_set_config(win_id, { hide = true })
			end
			docs_update_in_progress = true
			orig_docs_update_position()
			docs_update_in_progress = false
			if docs.win:is_open() and docs.win.id then
				vim.api.nvim_win_set_config(docs.win.id, { hide = false })
			end
		end
	end,
}
