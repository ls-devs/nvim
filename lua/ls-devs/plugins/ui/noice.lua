-- ── noice.nvim ───────────────────────────────────────────────────────────────
-- Purpose : Replaces cmdline, messages, and popupmenu with styled floating
--           windows. Integrates with blink.cmp, snacks.notifier, and lspsaga.
-- Trigger : VeryLazy
-- Note    : <C-f>/<C-b> scroll hover docs (wired in core/keymaps.lua).
--           <A-x> redirects cmdline output to a popup.
--           blink.cmp has a workaround for flashing caused by noice redraws.
-- ─────────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- ── LSP integration ──────────────────────────────────────────────────────────
		lsp = {
			-- Let noice render markdown in hover/signature instead of the built-in handlers.
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
			progress = {
				enabled = false,
			},
			hover = {
				enabled = true,
				silent = true,
			},
			-- Auto-open disabled to avoid conflicts with blink.cmp's own signature popup.
			signature = {
				enabled = true,
				auto_open = {
					enabled = false,
					trigger = false,
					luasnip = false,
					throttle = 50,
				},
				view = nil,
				opts = {},
			},
			documentation = {
				view = "hover",
				opts = {
					replace = true,
					render = "plain",
					format = { "{message}" },
					win_options = { concealcursor = "n", conceallevel = 3 },
				},
			},
		},
		-- ── Markdown rendering ────────────────────────────────────────────────────────
		markdown = {
			hover = {
				["|(%S-)|"] = vim.cmd.help,
			},
			highlights = {
				["|%S-|"] = "@text.reference",
				["@%S+"] = "@parameter",
				["^%s*(Parameters:)"] = "@text.title",
				["^%s*(Return:)"] = "@text.title",
				["^%s*(See also:)"] = "@text.title",
				["{%S-}"] = "@parameter",
			},
		},
		-- ── Routing ───────────────────────────────────────────────────────────────────
		-- blink.cmp supplies its own popupmenu; disable noice's to avoid duplication.
		popupmenu = {
			enabled = false,
		},
		-- <A-x> pipes the current cmdline output to a floating popup window.
		redirect = {
			view = "popup",
			filter = { event = "msg_show" },
		},
		health = {
			checker = true,
		},
		-- ── Presets ───────────────────────────────────────────────────────────────────
		presets = {
			bottom_search = false, -- keep / search at cursor position, not a bottom bar
			command_palette = true, -- merge cmdline + completion into a single popup
			long_message_to_split = true,
			inc_rename = true, -- show rename preview in a noice input widget
			lsp_doc_border = "rounded",
		},
		-- ── Notify ────────────────────────────────────────────────────────────────────
		-- Disabled: snacks.notifier owns vim.notify instead of noice+nvim-notify.
		notify = {
			enabled = false,
		},
		routes = {},
		messages = {
			enabled = true,
			view_search = false, -- shown as inline extmark instead (see config below)
		},
		-- ── Views ─────────────────────────────────────────────────────────────────────
		-- Position the command palette near the top-center of the screen.
		views = {
			cmdline_popup = {
				position = {
					row = 5,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
			},
		},
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("noice").setup(vim.tbl_deep_extend("force", opts, {
			markdown = {
				hover = {
					["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
				},
			},
		}))

		-- ── Inline search count (smooth-scroll-compatible) ────────────────────────────
		-- noice view_search is disabled; we draw our own extmark at EOL instead.
		-- Unlike noice's own rendering (which uses screen coordinates), an extmark
		-- is anchored to the buffer line and tracked by Neovim through scroll
		-- animations automatically — no WinScrolled workaround needed.
		-- Virtual-text render order — Neovim draws highest priority LAST (rightmost).
		-- neotest's status consumer uses nvim_buf_set_extmark with no priority → default 10.
		-- Desired order: search(5) → neotest-icon(10, hardcoded) → blame(300)
		local search_ns = vim.api.nvim_create_namespace("ls_inline_search")
		local MARK_ID = 1

		local function search_clear()
			pcall(vim.api.nvim_buf_del_extmark, 0, search_ns, MARK_ID)
		end

		local function search_update()
			if vim.v.hlsearch == 0 then
				search_clear()
				return
			end
			local ok, res = pcall(vim.fn.searchcount, { maxcount = 999 })
			if not ok or not res or (res.total or 0) == 0 then
				search_clear()
				return
			end
			local text
			if res.incomplete == 2 then
				text = string.format("  [>%d/%d]", res.current, res.maxcount)
			else
				text = string.format("  [%d/%d]", res.current, res.total)
			end
			local row = vim.api.nvim_win_get_cursor(0)[1] - 1
			pcall(vim.api.nvim_buf_set_extmark, 0, search_ns, row, 0, {
				id = MARK_ID,
				virt_text = { { text, "DiagnosticWarn" } },
				virt_text_pos = "eol",
				priority = 5,
			})
		end

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			desc = "Update inline search count on cursor movement",
			callback = search_update,
		})

		-- Catch hlsearch being cleared without cursor movement (e.g. <Esc>).
		vim.api.nvim_create_autocmd("CursorHold", {
			desc = "Clear inline search count when hlsearch is off",
			callback = function()
				if vim.v.hlsearch == 0 then
					search_clear()
				end
			end,
		})
	end,
	-- ── Dependencies ──────────────────────────────────────────────────────────────
	dependencies = {
		{ "MunifTanjim/nui.nvim", lazy = true },
		-- nvim-notify removed: snacks.notifier is the vim.notify backend now.
		-- inc-rename: activates the inc_rename = true preset above — provides
		-- live-preview rename where every occurrence updates as you type.
		{ "smjonas/inc-rename.nvim", lazy = true, opts = {} },
	},
	keys = {
		{
			"<leader>nd",
			"<cmd>NoiceDismiss<CR>",
			desc = "Noice Dismiss Messages",
			noremap = true,
			silent = true,
		},
	},
}
