-- ── lualine ──────────────────────────────────────────────────────────────────
-- Purpose : Custom status line; all content placed in lualine_c (left) and
--           lualine_x (right). Sections A, B, Y, Z are intentionally empty.
-- Trigger : BufReadPost / BufNewFile (direct file open) or
--           User SnacksDashboardClosed (after dashboard exits).
-- Note    : Colors sourced from catppuccin-mocha palette at config time.
-- ─────────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPost", "BufNewFile", "User SnacksDashboardClosed" },
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	config = function()
		local lualine = require("lualine")
		local colors = require("catppuccin.palettes.mocha")

		-- Visibility guards used as `cond` predicates on individual components.
		local conditions = {
			---@return boolean
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			---@return boolean
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			---@return boolean
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- ── Theme ────────────────────────────────────────────────────────────────────
		-- Mode-specific segment colors: section A (active pill) + B (breadcrumb band).
		local config = {
			options = {
				globalstatus = true, -- single statusline at Neovim bottom, not per-window
				component_separators = "",
				section_separators = "",
				theme = {
					-- Colors mirror reactive.nvim catppuccin-mocha-cursor preset:
					-- n=yellow, i=teal, v/V/^V=mauve, R=sapphire, c=blue
					normal = {
						a = { bg = colors.yellow, fg = colors.mantle, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.yellow },
						c = { bg = nil, fg = colors.text },
					},

					insert = {
						a = { bg = colors.teal, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.teal },
					},

					terminal = {
						a = { bg = colors.teal, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.teal },
					},

					command = {
						a = { bg = colors.blue, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.blue },
					},

					visual = {
						a = { bg = colors.mauve, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.mauve },
					},

					replace = {
						a = { bg = colors.sapphire, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.sapphire },
					},

					inactive = {
						a = { bg = nil, fg = colors.blue },
						b = { bg = nil, fg = colors.surface1, gui = "bold" },
						c = { bg = nil, fg = colors.overlay0 },
					},
				},

				disabled_filetypes = {
					statusline = { "snacks_dashboard" },
					winbar = {},
				},
			},
			-- All standard sections cleared; content injected via ins_left/ins_right helpers.
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- ── Layout helpers ────────────────────────────────────────────────────────────
		-- Appends a component to the left (lualine_c) or right (lualine_x) side.
		---@param component table
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		---@param component table
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		-- ── Left section ─────────────────────────────────────────────────────────────
		-- ● Mode indicator: color-coded dot, changes color per vim mode.
		ins_left({
			---@return string
			function()
				return " "
			end,
			---@return {fg: string}
			color = function()
				-- Dot mirrors reactive.nvim catppuccin-mocha-cursor colors.
				-- Operator-pending (no) is further split by vim.v.operator so
				-- delete/yank/change each get their reactive color.
				local mode_color = {
					n = colors.yellow, -- normal
					i = colors.teal, -- insert
					v = colors.mauve, -- visual char
					["\x16"] = colors.mauve, -- visual block
					V = colors.mauve, -- visual line
					c = colors.blue, -- command
					s = colors.pink, -- select
					S = colors.pink, -- select line
					["\x13"] = colors.pink, -- select block
					ic = colors.teal, -- insert completion
					R = colors.sapphire, -- replace
					Rv = colors.sapphire, -- virtual replace
					cv = colors.blue, -- ex mode
					ce = colors.blue, -- normal ex
					r = colors.sapphire, -- prompt
					rm = colors.sapphire, -- more prompt
					["r?"] = colors.sapphire, -- confirm
					["!"] = colors.peach, -- shell
					t = colors.teal, -- terminal
				}
				local mode = vim.fn.mode()
				if mode == "no" then
					-- Differentiate operators to match reactive cursor colors:
					-- d=red, y=peach, c=blue, everything else=red
					local op_color = { d = colors.red, y = colors.peach, c = colors.blue }
					return { fg = op_color[vim.v.operator] or colors.red }
				end
				return { fg = mode_color[mode] or colors.yellow }
			end,
			padding = { left = 1, right = 2 },
		})

		-- Git branch name (truncated to 25 chars to avoid overflow).
		ins_left({
			---@param str string
			---@return string
			fmt = function(str)
				if string.len(str) >= 25 then
					return string.sub(str, 0, 22) .. "..."
				else
					return str
				end
			end,
			"branch",
			icon = "󰘬",
			color = { fg = colors.mauve, gui = "bold" },
		})

		ins_left({
			"filetype",
			colored = true,
			icon = { align = "left" },
			padding = { left = 0, right = 1 },
		})

		-- Git diff stats (added/modified/removed); hidden on narrow windows (<80 cols).
		ins_left({
			"diff",
			symbols = { added = " ", modified = " ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.peach },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})

		-- Pending plugin update count from lazy.nvim; hidden when up-to-date.
		ins_left({
			---@return string
			function()
				return require("lazy.status").updates()
			end,
			cond = require("lazy.status").has_updates,
			color = { fg = colors.peach },
		})

		-- ── Right section ────────────────────────────────────────────────────────────
		-- Active NeoComposer macro recording indicator (empty when not recording).
		ins_right({
			---@return string
			function()
				return require("NeoComposer.ui").status_recording()
			end,
			padding = { left = 0, right = 1 },
		})

		-- Active LSP name: prefers a server whose name matches the filetype;
		-- falls back to the last attached client. Truncated at 17 chars.
		ins_right({
			---@return string
			function()
				local lsps = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
				if lsps and #lsps > 0 then
					for _, lsp in ipairs(lsps) do
						if string.find(lsp.name, vim.bo.filetype) then
							if string.len(lsp.name) >= 17 then
								return string.sub(lsp.name, 0, 14) .. "..."
							else
								return lsp.name
							end
						else
							if string.len(lsps[#lsps].name) >= 17 then
								return string.sub(lsps[#lsps].name, 0, 14) .. "..."
							else
								return lsps[#lsps].name
							end
						end
					end
				else
					return ""
				end
			end,
			color = { fg = colors.flamingo, gui = "bold" },
			icon = " ",
		})

		-- Active linter name from nvim-lint for the current filetype (first entry only).
		ins_right({
			---@return string
			function()
				local linter = require("lint").linters_by_ft[vim.bo.filetype]
				if linter then
					return linter[1]
				else
					return ""
				end
			end,
			color = { fg = colors.flamingo, gui = "bold" },
			padding = { left = 1, right = 0 },
			icon = "",
		})

		ins_right({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			diagnostics_color = {
				error = { fg = colors.red, gui = "bold" },
				warn = { fg = colors.yellow, gui = "bold" },
				info = { fg = colors.sapphire, gui = "bold" },
				hint = { fg = colors.teal, gui = "bold" },
			},
			colored = true,
			---@return boolean
			cond = function()
				return vim.bo.filetype ~= "lazy"
			end,
		})

		-- Noice search count (X/Y); always visible in statusline so smooth scroll
		-- doesn't cause it to disappear when the cursor scrolls off-screen.
		ins_right({
			---@return string
			function()
				return require("noice").api.status.search.get()
			end,
			---@return boolean
			cond = function()
				local ok, noice = pcall(require, "noice")
				return ok and noice.api.status.search.has()
			end,
			color = { fg = colors.yellow, gui = "bold" },
			icon = " ",
		})

		-- Cursor position (line:col) and scroll percentage through the file.
		ins_right({ "location", color = { fg = colors.text, gui = "bold" } })
		ins_right({ "progress", color = { fg = colors.text, gui = "bold" } })

		ins_right({
			"encoding",
			cond = conditions.hide_in_width,
			color = { fg = colors.green, gui = "bold" },
		})

		ins_right({
			"fileformat",
			icons_enabled = false,
			color = { fg = colors.green, gui = "bold" },
		})

		-- Live clock (HH:MM:SS); hidden on narrow windows (<80 cols).
		ins_right({
			---@return string
			function()
				return os.date("%H:%M:%S", os.time())
			end,
			color = {
				fg = colors.blue,
				gui = "bold",
			},
			padding = { left = 1, right = 0 },
			cond = conditions.hide_in_width,
		})

		lualine.setup(config)
	end,
}
