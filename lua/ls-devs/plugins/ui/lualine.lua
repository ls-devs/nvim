return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	config = function()
		local lualine = require("lualine")
		local colors = require("catppuccin.palettes.mocha")

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
			options = {
				component_separators = "",
				section_separators = "",
				theme = {
					normal = {
						a = { bg = colors.blue, fg = colors.mantle, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.blue },
						c = { bg = nil, fg = colors.text },
					},

					insert = {
						a = { bg = colors.green, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.green },
					},

					terminal = {
						a = { bg = colors.green, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.green },
					},

					command = {
						a = { bg = colors.blue, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.peach },
					},

					visual = {
						a = { bg = colors.mauve, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.mauve },
					},

					replace = {
						a = { bg = colors.red, fg = colors.base, gui = "bold" },
						b = { bg = colors.surface0, fg = colors.red },
					},

					inactive = {
						a = { bg = nil, fg = colors.blue },
						b = { bg = nil, fg = colors.surface1, gui = "bold" },
						c = { bg = nil, fg = colors.overlay0 },
					},
				},

				disabled_filetypes = { "alpha" },
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
					v = colors.teal,
					[""] = colors.blue,
					V = colors.sapphire,
					c = colors.flamingo,
					no = colors.red,
					s = colors.peach,
					S = colors.peach,
					ic = colors.yellow,
					R = colors.mauve,
					Rv = colors.mauve,
					cv = colors.red,
					ce = colors.red,
					r = colors.sapphire,
					rm = colors.sapphire,
					["r?"] = colors.sapphire,
					["!"] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { left = 1, right = 2 },
		})

		ins_left({
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

		ins_left({
			function()
				return require("lazy.status").updates()
			end,
			cond = require("lazy.status").has_updates,
			color = { fg = colors.peach },
		})

		ins_right({
			function()
				return require("NeoComposer.ui").status_recording()
			end,
			padding = { left = 0, right = 1 },
		})

		ins_right({
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
							return lsp.name
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

		ins_right({
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
				info = { fg = colors.saphire, gui = "bold" },
				hint = { fg = colors.teal, gui = "bold" },
			},
			colored = true,
			cond = function()
				return vim.bo.filetype ~= "lazy"
			end,
		})

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

		ins_right({
			function()
				return os.date("%H:%M:%S", os.time())
			end,
			color = {
				fg = colors.blue,
				gui = "bold",
			},
			padding = { left = 1, right = 0 },
		})

		lualine.setup(config)
	end,
}
