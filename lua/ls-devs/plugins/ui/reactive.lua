return {
	"rasulomaroff/reactive.nvim",
	event = { "BufReadPost", "BufNewFile" },
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
