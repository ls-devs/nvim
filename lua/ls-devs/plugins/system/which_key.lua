-- ── which-key.nvim ───────────────────────────────────────────────────────
-- Purpose : Keymap discovery popup — shows available keybindings when you
--           pause on a prefix key. Reads all existing desc fields automatically.
-- Trigger : VeryLazy
-- Theme   : Catppuccin Mocha via integrations.which_key = true in catppuccin.lua
-- Note    : No mapping changes needed — all existing keymaps already have desc.
--           <leader>? shows all keymaps for the current buffer.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		icons = {
			mappings = true,
			keys = {},
			group = "",
			-- Icon rules: matched against keymap desc in order, first match wins.
			-- Covers all custom function() keymaps that mini.icons can't auto-resolve.
			rules = {
				-- ── Find / Search ──────────────────────────────────────────
				{ pattern = "find files", icon = "󰈞", color = "blue" },
				{ pattern = "live grep", icon = "󰺮", color = "blue" },
				{ pattern = "grep", icon = "󰺮", color = "blue" },
				{ pattern = "find", icon = "󰍉", color = "blue" },
				{ pattern = "search", icon = "󰱼", color = "blue" },
				{ pattern = "buffer lines", icon = "󰈙", color = "blue" },
				{ pattern = "recent files", icon = "󱋡", color = "blue" },
				{ pattern = "buffers", icon = "󰈙", color = "azure" },
				{ pattern = "marks", icon = "󰃀", color = "yellow" },
				{ pattern = "registers", icon = "󱄻", color = "yellow" },
				{ pattern = "command history", icon = "󰋚", color = "purple" },
				{ pattern = "commands", icon = "󰘳", color = "purple" },
				{ pattern = "icons", icon = "󰀻", color = "yellow" },
				{ pattern = "highlights", icon = "󰸱", color = "yellow" },
				{ pattern = "keymaps", icon = "󰌌", color = "azure" },
				{ pattern = "autocommands", icon = "󱐋", color = "azure" },
				{ pattern = "help tags", icon = "󰋖", color = "azure" },
				{ pattern = "help grep", icon = "󰋖", color = "azure" },
				{ pattern = "todo", icon = "󰄵", color = "yellow" },
				-- ── Git ────────────────────────────────────────────────────
				{ pattern = "git status", icon = "󰊢", color = "orange" },
				{ pattern = "git commits", icon = "󰜘", color = "orange" },
				{ pattern = "git branches", icon = "󰘬", color = "orange" },
				{ pattern = "git browse", icon = "󰖟", color = "orange" },
				{ pattern = "git worktree", icon = "󰙅", color = "orange" },
				{ pattern = "git conflict", icon = "󰩹", color = "red" },
				{ pattern = "gitsigns toggle blame", icon = "󰊢", color = "orange" },
				{ pattern = "gitsigns toggle word diff", icon = "󰦓", color = "orange" },
				{ pattern = "lazygit", icon = "󰊢", color = "green" },
				{ pattern = "diffview", icon = "󰦓", color = "orange" },
				{ pattern = "github auth", icon = "󰊤", color = "grey" },
				-- ── LSP ────────────────────────────────────────────────────
				{ pattern = "lsp references", icon = "󰈇", color = "blue" },
				{ pattern = "lsp signature", icon = "󰊕", color = "blue" },
				{ pattern = "lsp hover", icon = "󰋖", color = "blue" },
				{ pattern = "lspsaga finder", icon = "󰍉", color = "blue" },
				{ pattern = "lspsaga code actions", icon = "󰌵", color = "yellow" },
				{ pattern = "lspsaga peek", icon = "󰈈", color = "blue" },
				{ pattern = "lspsaga goto", icon = "󰆼", color = "blue" },
				{ pattern = "lspsaga.*implementation", icon = "󰡱", color = "blue" },
				{ pattern = "lspsaga rename", icon = "󰑕", color = "yellow" },
				{ pattern = "rename", icon = "󰑕", color = "yellow" },
				{ pattern = "lspsaga outline", icon = "󱒎", color = "blue" },
				{ pattern = "lspsaga.*calls", icon = "󰊕", color = "blue" },
				{ pattern = "lspsaga.*diagnostic", icon = "󰒡", color = "red" },
				{ pattern = "diagnostics", icon = "󰒡", color = "red" },
				{ pattern = "ts organize imports", icon = "󰋺", color = "blue" },
				{ pattern = "ts add missing imports", icon = "󰐗", color = "blue" },
				{ pattern = "ts remove unused imports", icon = "󰍷", color = "red" },
				{ pattern = "mason", icon = "󱌣", color = "blue" },
				-- ── DAP / Debug ────────────────────────────────────────────
				{ pattern = "dap.*toggle.*breakpoint", icon = "󰝥", color = "red" },
				{ pattern = "dap.*continue", icon = "󰐊", color = "green" },
				{ pattern = "dap.*terminate", icon = "󰓛", color = "red" },
				{ pattern = "dap step over", icon = "󰆷", color = "yellow" },
				{ pattern = "dap step into", icon = "󰆹", color = "yellow" },
				{ pattern = "dap step out", icon = "󰆸", color = "yellow" },
				{ pattern = "dap run to cursor", icon = "󰐊", color = "green" },
				{ pattern = "dapui", icon = "󰃤", color = "purple" },
				{ pattern = "dap", icon = "󰃤", color = "purple" },
				{ pattern = "debug", icon = "󰃤", color = "purple" },
				-- ── Test ───────────────────────────────────────────────────
				{ pattern = "neotest run", icon = "󰙨", color = "green" },
				{ pattern = "neotest debug", icon = "󰃤", color = "purple" },
				{ pattern = "neotest.*summary", icon = "󰋖", color = "blue" },
				{ pattern = "neotest.*output", icon = "󰉸", color = "azure" },
				{ pattern = "neotest.*failed", icon = "󰅙", color = "red" },
				{ pattern = "neotest stop", icon = "󰓛", color = "red" },
				-- ── Format / Lint ──────────────────────────────────────────
				{ pattern = "format buffer", icon = "󰉢", color = "blue" },
				{ pattern = "codespell", icon = "󰓆", color = "yellow" },
				-- ── File / Explorer ────────────────────────────────────────
				{ pattern = "neotree", icon = "󰙅", color = "green" },
				{ pattern = "explorer", icon = "󰉋", color = "green" },
				{ pattern = "file system", icon = "󰝰", color = "green" },
				-- ── Terminal / REPL ────────────────────────────────────────
				{ pattern = "terminal", icon = "󰆍", color = "green" },
				{ pattern = "iron.*repl", icon = "󰘞", color = "cyan" },
				{ pattern = "repl", icon = "󰘞", color = "cyan" },
				-- ── AI / CodeCompanion ─────────────────────────────────────
				{ pattern = "codecompanion", icon = "󰚩", color = "green" },
				-- ── HTTP / Kulala ──────────────────────────────────────────
				{ pattern = "kulala run", icon = "󰖟", color = "blue" },
				{ pattern = "kulala", icon = "󰖟", color = "azure" },
				-- ── Overseer / Tasks ───────────────────────────────────────
				{ pattern = "overseer", icon = "󰑮", color = "yellow" },
				{ pattern = "task", icon = "󰄵", color = "yellow" },
				-- ── UI ─────────────────────────────────────────────────────
				{ pattern = "trouble", icon = "󰒡", color = "red" },
				{ pattern = "noice dismiss", icon = "󰅖", color = "purple" },
				{ pattern = "noice", icon = "󰍡", color = "purple" },
				{ pattern = "markview toggle", icon = "󰽛", color = "blue" },
				{ pattern = "color", icon = "󰏘", color = "yellow" },
				{ pattern = "toggle", icon = "󰔡", color = "yellow" },
				{ pattern = "focus", icon = "󱋱", color = "azure" },
				{ pattern = "fold", icon = "󰡏", color = "azure" },
				{ pattern = "ufo", icon = "󰁃", color = "azure" },
				{ pattern = "tab", icon = "󰓩", color = "azure" },
				{ pattern = "window", icon = "󱂬", color = "azure" },
				{ pattern = "split", icon = "󰤻", color = "azure" },
				{ pattern = "resize", icon = "󰙖", color = "azure" },
				{ pattern = "swap buffer", icon = "󰓡", color = "azure" },
				-- ── Motion / Editing ───────────────────────────────────────
				{ pattern = "flash", icon = "⚡", color = "yellow" },
				{ pattern = "surround", icon = "󰅪", color = "cyan" },
				{ pattern = "comment", icon = "󰆉", color = "grey" },
				{ pattern = "treesj", icon = "󰗈", color = "blue" },
				{ pattern = "treewalker", icon = "󰙅", color = "blue" },
				{ pattern = "multiple.*cursor", icon = "󰇀", color = "purple" },
				{ pattern = "move line", icon = "󰜸", color = "azure" },
				{ pattern = "paste", icon = "󰅍", color = "azure" },
				-- ── Misc ───────────────────────────────────────────────────
				{ pattern = "lazy$", icon = "󰒲", color = "purple" },
				{ pattern = "octo", icon = "󰊤", color = "grey" },
				{ pattern = "grug", icon = "󰍫", color = "blue" },
				{ pattern = "coverage", icon = "󰅲", color = "green" },
			},
		},
		win = {
			border = "rounded",
			title_pos = "center", -- prevents icon clipping against the ╭ corner
			padding = { 1, 2 },
			width = { min = 30, max = 0.4 },
		},
		-- Group labels derived from every keymap in this config.
		-- No hardcoded glyphs — mini.icons (lazy=false) resolves icons automatically.
		spec = {
			-- ── Leader prefixes (normal mode) ─────────────────────────────
			{ "<leader>f", group = "Find/Files", icon = { icon = "󰍉", color = "blue" } },
			{ "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
			{ "<leader>s", group = "Search/Diagnostics", icon = { icon = "󰱼", color = "blue" } },
			{ "<leader>d", group = "Diagnostics/DAP", icon = { icon = "󰒡", color = "red" } },
			{ "<leader>c", group = "Code/AI", icon = { icon = "󰘦", color = "green" } },
			{ "<leader>r", group = "Run/Rename", icon = { icon = "󰑕", color = "yellow" } },
			{ "<leader>u", group = "UI/Debug", icon = { icon = "󰒓", color = "purple" } },
			{ "<leader>w", group = "Window/Worktree", icon = { icon = "󱂬", color = "azure" } },
			{ "<leader>b", group = "Buffer/Breakpoint", icon = { icon = "󰆊", color = "orange" } },
			{ "<leader>T", group = "Test", icon = { icon = "󰙨", color = "green" } },
			{ "<leader>i", group = "REPL", icon = { icon = "󰘞", color = "cyan" } },
			{ "<leader>h", group = "Help/HTTP", icon = { icon = "󰖟", color = "blue" } },
			{ "<leader>n", group = "Notify/Next", icon = { icon = "󰒭", color = "yellow" } },
			{ "<leader>p", group = "Swap Prev", icon = { icon = "󰒮", color = "yellow" } },
			{ "<leader>l", group = "Lazy", icon = { icon = "󰒲", color = "purple" } },
			{ "<leader>m", group = "Multi-Cursor", icon = { icon = "󰇀", color = "purple" } },
			{ "<leader>e", group = "Explorer", icon = { icon = "󰙅", color = "green" } },
			{ "<leader>z", group = "Terminal", icon = { icon = "󰆍", color = "green" } },
			{ "<leader>lo", group = "LSP Outline", icon = { icon = "󱒎", color = "blue" } },
			{ "<leader>ci", group = "Call Hierarchy In", icon = { icon = "󰊕", color = "blue" } },
			-- ── Navigation prefixes ───────────────────────────────────────
			{ "]", group = "Next", icon = { icon = "󰜴", color = "green" } },
			{ "[", group = "Prev", icon = { icon = "󰜲", color = "red" } },
			-- ── Operator prefixes (normal + visual) ───────────────────────
			{ "gz", group = "Surround", mode = { "n", "v" }, icon = { icon = "󰅪", color = "cyan" } },
			{ "gc", group = "Comment", mode = { "n", "v" }, icon = { icon = "󰆉", color = "grey" } },
			-- ── Visual-mode leader groups ─────────────────────────────────
			-- These duplicate the normal-mode groups so which-key shows group
			-- names (instead of "N Keymaps") when <leader> is pressed in visual mode.
			{ "<leader>f", group = "Find/Files", mode = { "v" }, icon = { icon = "󰍉", color = "blue" } },
			{ "<leader>g", group = "Git", mode = { "v" }, icon = { icon = "󰊢", color = "orange" } },
			{ "<leader>c", group = "Code/AI", mode = { "v" }, icon = { icon = "󰘦", color = "green" } },
			{ "<leader>m", group = "Multi-Cursor", mode = { "v", "x" }, icon = { icon = "󰇀", color = "purple" } },
		},
	},
}
