return {
	"nvim-lualine/lualine.nvim",
	event = "BufReadPost",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		local lualine = require("lualine")
		local c = require("catppuccin.palettes.mocha")

		local colors = {
			bg = c.base,
			fg = c.overlay0,
			yellow = c.yellow,
			cyan = c.blue,
			darkblue = c.lavender,
			green = c.green,
			orange = c.flamingo,
			violet = c.mauve,
			magenta = c.mauve,
			blue = c.blue,
			red = c.red,
		}

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		local config = {
			extensions = {
				"lazy",
				"neo-tree",
				"nvim-dap-ui",
				"trouble",
				"overseer",
				"quickfix",
				"aerial",
				"man",
			},
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = "catppuccin",

				-- normal = { c = { fg = colors.fg, bg = nil } },
				-- inactive = { c = { fg = colors.fg, bg = colors.bg } },
				disabled_filetypes = { "NvimTree", "alpha" },
			},
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

		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left({
			function()
				return " "
			end,
			color = function()
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[""] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { right = 1 },
		})

		ins_left({
			"filesize",
			cond = conditions.buffer_not_empty,
			color = { fg = c.text },
		})

		ins_left({ "location", color = { fg = c.text, gui = "bold" } })

		ins_left({ "progress", color = { fg = c.text, gui = "bold" } })

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			diagnostics_color = {
				error = { fg = colors.red, gui = "bold" },
				warn = { fg = colors.yellow, gui = "bold" },
				info = { fg = colors.white, gui = "bold" },
				hint = { fg = colors.cyan, gui = "bold" },
			},
			colored = true,
		})

		ins_left({
			function()
				local lsps = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
				local icon = require("nvim-web-devicons").get_icon_by_filetype(
					vim.api.nvim_get_option_value("filetype", { buf = 0 })
				)
				if lsps and #lsps > 0 then
					local names = {}
					for _, lsp in ipairs(lsps) do
						table.insert(names, lsp.name)
					end
					return string.format("%s %s", names[#names], icon)
				else
					return icon or ""
				end
			end,
			color = { fg = c.blue, gui = "bold" },
		})

		ins_left({
			function()
				return require("lazy.status").updates()
			end,
			cond = require("lazy.status").has_updates,
			color = { fg = colors.orange },
		})

		ins_right({
			function()
				return require("NeoComposer.ui").status_recording()
			end,
			padding = { left = 0, right = 0 },
		})

		ins_right({
			function()
				return os.date("%H:%M:%S", os.time())
			end,
			color = {
				fg = colors.blue,
				gui = "bold",
			},
		})

		ins_right({
			"o:encoding",
			fmt = string.upper,
			cond = conditions.hide_in_width,
			color = { fg = colors.green, gui = "bold" },
		})

		ins_right({
			"fileformat",
			fmt = string.upper,
			icons_enabled = false,
			color = { fg = colors.green, gui = "bold" },
		})

		ins_right({
			fmt = function(str)
				if string.len(str) >= 20 then
					return string.sub(str, 0, 17) .. "..."
				else
					return str
				end
			end,
			"branch",
			icon = "",
			color = { fg = colors.violet, gui = "bold" },
		})

		ins_right({
			"diff",
			symbols = { added = " ", modified = " ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})

		lualine.setup(config)
	end,
}
