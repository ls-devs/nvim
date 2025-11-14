return {
	"rasulomaroff/reactive.nvim",
	event = { "BufReadPost", "BufNewFile" },
	init = function()
		vim.cmd("hi link CursorLineFold CursorLineNr")
		vim.cmd("hi link CursorLineSign CursorLineNr")
	end,
	config = function(_, opts)
		require("reactive").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "TelescopePrompt",
			callback = function()
				vim.cmd("ReactiveStop")
			end,
		})

		vim.api.nvim_create_autocmd("BufLeave", {
			callback = function(ev)
				if vim.bo[ev.buf].filetype == "TelescopePrompt" then
					vim.defer_fn(function()
						local in_telescope = false
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_loaded(buf) then
								local ft = vim.bo[buf].filetype
								if ft == "TelescopePrompt" or ft == "TelescopeResults" then
									in_telescope = true
									break
								end
							end
						end

						if not in_telescope then
							vim.cmd("ReactiveStart")
						end
					end, 100)
				end
			end,
		})

		vim.api.nvim_create_autocmd("WinEnter", {
			callback = function()
				local ft = vim.bo.filetype
				if ft ~= "TelescopePrompt" and ft ~= "TelescopeResults" then
					vim.defer_fn(function()
						local in_telescope = false
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_loaded(buf) then
								local bufft = vim.bo[buf].filetype
								if bufft == "TelescopePrompt" or bufft == "TelescopeResults" then
									in_telescope = true
									break
								end
							end
						end

						if not in_telescope then
							pcall(function()
								vim.cmd("ReactiveStart")
							end)
						end
					end, 50)
				end
			end,
		})
	end,
	opts = {
		load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
		configs = {
			["catppuccin-mocha-cursor"] = {
				modes = {
					i = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					n = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					no = {
						operators = {
							d = {
								hl = {
									ReactiveCursor = { bg = "none" },
								},
							},
							y = {
								hl = {
									ReactiveCursor = { bg = "none" },
								},
							},
							c = {
								hl = {
									ReactiveCursor = { bg = "none" },
								},
							},
						},
					},
					R = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					v = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					V = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					["\x16"] = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					s = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					S = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
					["\x13"] = {
						hl = {
							ReactiveCursor = { bg = "none" },
						},
					},
				},
			},
		},
	},
}
