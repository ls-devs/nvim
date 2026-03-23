-- ── iron.nvim ────────────────────────────────────────────────────────────
-- Purpose : Interactive REPL — send code from a buffer to a running REPL
--           for Python, Node, TypeScript (ts-node), Lua, and Bash.
-- Trigger : cmd = IronRepl / IronRestart / IronFocus / IronHide; <leader>i* keymaps
-- Note    : REPL window opens as a centered float (border = "rounded") to
--           match the rest of the floating terminal pattern (snacks.terminal).
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"Vigemus/iron.nvim",
	cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
	config = function()
		local iron = require("iron.core")
		iron.setup({
			config = {
				-- Each filetype gets its own REPL buffer (not shared)
				scratch_repl = true,
				-- ── REPL definitions ──────────────────────────────────────
				repl_definition = {
					sh = { command = { "bash" } },
					python = {
						command = function()
							-- Prefer the active virtual-env Python if available
							local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
							if venv then
								return { venv .. "/bin/python3" }
							end
							return { vim.fn.exepath("python3") or "python3" }
						end,
					},
					javascript = { command = { "node" } },
					typescript = { command = { "npx", "ts-node", "--skip-project" } },
					lua = { command = { "lua" } },
				},
				-- ── REPL opens as a centered float ────────────────────────
				repl_open_cmd = function(buffer)
					local columns = vim.o.columns
					local lines = vim.o.lines
					local width = math.floor(columns * 0.65)
					local height = math.floor(lines * 0.4)
					local col = math.floor((columns - width) / 2)
					local row = math.floor((lines - height) / 2)
					return vim.api.nvim_open_win(buffer, true, {
						relative = "editor",
						border = "rounded",
						width = width,
						height = height,
						col = col,
						row = row,
						style = "minimal",
						title = " REPL ",
						title_pos = "center",
					})
				end,
			},
			-- Italicise the REPL output to visually separate it from code
			highlight = { italic = true },
			ignore_blank_lines = true,
			-- ── Keymaps ───────────────────────────────────────────────────
			keymaps = {
				send_motion = "<leader>is",
				visual_send = "<leader>iv",
				send_file = "<leader>iF",
				send_line = "<leader>il",
				send_paragraph = "<leader>ip",
				send_until_cursor = "<leader>iu",
				send_mark = "<leader>im",
				mark_motion = "<leader>ic",
				mark_visual = "<leader>ic",
				remove_mark = "<leader>iC",
				cr = "<leader>i<CR>",
				interrupt = "<leader>i<space>",
				exit = "<leader>iq",
				clear = "<leader>ix",
			},
		})
	end,
	keys = {
		{
			"<leader>ir",
			"<cmd>IronRepl<CR>",
			desc = "Iron Open REPL",
			noremap = true,
			silent = true,
		},
		{
			"<leader>iR",
			"<cmd>IronRestart<CR>",
			desc = "Iron Restart REPL",
			noremap = true,
			silent = true,
		},
		{
			"<leader>if",
			"<cmd>IronFocus<CR>",
			desc = "Iron Focus REPL",
			noremap = true,
			silent = true,
		},
		{
			"<leader>ih",
			"<cmd>IronHide<CR>",
			desc = "Iron Hide REPL",
			noremap = true,
			silent = true,
		},
	},
}
