-- ── reactive.nvim ────────────────────────────────────────────────────────────
-- Purpose : Mode-reactive cursor and cursorline highlight colors using
--           built-in catppuccin-mocha presets.
-- Trigger : BufReadPost, BufNewFile
-- Note    : init links CursorLineFold and CursorLineSign to CursorLineNr so
--           the gutter looks visually uniform across all status columns.
-- ─────────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"rasulomaroff/reactive.nvim",
	event = { "BufReadPost", "BufNewFile" },
	init = function()
		-- Align fold/sign column highlights with the line-number column on the cursor line.
		vim.api.nvim_set_hl(0, "CursorLineFold", { link = "CursorLineNr" })
		vim.api.nvim_set_hl(0, "CursorLineSign", { link = "CursorLineNr" })
	end,
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("reactive").setup(opts)
		-- reactive.nvim moves the cursor left on the first keystroke in prompt buffers
		-- (same issue that affected TelescopePrompt). Stop it for any snacks picker input
		-- and resume it when the picker closes.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "snacks_picker_input", "TelescopePrompt" },
			callback = function()
				vim.cmd("ReactiveStop")
			end,
		})
		vim.api.nvim_create_autocmd("BufLeave", {
			---@param ev vim.api.keyset.create_autocmd.callback_args
			callback = function(ev)
				local ft = vim.bo[ev.buf].filetype
				if ft == "snacks_picker_input" or ft == "TelescopePrompt" then
					vim.defer_fn(function()
						local still_open = false
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_loaded(buf) then
								local bft = vim.bo[buf].filetype
								if bft == "snacks_picker_input" or bft == "TelescopePrompt" then
									still_open = true
									break
								end
							end
						end
						if not still_open then
							vim.cmd("ReactiveStart")
						end
					end, 100)
				end
			end,
		})
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
