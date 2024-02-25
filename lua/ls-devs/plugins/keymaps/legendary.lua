return {
	"mrjones2014/legendary.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "kkharji/sqlite.lua", lazy = true },
		{
			"mrjones2014/smart-splits.nvim",
			lazy = true,
			opts = {
				resize_mode = {
					silent = true,
					hooks = {
						on_enter = function()
							vim.notify("Entering resize mode")
						end,
						on_leave = function()
							vim.notify("Exiting resize mode, bye")
						end,
					},
				},
			},
		},
	},
	config = function()
		require("legendary").setup({
			keymaps = {
				{
					"<leader>LL",
					"<cmd>Legendary<CR>",
					description = "Legendary",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>LK",
					"<cmd>Legendary keymaps<CR>",
					description = "Legendary keymaps",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>LC",
					"<cmd>Legendary commands<CR>",
					description = "Legendary commands",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>LA",
					"<cmd>Legendary autocmds<CR>",
					description = "Legendary autocmds",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>LF",
					"<cmd>Legendary functions<CR>",
					description = "Legendary functions",
					opts = { noremap = true, silent = true },
				},
				{
					"<C-d>",
					"<C-d>zz",
					description = "Navigate Down & Center",
					opts = { noremap = true, silent = true },
				},
				{
					"<C-u>",
					"<C-u>zz",
					description = "Navigate Up & Center",
					opts = { noremap = true, silent = true },
				},
				{
					"<C-i>",
					"<C-i>zz",
					opts = { noremap = true, silent = true },
				},
				{
					"<C-o>",
					"<C-o>zz",
					opts = { noremap = true, silent = true },
				},
				{
					"{",
					"{zz",
					opts = { noremap = true, silent = true },
				},
				{
					"}",
					"}zz",
					opts = { noremap = true, silent = true },
				},
				{
					"}",
					"}zz",
					opts = { noremap = true, silent = true },
				},
				{
					"N",
					"Nzz",
					opts = { noremap = true, silent = true },
				},
				{
					"n",
					"nzz",
					opts = { noremap = true, silent = true },
				},
				{
					"G",
					"Gzz",
					opts = { noremap = true, silent = true },
				},
				{
					"gg",
					"ggzz",
					opts = { noremap = true, silent = true },
				},
				{
					"%",
					"%zz",
					opts = { noremap = true, silent = true },
				},
				{
					"*",
					"*zz",
					opts = { noremap = true, silent = true },
				},
				{
					"#",
					"#zz",
					description = "Navigate Up & Center",
					opts = { noremap = true, silent = true },
				},
				{
					"<A-j>",
					{ v = "<cmd>m .+1<CR>==", x = "<cmd>move '>+1<CR>gv-gv" },
					description = "Switch Lines Down",
					opts = { noremap = true, silent = true },
				},
				{
					"<A-k>",
					{ v = "<cmd>m .-2<CR>==", x = "<cmd>move '<-2<CR>gv-gv" },
					description = "Switch Lines Up",
					opts = { noremap = true, silent = true },
				},
				{
					"p",
					{ v = '"_dP' },
					description = "Paste Text",
					opts = { noremap = true, silent = true },
				},
				{ "J", { x = ":move '>+1<CR>gv-gv" }, opts = { noremap = true, silent = true } },
				{ "K", { x = ":move '<-2<CR>gv-gv" }, opts = { noremap = true, silent = true } },
				{
					"<",
					{ v = "<gv" },
					opts = { noremap = true, silent = true },
				},
				{
					">",
					{ v = ">gv" },
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>nh",
					function()
						vim.cmd.noh()
					end,
					description = "Remove Highlight Search",
				},
				{
					"<leader>hg",
					require("ls-devs.utils.custom_functions").HelpGrep,
					description = "Help Grep",
					opts = { noremap = true, silent = true },
				},
				{
					"zR",
					function()
						require("ufo").openAllFolds()
					end,
					description = "UFO Open All Folds",
					opts = { noremap = true, silent = true },
				},
				{
					"zM",
					function()
						require("ufo").closeAllFolds()
					end,
					description = "UFO Close All Folds",
					opts = { noremap = true, silent = true },
				},
				{
					"<C-s>",
					mode = { "i", "n" },
					function()
						vim.lsp.buf.signature_help()
						require("cmp").close()
					end,
					description = "LSP Signature Help",
					opts = { noremap = true, silent = true },
				},
				{
					"<C-f>",
					function()
						if not require("noice.lsp").scroll(4) then
							return "<C-f>"
						end
					end,
					mode = { "n", "i", "s" },
					description = "Noice Scroll Hover Doc Forward",
					opts = { silent = true, expr = true },
				},
				{
					"<C-b>",
					function()
						if not require("noice.lsp").scroll(-4) then
							return "<C-b>"
						end
					end,
					mode = { "n", "i", "s" },
					description = "Noice Scroll Hover Doc Backward",
					opts = { silent = true, expr = true },
				},
				{
					"<A-x>",
					function()
						return require("noice").redirect(vim.fn.getcmdline())
					end,
					mode = "c",
					description = "Redirect Cmdline",
				},
				{
					"<leader>lz",
					"<cmd>Lazy<CR>",
					description = "Lazy",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>lg",
					require("ls-devs.utils.custom_functions").LazyGit,
					description = "LazyGit",
					opts = { noremap = true, silent = true },
				},
			},
			extensions = {
				lazy_nvim = { auto_register = true },
				nvim_tree = true,
				op_nvim = true,
				smart_splits = {
					directions = { "h", "j", "k", "l" },
					mods = {
						move = "<C>",
						resize = "<M>",
						swap = {
							mod = "<C>",
							prefix = "<leader>",
						},
					},
				},
				diffview = true,
			},
			autocmds = {
				{
					{ "InsertEnter", "InsertChange" },
					'lua require("notify").dismiss({ silent = true })',
					pattern = "*",
					description = "Notify dismiss",
				},
				{
					"VimLeave",
					":silent !prettierd stop",
					description = "Stop prettierd",
					opts = {
						pattern = {
							"*.jsx",
							"*.tsx",
							"*.vue",
							"*.js",
							"*.ts",
							"*.css",
							"*.scss",
							"*.less",
							"*.html",
							"*.json",
							"*.jsonc",
							"*.yaml",
							"*.md",
							"*.mdx",
							"*.graphql",
						},
					},
				},
				{
					"LspAttach",
					function(args)
						local bufnr = args.buf
						local client = vim.lsp.get_client_by_id(args.data.client_id)

						if client == nil or client.name ~= "emmet_language_server" then
							return
						end

						vim.keymap.set("n", "<leader>xe", function()
							require("nvim-emmet").wrap_with_abbreviation()
						end, { buffer = bufnr, desc = "Wrap with abbreviation" })
					end,
					description = "Setup nvim-emmet",
					opts = {
						pattern = {
							"*.jsx",
							"*.tsx",
							"*.vue",
							"*.html",
						},
					},
				},
				{
					"WinEnter",
					function()
						local ignore_buftypes = { "nofile", "prompt", "popup" }
						if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
							vim.b.focus_disable = true
						else
							vim.b.focus_disable = false
						end
					end,
					description = "Disable focus autoresize for BufType",
				},
				{
					"FileType",
					function()
						local ignore_filetypes = {
							"neo-tree",
							"dap-repl",
							"SidebarNvim",
							"Trouble",
							"terminal",
							"dapui_console",
							"dapui_watches",
							"dapui_stacks",
							"dapui_breakpoints",
							"dapui_scopes",
							"OverseerList",
							"noice",
						}
						if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
							vim.b.focus_disable = true
						else
							vim.b.focus_disable = false
						end
					end,
					description = "Disable focus autoresize for FileType",
				},
				{
					"TextYankPost",
					function()
						vim.highlight.on_yank({ timeout = 100, visual = true })
					end,
					opts = {
						pattern = "*",
					},
				},
				{
					"VimResized",
					function()
						vim.cmd("wincmd =")
					end,
					opts = {
						pattern = "*",
					},
				},
				{
					"FileType",
					function()
						vim.bo.bufhidden = "unload"
						vim.cmd.wincmd("L")
						vim.cmd.wincmd("=")
					end,
					opts = {
						pattern = "help",
					},
				},
			},
			sort = {
				most_recent_first = true,
				user_items_first = true,
				item_type_bias = nil,
				frecency = {
					db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
					max_timestamps = 10,
				},
			},
		})
	end,
}
