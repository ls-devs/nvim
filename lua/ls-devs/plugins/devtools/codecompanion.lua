local function get_selected_lines(context)
	local bufnr = context.bufnr or 0
	local start_line = (context.start_line and context.start_line - 1) or 0
	local end_line = context.end_line or -1
	return vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
end

local function make_code_prompt(context, instruction)
	local filetype = context.filetype or "text"
	local lines = get_selected_lines(context)
	local text = table.concat(lines, "\n")

	text = text:gsub("```", "````")
	return string.format("%s %s :\n\n```%s\n%s\n```", instruction, filetype, filetype, text)
end

return {
	"olimorris/codecompanion.nvim",
	cmd = { "CodeCompanionChat", "CodeCompanionActions" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ravitemer/mcphub.nvim",
		{
			"HakonHarnes/img-clip.nvim",
			opts = {
				filetypes = {
					codecompanion = {
						prompt_for_file_name = false,
						template = "[Image]($FILE_PATH)",
						use_absolute_path = true,
					},
				},
			},
		},
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
					local git_dir = vim.fs.find(".git", { upward = true })[1]
					if git_dir then
						return vim.fs.dirname(git_dir)
					else
						return vim.loop.cwd()
					end
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
		"cairijun/codecompanion-agentskills.nvim",
	},
	opts = {
		interactions = {
			chat = {
				tools = {
					["web_search"] = {
						adapter = {
							name = "tavily",
							env = {
								TAVILY_API_KEY = "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",
							},
						},
					},
				},

				adapter = {
					name = "copilot",
					model = "gpt-4.1",
				},
			},
			inline = {
				adapter = {
					name = "copilot",
					model = "gpt-4.1-mini",
				},
			},
			cmd = {
				adapter = {
					name = "copilot",
					model = "gpt-4.1-mini",
				},
			},
		},
		rules = {
			opts = {
				chat = {
					enabled = true,
				},
			},
		},

		display = {
			chat = {
				fold_context = true,
				show_token_count = true,
				floating_window = {
					relative = "editor",
					opts = {
						wrap = true,
						number = false,
						relativenumber = false,
						padding = { 0, 8, 0, 0 }, -- top, right, bottom, left
					},
				},
				window = {
					layout = "float",
					width = 0.65,
					padding = { 20, 20, 20, 20 },
					height = 0.85,
					relative = "editor",
					border = "rounded",
					title = "CodeCompanion (gpt-4.1)",
					wrap = true,
				},
			},
			action_palette = {
				width = 95,
				height = 20,
				prompt = "Prompt ",
				provider = "default",
				window = {
					layout = "float",
					width = 0.9,
					height = 0.4,
					relative = "editor",
					row = 0.3,
					col = 0.5,
					border = "rounded",
					title = "CodeCompanion Actions",
					wrap = true,
				},
				opts = {
					show_preset_actions = true,
					show_preset_prompts = true,
					title = "CodeCompanion Actions",
				},
			},
			diff = {
				provider = "mini_diff",
			},
		},

		language = "English",

		log_level = "DEBUG",

		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					make_vars = true,
					make_slash_commands = true,
					show_result_in_chat = true,
				},
			},
			agentskills = {
				opts = {
					paths = {
						{ "~/.agents/skills/", recursive = true },
						{ ".agents/skills/", recursive = true },
					},
				},
			},
		},

		prompt_library = {
			["Code Review"] = {
				strategy = "chat",
				description = "Perform a code review",
				opts = {
					short_name = "review",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a code review expert. ALWAYS answer in English. Analyze the provided code and give constructive feedback on: readability, performance, security, potential bugs, and best practices.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Perform a code review for this file")
						end,
						opts = { contains_code = true },
					},
				},
			},

			["Optimize"] = {
				strategy = "chat",
				description = "Optimize the selected code",
				opts = {
					short_name = "optimize",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a code optimization expert. ALWAYS answer in English. Suggest performance improvements while maintaining readability.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Optimize this code")
						end,
						opts = { contains_code = true },
					},
				},
			},

			["Document"] = {
				strategy = "inline",
				description = "Add documentation to the code",
				opts = {
					short_name = "doc",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a code documentation expert. ALWAYS answer in English. Add clear comments and appropriate docstrings for the used language. Return only the documented code, without markdown.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Document this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Explain the code"] = {
				strategy = "chat",
				description = "Explain in detail how the selected code works.",
				opts = {
					short_name = "explain",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are an expert educator. ALWAYS answer in English. Explain in detail how the provided code works, line by line if necessary, and provide the general context.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Explain this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Refactor for readability"] = {
				strategy = "chat",
				description = "Refactor the code to make it more readable and maintainable.",
				opts = {
					short_name = "refacto",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a refactoring expert. ALWAYS answer in English. Improve the structure, readability, and maintainability of the provided code without changing its logic.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Refactor this code for readability")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Add usage examples"] = {
				strategy = "chat",
				description = "Provide usage examples for the selected code.",
				opts = {
					short_name = "exemple",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a software pedagogy expert. ALWAYS answer in English. Provide relevant and realistic usage examples for the provided code.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Give usage examples for this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Translate the code into another language"] = {
				strategy = "chat",
				description = "Translate the selected code into another language (to be specified).",
				opts = {
					short_name = "traduire",
					auto_submit = false,
				},
				prompts = {
					{
						role = "system",
						content = "You are a code porting expert. ALWAYS answer in English. Translate the provided code into the target language specified by the user.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Translate this code into the indicated target language")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Secure the code"] = {
				strategy = "chat",
				description = "Analyze and fix security vulnerabilities in the selected code.",
				opts = {
					short_name = "secure",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a software security expert. ALWAYS answer in English. Analyze the provided code, identify potential security vulnerabilities, and suggest fixes.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Secure this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Generate API documentation"] = {
				strategy = "chat",
				description = "Generate complete API documentation for the selected code.",
				opts = {
					short_name = "apidoc",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a software documentation expert. ALWAYS answer in English. Generate complete API documentation (docstrings, structured comments) for the provided code.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Generate API documentation for this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Add assertions or checks"] = {
				strategy = "chat",
				description = "Add assertions or input checks to the selected code.",
				opts = {
					short_name = "assert",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a software robustness expert. ALWAYS answer in English. Add relevant assertions or input checks to the provided code.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Add assertions or checks to this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Summarize the code"] = {
				strategy = "chat",
				description = "Provide a summary of the selected code.",
				opts = {
					short_name = "resume",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a software synthesis expert. ALWAYS answer in English. Summarize the provided code, highlighting the main logic and general structure.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Summarize this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Generate a test plan"] = {
				strategy = "chat",
				description = "Suggest a test plan for the selected code.",
				opts = {
					short_name = "plantest",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a software quality expert. ALWAYS answer in English. Suggest a test plan (unit, integration, edge cases) suitable for the provided code.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Suggest a test plan for this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Detect dependencies and impacts"] = {
				strategy = "chat",
				description = "List dependencies and potential impacts of the selected code.",
				opts = {
					short_name = "impact",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a software architecture expert. ALWAYS answer in English. List the dependencies of the provided code and analyze the potential impacts of a modification.",
					},
					{
						role = "user",
						content = function(context)
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Analyze the dependencies and impacts of this code")
						end,
						opts = { contains_code = true },
					},
				},
			},
		},
	},
}
