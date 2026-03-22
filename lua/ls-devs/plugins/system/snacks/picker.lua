-- ── snacks/picker.lua ────────────────────────────────────────────────────
-- Picker (replaces telescope.nvim) opts for snacks.lua.
-- Layout: reverse list (best match near prompt), equal 50/50 split,
-- preview wrap=false for horizontal scroll, frecency matcher.
-- <A-f>/<A-b> override snacks default toggle_follow via normkey normalization
-- (both <A-f> and <a-f> resolve to <M-f>, user config wins).
-- ─────────────────────────────────────────────────────────────────────────
return {
	-- snacks replaces vim.ui.select (URL picker in treesitter.lua, etc.)
	ui_select = true,
	-- Magnifying glass (loupe) icon shown left of the search input.
	prompt = "  ",
	layout = {
		reverse = true,
		layout = {
			box = "horizontal",
			width = 0.9,
			height = 0.85,
			border = "none",
			{
				box = "vertical",
				width = 0.5,
				border = "rounded",
				title = "  {title} ",
				title_pos = "center",
				{ win = "list", border = "none" },
				{ win = "input", height = 1, border = "top" },
			},
			{
				win = "preview",
				title = " {preview} ",
				title_pos = "center",
				width = 0.5,
				border = "rounded",
			},
		},
	},
	win = {
		input = {
			keys = {
				["<C-j>"] = { "list_down", mode = { "i", "n" } },
				["<C-k>"] = { "list_up", mode = { "i", "n" } },
				["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
				["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
				["<A-a>"] = { "select_all", mode = { "i", "n" } },
				["<C-s>"] = { "edit_vsplit", mode = { "i", "n" } },
				["<C-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
				["<C-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
				-- <A-f>/<A-b> override snacks default toggle_follow/<a-b>=gh_browse
				-- because normkey normalizes <A-f> and <a-f> to the same <M-f> key.
				["<A-f>"] = { "preview_scroll_right", mode = { "i", "n" }, desc = "Scroll preview right" },
				["<A-b>"] = { "preview_scroll_left", mode = { "i", "n" }, desc = "Scroll preview left" },
				["<A-h>"] = { "toggle_hidden", mode = { "i", "n" } },
				["<A-i>"] = { "toggle_ignored", mode = { "i", "n" } },
			},
		},
		-- Mirror all bindings on the list window so they work when focus
		-- moves out of the input (e.g. after pressing <Esc> or <C-j>).
		list = {
			keys = {
				["<C-j>"] = "list_down",
				["<C-k>"] = "list_up",
				["<Tab>"] = "select_and_next",
				["<S-Tab>"] = "select_and_prev",
				["<A-a>"] = "select_all",
				["<C-s>"] = "edit_vsplit",
				["<C-f>"] = "preview_scroll_down",
				["<C-b>"] = "preview_scroll_up",
				["<A-f>"] = { "preview_scroll_right", desc = "Scroll preview right" },
				["<A-b>"] = { "preview_scroll_left", desc = "Scroll preview left" },
				["<A-h>"] = "toggle_hidden",
				["<A-i>"] = "toggle_ignored",
			},
		},
		-- wrap=false required for zh/zl (A-f/A-b) horizontal scroll to work.
		preview = {
			wo = { wrap = false },
		},
	},
	matcher = { frecency = true },
	-- Always start with hidden/ignored files OFF. Without this, the resume
	-- feature restores the last toggle state — so pressing A-h once would
	-- cause every subsequent picker session to show hidden files.
	hidden = false,
	ignored = false,
	toggles = {
		hidden = false, -- don't persist hidden-files toggle across sessions
		ignored = false, -- don't persist ignored-files toggle across sessions
	},
	-- Disable preview for ui_select: items (keymaps, actions, etc.) have no file.
	sources = {
		select = {
			preview = false,
		},
	},
}
