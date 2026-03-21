-- ── reactive.nvim ────────────────────────────────────────────────────────────
-- Purpose : Mode-reactive cursor and cursorline highlight colors using
--           built-in catppuccin-mocha presets.
-- Trigger : BufReadPost, BufNewFile
-- Note    : init links CursorLineFold and CursorLineSign to CursorLineNr so
--           the gutter looks visually uniform across all status columns.
-- ─────────────────────────────────────────────────────────────────────────────
return {
	"rasulomaroff/reactive.nvim",
	event = { "BufReadPost", "BufNewFile" },
	init = function()
		-- Align fold/sign column highlights with the line-number column on the cursor line.
		vim.cmd("hi link CursorLineFold CursorLineNr")
		vim.cmd("hi link CursorLineSign CursorLineNr")
	end,
	opts = {
		-- Built-in catppuccin-mocha presets for cursor shape and cursorline tint.
		load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
		-- Override: clear the cursor background added by the preset so the terminal
		-- cursor shape drives the visual indicator instead of a colored highlight block.
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
					-- \x16 = <C-v> (block-visual mode)
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
					-- \x13 = <C-s> (block-select mode)
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
