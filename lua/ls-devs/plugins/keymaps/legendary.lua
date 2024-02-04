return {
	"mrjones2014/legendary.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "kkharji/sqlite.lua" },
		{
			"mrjones2014/smart-splits.nvim",
			event = "VeryLazy",
			build = "./kitty/install-kittens.bash",
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
					"<leader>p",
					function()
						local winid = require("ufo").peekFoldedLinesUnderCursor()
						if not winid then
							vim.lsp.buf.hover()
						end
					end,
					description = "UFO Peek Under Cursor",
					opts = { noremap = true, silent = true },
				},
				{
					"<C-s>",
					function()
						return vim.lsp.buf.signature_help()
					end,
					description = "LSP Signature Help",
					opts = { noremap = true, silent = true },
				},
				{
					"gh",
					"<cmd>Lspsaga finder<CR>",
					description = "LSPSaga Finder",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>ca",
					{
						n = function()
							if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
								return require("lspsaga.codeaction"):code_action()
							end
						end,

						v = function()
							if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
								return require("lspsaga.codeaction"):code_action()
							end
						end,
					},
					description = "LSPSaga Code Actions",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>rn",
					"<cmd>Lspsaga rename<CR>",
					description = "LSPSaga Rename",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>rnw",
					"<cmd>Lspsaga rename ++project<CR>",
					description = "LSPSaga Rename Workspace",
					opts = { noremap = true, silent = true },
				},
				{
					"gp",
					"<cmd>Lspsaga peek_definition<CR>",
					description = "LSPSaga Peek Definition",
					opts = { noremap = true, silent = true },
				},
				{
					"gD",
					"<cmd>lua vim.lsp.buf.declaration()<CR>",
					description = "LSP Buf Declaration",
					opts = { noremap = true, silent = true },
				},
				{
					"gd",
					"<cmd>Lspsaga goto_definition<CR>",
					description = "LSPSaga Goto Definition",
					opts = { noremap = true, silent = true },
				},
				{
					"td",
					"<cmd>Lspsaga peek_type_definition<CR>",
					description = "LSPSaga Peek Type Definition",
					opts = { noremap = true, silent = true },
				},
				{
					"gt",
					"<cmd>Lspsaga goto_type_definition<CR>",
					description = "LSPSaga Goto Type Defintion",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>fm",
					mode = { "n", "v" },
					function()
						vim.lsp.buf.format({ timeout_ms = 5000 })
					end,
					description = "LSP Buf Format",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>cl",
					"<cmd>Lspsaga show_line_diagnostics<CR>",
					description = "LSPSaga Show Line Diagnostics",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>cb",
					"<cmd>Lspsaga show_buf_diagnostics<CR>",
					description = "LSPSaga Show Buf Diagnostics",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>cw",
					"<cmd>Lspsaga show_workspace_diagnostics<CR>",
					description = "LSPSaga Show Workspace Diagnostics",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>cc",
					"<cmd>Lspsaga show_cursor_diagnostics<CR>",
					description = "LSPSaga Show Cursor Diagnostics",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>dp",
					function()
						if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
							return require("lspsaga.diagnostic"):goto_prev()
						end
					end,
					description = "LSPSaga Diagnostic Jump Prev",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>dn",
					function()
						if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
							return require("lspsaga.diagnostic"):goto_next()
						end
					end,
					description = "LSPSaga Diagnostic Jump Next",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>lo",
					"<cmd>Lspsaga outline<CR>",
					description = "LSPSaga Outline",
					opts = { noremap = true, silent = true },
				},
				{
					"K",
					require("ls-devs.utils.custom_functions").CustomHover,
					description = "LSP Hover Doc",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>K",
					"<cmd>Lspsaga hover_doc ++keep<CR>",
					description = "LSPSaga Hover Doc Keep",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>ci",
					"<cmd>Lspsaga incoming_calls<CR>",
					description = "LSPSaga Incoming Calls",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>co",
					"<cmd>Lspsaga outgoing_calls<CR>",
					description = "LSPSaga Outgoing Calls",
					opts = { noremap = true, silent = true },
				},
				{
					"<c-f>",
					function()
						if not require("noice.lsp").scroll(4) then
							return "<c-f>"
						end
					end,
					mode = { "n", "i", "s" },
					description = "Noice Scroll Hover Doc Forward",
					opts = { noremap = true, silent = true },
				},
				{
					"<c-b>",
					function()
						if not require("noice.lsp").scroll(-4) then
							return "<c-b>"
						end
					end,
					mode = { "n", "i", "s" },
					description = "Noice Scroll Hover Doc Backward",
					opts = { noremap = true, silent = true },
				},
				{
					"<S-Enter>",
					function()
						require("noice").redirect(vim.fn.getcmdline())
					end,
					mode = { "c" },
					description = "Redirect Cmdline",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>l",
					"<cmd>Lazy<CR>",
					description = "Lazy",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>ls",
					"<cmd>Lazy sync<CR>",
					description = "Lazy Sync",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>li",
					"<cmd>Lazy install<CR>",
					description = "Lazy Install",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>lu",
					"<cmd>Lazy update<CR>",
					description = "Lazy Update",
					opts = { noremap = true, silent = true },
				},
				{
					"<leader>lc",
					"<cmd>Lazy build<CR>",
					description = "Lazy Build",
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
						swap = false,
					},
				},
				diffview = true,
			},
			autocmds = {
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
				-- {
				--   "LspAttach",
				--   'lua require("null-ls").enable({})',
				--   description = "Start null-ls when starting a lsp client",
				-- },
				{
					{ "BufNewFile", "BufRead" },
					":silent set filetype=glsl",
					description = "Set filetype to glsl",
					opts = {
						pattern = { "*.vert", "*.frag" },
					},
				},
				{
					{ "InsertEnter", "InsertChange" },
					'lua require("notify").dismiss({ silent = true })',
					pattern = "*",
					description = "Notify dismiss",
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
