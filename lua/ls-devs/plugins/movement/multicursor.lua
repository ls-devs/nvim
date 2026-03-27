-- ── multicursor.nvim ─────────────────────────────────────────────────────
-- Purpose : Multi-cursor editing — add cursors by line, word match, search,
--           operator range, or mouse click; then edit normally.
-- Trigger : keys
-- Keymaps :
--   <C-Down/Up>      — add cursor line below/above
--   <leader>m*       — all match/manage operations (see spec below)
--   ga               — cursor operator (gaip = cursor each line of paragraph)
--   <C-LeftClick>    — add/remove cursor with mouse
--   <Esc>            — clear cursors (keymap layer, only when cursors active)
--   <Left>/<Right>   — rotate through cursors (keymap layer)
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	keys = {
		{ "<C-Down>", mode = { "n", "x" }, desc = "MC Add Cursor Down" },
		{ "<C-Up>", mode = { "n", "x" }, desc = "MC Add Cursor Up" },
		{ "<leader>mj", mode = { "n", "x" }, desc = "MC Skip Line Down" },
		{ "<leader>mk", mode = { "n", "x" }, desc = "MC Skip Line Up" },
		{ "<leader>mn", mode = { "n", "x" }, desc = "MC Add Cursor Next Match" },
		{ "<leader>mN", mode = { "n", "x" }, desc = "MC Add Cursor Prev Match" },
		{ "<leader>ms", mode = { "n", "x" }, desc = "MC Skip Next Match" },
		{ "<leader>mS", mode = { "n", "x" }, desc = "MC Skip Prev Match" },
		{ "<leader>ma", mode = { "n", "x" }, desc = "MC Add Cursors All Matches" },
		{ "<leader>m/", mode = "n", desc = "MC Add Cursors All Search Results" },
		{ "<leader>m?", mode = "n", desc = "MC Add Cursor + Next Search Result" },
		{ "ga", mode = { "n", "x" }, desc = "MC Cursor Operator" },
		{ "<C-LeftMouse>", mode = "n", desc = "MC Mouse Add/Remove" },
	},
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		-- ── Place cursors ─────────────────────────────────────────────────
		-- Line-by-line: add a cursor on the line above/below and move there.
		vim.keymap.set({ "n", "x" }, "<C-Down>", function()
			mc.lineAddCursor(1)
		end, { desc = "MC Add Cursor Down" })
		vim.keymap.set({ "n", "x" }, "<C-Up>", function()
			mc.lineAddCursor(-1)
		end, { desc = "MC Add Cursor Up" })

		-- Skip a line without adding a cursor (useful when <C-Down/Up> is active).
		vim.keymap.set({ "n", "x" }, "<leader>mj", function()
			mc.lineSkipCursor(1)
		end, { desc = "MC Skip Line Down" })
		vim.keymap.set({ "n", "x" }, "<leader>mk", function()
			mc.lineSkipCursor(-1)
		end, { desc = "MC Skip Line Up" })

		-- Match-based: add cursor + jump to next/prev occurrence of word.
		vim.keymap.set({ "n", "x" }, "<leader>mn", function()
			mc.matchAddCursor(1)
		end, { desc = "MC Add Cursor Next Match" })
		vim.keymap.set({ "n", "x" }, "<leader>mN", function()
			mc.matchAddCursor(-1)
		end, { desc = "MC Add Cursor Prev Match" })

		-- Skip a match without adding a cursor.
		vim.keymap.set({ "n", "x" }, "<leader>ms", function()
			mc.matchSkipCursor(1)
		end, { desc = "MC Skip Next Match" })
		vim.keymap.set({ "n", "x" }, "<leader>mS", function()
			mc.matchSkipCursor(-1)
		end, { desc = "MC Skip Prev Match" })

		-- Add cursors at ALL occurrences of word/selection in buffer.
		vim.keymap.set({ "n", "x" }, "<leader>ma", function()
			mc.matchAllAddCursors()
		end, { desc = "MC Add Cursors All Matches" })

		-- Add cursor at each search result (works with / searches).
		vim.keymap.set("n", "<leader>m/", function()
			mc.searchAllAddCursors()
		end, { desc = "MC Add Cursors All Search Results" })
		vim.keymap.set("n", "<leader>m?", function()
			mc.searchAddCursor(1)
		end, { desc = "MC Add Cursor + Next Search Result" })

		-- Cursor operator: `gaip` = add cursor each line of paragraph.
		-- `gaiw` inside visual = add cursor each match of selection.
		vim.keymap.set({ "n", "x" }, "ga", mc.addCursorOperator, { desc = "MC Cursor Operator" })

		-- Mouse: Ctrl+Click to add/remove individual cursors.
		vim.keymap.set("n", "<C-LeftMouse>", mc.handleMouse, { desc = "MC Mouse Add/Remove" })
		vim.keymap.set("n", "<C-LeftDrag>", mc.handleMouseDrag, { desc = "MC Mouse Drag" })
		vim.keymap.set("n", "<C-LeftRelease>", mc.handleMouseRelease, { desc = "MC Mouse Release" })

		-- ── Keymap layer — only active when multiple cursors exist ─────────
		-- These mappings only activate while cursors are live, so they can
		-- safely overlap with single-cursor bindings.
		mc.addKeymapLayer(function(set)
			-- Navigate between cursors.
			set({ "n", "x" }, "<Left>", mc.prevCursor, { desc = "MC Prev Cursor" })
			set({ "n", "x" }, "<Right>", mc.nextCursor, { desc = "MC Next Cursor" })

			-- Delete the currently selected cursor.
			set({ "n", "x" }, "<leader>mx", mc.deleteCursor, { desc = "MC Delete Cursor" })

			-- <Esc>: if cursors are disabled re-enable them; otherwise clear all.
			set("n", "<Esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end, { desc = "MC Clear / Re-enable Cursors" })
		end)

		-- ── Highlights (Catppuccin Mocha palette) ─────────────────────────
		local colors = {
			blue = "#89b4fa",
			peach = "#fab387",
			surface0 = "#313244",
			overlay1 = "#7f849c",
		}
		vim.api.nvim_set_hl(0, "MultiCursorCursor", { reverse = true })
		vim.api.nvim_set_hl(0, "MultiCursorVisual", { bg = colors.surface0, fg = colors.blue })
		vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
		vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { bg = colors.surface0, fg = colors.peach })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { fg = colors.overlay1, reverse = true })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { bg = colors.surface0, fg = colors.overlay1 })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
