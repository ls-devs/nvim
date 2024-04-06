return {
	"rasulomaroff/reactive.nvim",
	event = "VeryLazy",
	init = function()
		vim.cmd("hi link CursorLineFold CursorLineNr")
		vim.cmd("hi link CursorLineSign CursorLineNr")
	end,
	opts = {
		load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
		configs = {
			["catppuccin-mocha-cursor"] = {
				modes = {
					i = {
						hl = {
							ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
						},
					},
					n = {
						hl = {
							ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
						},
					},

					no = {
						operators = {
							d = {
								hl = {
									ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
								},
							},
							y = {
								hl = {
									ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
								},
							},
							c = {
								hl = {
									ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
								},
							},
						},
					},
					R = {
						hl = {
							ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
						},
					},
					-- visual
					[{ "v", "V", "\x16" }] = {
						hl = {
							ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
						},
					},
					-- select
					[{ "s", "S", "\x13" }] = {
						hl = {
							ReactiveCursor = { bg = "none", fg = "#1e1e2e", blend = 0 },
						},
					},
				},
			},
		},
	},
}
