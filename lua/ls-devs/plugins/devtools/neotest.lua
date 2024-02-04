return {
	"nvim-neotest/neotest",
	config = function()
		require("neotest").setup({
			output = {
				enabled = true,
				open_on_run = true,
			},
			output_panel = {
				enabled = true,
				open = "botright split | resize 15",
			},
			library = { plugins = { "neotest" }, types = true },
			consumers = {
				playwright = require("neotest-playwright.consumers").consumers,
			},
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = function()
						local file = vim.fn.expand("%:p")
						if string.find(file, "/packages/") then
							return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
						end

						return vim.fn.getcwd() .. "/jest.config.ts"
					end,
					jest_test_discovery = false,
					env = { CI = true },
					cwd = function()
						local file = vim.fn.expand("%:p")
						if string.find(file, "/packages/") then
							return string.match(file, "(.-/[^/]+/)src")
						end
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-vitest"),
				require("neotest-playwright").adapter({
					options = {
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
					},
				}),
				require("neotest-vim-test"),
			},
			discovery = {
				enabled = false,
			},
		})
	end,
	keys = {
		{
			"<leader>nr",
			function()
				require("neotest").run.run()
			end,
			desc = "NeoTest Run",
			silent = true,
			noremap = true,
		},
		{
			"<leader>nc",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "NeoTest Run Current File",
			silent = true,
			noremap = true,
		},
		{
			"<leader>nd",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "NeoTest Debug Nearest Test",
			silent = true,
			noremap = true,
		},
		{
			"<leader>nq",
			function()
				require("neotest").run.stop()
			end,
			desc = "NeoTest Stop",
			silent = true,
			noremap = true,
		},
		{
			"<leader>na",
			function()
				require("neotest").run.attach()
			end,
			desc = "NeoTest Attach Nearest Test",
			silent = true,
			noremap = true,
		},
		{
			"<leader>ns",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "NeoTest Summary Toggle",
			silent = true,
			noremap = true,
		},
		{
			"<leader>no",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "NeoTest Output Open",
			silent = true,
			noremap = true,
		},
		{
			"<leader>np",
			function()
				require("neotest").output_panel.open()
			end,
			desc = "NeoTest Panel Open",
			silent = true,
			noremap = true,
		},
		{
			"<leader>sn",
			require("ls-devs.utils.custom_functions").NeotestSetupProject,
			desc = "Neotest Setup Project",
			silent = true,
			noremap = true,
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
		"thenbe/neotest-playwright",
		{
			"nvim-neotest/neotest-vim-test",
			dependencies = {
				"vim-test/vim-test",
			},
		},
		{
			"folke/neodev.nvim",
			opts = {
				{
					library = {
						enabled = true,
						runtime = true,
						types = true,
						plugins = true,
					},
					setup_jsonls = true,
					override = function(root_dir, options) end,
					lspconfig = true,
					pathStrict = true,
				},
			},
		},
	},
}
