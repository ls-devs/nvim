-- ── noice.nvim ───────────────────────────────────────────────────────────────
-- Purpose : Replaces cmdline, messages, and popupmenu with styled floating
--           windows. Integrates with blink.cmp, snacks.notifier, and lspsaga.
-- Trigger : VeryLazy
-- Note    : <C-f>/<C-b> scroll hover docs (wired in legendary.lua).
--           <A-x> redirects cmdline output to a popup.
--           blink.cmp has a workaround for flashing caused by noice redraws.
-- ─────────────────────────────────────────────────────────────────────────────
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
	config = function(_, opts)
		require("noice").setup(vim.tbl_deep_extend("force", opts, {
			markdown = {
				hover = {
					["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
				},
			},
		}))
	end,
	-- ── Dependencies ──────────────────────────────────────────────────────────────
	dependencies = {
		{ "MunifTanjim/nui.nvim", lazy = true },
		-- nvim-notify removed: snacks.notifier is the vim.notify backend now.
	},
}
