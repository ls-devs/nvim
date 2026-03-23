---@diagnostic disable: undefined-global
-- ── snacks/keys.lua ──────────────────────────────────────────────────────
-- All lazy.nvim `keys` specs for snacks.nvim.
-- Sections: Terminal, Picker (files/text/git/LSP), Gitbrowse, Bufdelete, Words.
-- ─────────────────────────────────────────────────────────────────────────
---@type table[]
return {
	-- ── Terminal ─────────────────────────────────────────────────────────
	-- <C-\> and <leader>z both toggle the float (mirrors old toggleterm mapping)
	{
		"<c-\\>",
		function()
			Snacks.terminal()
		end,
		desc = "Terminal Toggle",
	},
	{
		"<leader>z",
		function()
			Snacks.terminal()
		end,
		desc = "Terminal Toggle",
	},

	-- ── Picker — files ───────────────────────────────────────────────────
	{
		"<leader>ff",
		function()
			Snacks.picker.files()
		end,
		desc = "Find Files",
	},
	{
		"<leader>ft",
		function()
			Snacks.picker.grep()
		end,
		desc = "Live Grep",
	},
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>fx",
		function()
			Snacks.picker.help()
		end,
		desc = "Help Tags",
	},
	{
		"<leader>fp",
		function()
			Snacks.picker.recent({ filter = { cwd = true } })
		end,
		desc = "Recent Files",
	},
	{
		"<leader>fa",
		function()
			Snacks.picker.autocmds()
		end,
		desc = "Autocommands",
	},
	{
		"<leader>fc",
		function()
			Snacks.picker.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>fk",
		function()
			Snacks.picker.keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>fH",
		function()
			Snacks.picker.highlights()
		end,
		desc = "Highlights",
	},
	{
		"<leader>fB",
		function()
			Snacks.picker.lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>fC",
		function()
			Snacks.picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>fM",
		function()
			Snacks.picker.marks()
		end,
		desc = "Marks",
	},
	-- Nerd Font icons (replaces telescope-nerdy extension)
	{
		"<leader>fg",
		function()
			Snacks.picker.icons()
		end,
		desc = "Icons (Nerd Font)",
	},
	-- Commands fuzzy (replaces telescope-cmdline extension)
	{
		"<leader>fcm",
		function()
			Snacks.picker.commands()
		end,
		desc = "Commands (fuzzy)",
	},

	-- ── Picker — git ─────────────────────────────────────────────────────
	{
		"<leader>gs",
		function()
			Snacks.picker.git_status()
		end,
		desc = "Git Status",
	},
	{
		"<leader>gc",
		function()
			Snacks.picker.git_log()
		end,
		desc = "Git Commits",
	},
	{
		"<leader>gb",
		function()
			Snacks.picker.git_branches()
		end,
		desc = "Git Branches",
	},

	-- ── Gitbrowse ────────────────────────────────────────────────────────
	-- Opens current file/line/commit in the browser (GitHub, GitLab, etc.)
	{
		"<leader>gB",
		function()
			Snacks.gitbrowse()
		end,
		desc = "Git Browse (open in browser)",
		mode = { "n", "v" },
	},

	-- ── Notifier ─────────────────────────────────────────────────────────
	{
		"<leader>nd",
		function()
			Snacks.notifier.hide()
		end,
		desc = "Notify Dismiss All",
		silent = true,
	},
	{
		"<leader>hn",
		function()
			Snacks.notifier.show_history()
		end,
		desc = "Notify History",
	},

	-- ── Picker — LSP ─────────────────────────────────────────────────────
	-- gr replaces the old <cmd>Telescope lsp_references<CR> binding
	{
		"gr",
		function()
			Snacks.picker.lsp_references()
		end,
		desc = "LSP References",
		nowait = true,
	},

	{
		"<leader>sd",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics (Workspace)",
	},
	{
		"<leader>sD",
		function()
			Snacks.picker.diagnostics_buffer()
		end,
		desc = "Diagnostics (Buffer)",
	},

	-- ── Bufdelete ────────────────────────────────────────────────────────
	{
		"<leader>bd",
		function()
			Snacks.bufdelete()
		end,
		desc = "Delete Buffer",
	},

	-- ── Words navigation ─────────────────────────────────────────────────
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next LSP Reference",
		mode = { "n", "t" },
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev LSP Reference",
		mode = { "n", "t" },
	},
}
