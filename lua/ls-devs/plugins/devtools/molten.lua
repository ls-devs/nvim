return {
	{
		"benlubas/molten-nvim",
		dependencies = {
			{ "3rd/image.nvim" },
			{
				"quarto-dev/quarto-nvim",
				ft = { "quarto" },
				dev = false,
				opts = {},
				dependencies = {
					"jmbuhr/otter.nvim",
				},
			},
			{
				"GCBallesteros/jupytext.nvim",
				lazy = false,
				opts = {
					custom_language_formatting = {
						python = {
							extension = "qmd",
							style = "quarto",
							force_ft = "quarto",
						},
						r = {
							extension = "qmd",
							style = "quarto",
							force_ft = "quarto",
						},
					},
				},
			},

			{
				"jpalardy/vim-slime",
				ft = { "quarto" },
				dev = false,
				init = function()
					vim.b["quarto_is_python_chunk"] = false
					Quarto_is_in_python_chunk = function()
						require("otter.tools.functions").is_otter_language_context("python")
					end

					vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]])

					vim.g.slime_target = "neovim"
					vim.g.slime_no_mappings = true
					vim.g.slime_python_ipython = 1
				end,
				config = function()
					vim.g.slime_input_pid = false
					vim.g.slime_suggest_default = true
					vim.g.slime_menu_config = false
					vim.g.slime_neovim_ignore_unlisted = true

					local function mark_terminal()
						local job_id = vim.b.terminal_job_id
						vim.print("job_id: " .. job_id)
					end

					local function set_terminal()
						vim.fn.call("slime#config", {})
					end
					vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
					vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
				end,
			},

			{
				"HakonHarnes/img-clip.nvim",
				event = "BufEnter",
				ft = { "markdown", "quarto", "latex" },
				opts = {
					default = {
						dir_path = "img",
					},
					filetypes = {
						markdown = {
							url_encode_path = true,
							template = "![$CURSOR]($FILE_PATH)",
							drag_and_drop = {
								download_images = false,
							},
						},
						quarto = {
							url_encode_path = true,
							template = "![$CURSOR]($FILE_PATH)",
							drag_and_drop = {
								download_images = false,
							},
						},
					},
				},
				config = function(_, opts)
					require("img-clip").setup(opts)
					vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
				end,
			},

			{
				"jbyuki/nabla.nvim",
				ft = { "quarto" },
				keys = {
					{ "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
				},
			},
		},
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
		end,
	},
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			max_width = 100,
			max_height = 12,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		},
		dependencies = {
			{
				"vhyrro/luarocks.nvim",
			},
		},
	},
}
