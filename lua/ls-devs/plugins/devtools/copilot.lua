return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		event = "LspAttach",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
			{
				"zbirenbaum/copilot.lua",
				event = "LspAttach",
				opts = {
					panel = {
						enabled = true,
						auto_refresh = true,
						keymap = {
							jump_prev = "[[",
							jump_next = "]]",
							accept = "<CR>",
							refresh = "gr",
							open = "<M-CR>",
						},
						layout = {
							position = "bottom",
							ratio = 0.4,
						},
					},
					suggestion = {
						enabled = true,
						auto_trigger = true,
						hide_during_completion = true,
						debounce = 75,
						keymap = {
							accept = "<M-l>",
							accept_word = false,
							accept_line = false,
							next = "<M-]>",
							prev = "<M-[>",
							dismiss = "<C-]>",
						},
					},
					filetypes = {
						yaml = false,
						markdown = false,
						help = false,
						gitcommit = false,
						gitrebase = false,
						hgcommit = false,
						svn = false,
						cvs = false,
						["."] = false,
					},
					logger = {
						file = vim.fn.stdpath("log") .. "/copilot-lua.log",
						file_log_level = vim.log.levels.OFF,
						print_log_level = vim.log.levels.WARN,
						trace_lsp = "off",
						trace_lsp_progress = false,
						log_lsp_messages = false,
					},
					copilot_node_command = "node",
					workspace_folders = {},
					root_dir = function()
						return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
					end,
					should_attach = function(_, _)
						if not vim.bo.buflisted then
							return false
						end

						if vim.bo.buftype ~= "" then
							return false
						end

						return true
					end,
					server = {
						type = "nodejs",
						custom_server_filepath = nil,
					},
					server_opts_overrides = {},
				},
			},
		},
		build = "make tiktoken",
		opts = {
			mappings = {
				complete = {
					insert = "<S-Tab>",
				},
			},

			model = "gpt-4.1",
			resources = "selection",
			diff = "block",
			language = "French",

			temperature = 0.1,
			headless = false,
			callback = nil,
			remember_as_sticky = true,

			window = {
				layout = "float",
				width = 90,
				height = 30,
				relative = "editor",
				border = "rounded",
				row = nil,
				col = nil,
				title = "Copilot Chat",
				footer = nil,
				zindex = 1,
				blend = 0,
			},

			show_help = false,
			show_folds = true,
			auto_fold = false,
			highlight_selection = true,
			highlight_headers = true,
			auto_follow_cursor = true,
			auto_insert_mode = true,
			insert_at_end = true,
			clear_chat_on_new_prompt = true,
			stop_on_function_failure = false,

			debug = false,
			log_level = "info",
			proxy = nil,
			allow_insecure = false,

			instruction_files = {
				".github/copilot-instructions.md",
				"AGENTS.md",
			},

			selection = "visual",
			chat_autocomplete = true,

			log_path = vim.fn.stdpath("state") .. "/CopilotChat.log",
			history_path = vim.fn.stdpath("data") .. "/copilotchat_history",

			headers = {
				user = "User",
				assistant = "Copilot",
				tool = "Tool",
			},

			separator = "───",
		},
	},
}
