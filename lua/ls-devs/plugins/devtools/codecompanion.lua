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
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
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
				window = {
					layout = "float",
					width = 0.65,

					height = 0.85,
					relative = "editor",
					border = "rounded",
					title = "CodeCompanion (gpt-4.1)",

					wrap = true,
				},
			},
			action_palette = {
				provider = "default",
			},
			diff = {
				provider = "mini_diff",
			},
		},

		language = "Français",

		log_level = "INFO",

		extensions = {
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
				description = "Effectuer une revue de code",
				opts = {
					short_name = "review",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en revue de code. Réponds TOUJOURS en français. Analyse le code fourni et donne des retours constructifs sur : la lisibilité, les performances, la sécurité, les bugs potentiels et les bonnes pratiques.",
					},
					{
						role = "user",
						content = function(context)
							-- Utilise la sélection courante si elle existe, sinon tout le buffer
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Effectue une revue de code pour ce fichier")
						end,
						opts = { contains_code = true },
					},
				},
			},

			["Optimiser"] = {
				strategy = "chat",
				description = "Optimiser le code sélectionné",
				opts = {
					short_name = "optimize",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en optimisation de code. Réponds TOUJOURS en français. Propose des améliorations de performance tout en conservant la lisibilité.",
					},
					{
						role = "user",
						content = function(context)
							-- Utilise la sélection courante si elle existe, sinon tout le buffer
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Optimise ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},

			["Documenter"] = {
				strategy = "inline",
				description = "Ajouter de la documentation au code",
				opts = {
					short_name = "doc",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en documentation de code. Réponds TOUJOURS en français. Ajoute des commentaires clairs et des docstrings appropriés au langage utilisé. Retourne uniquement le code documenté, sans markdown.",
					},
					{
						role = "user",
						content = function(context)
							-- Utilise la sélection courante si elle existe, sinon tout le buffer
							if
								not context.start_line
								or not context.end_line
								or context.start_line == context.end_line
							then
								context.start_line = 1
								context.end_line = vim.api.nvim_buf_line_count(context.bufnr or 0)
							end
							return make_code_prompt(context, "Documente ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Expliquer le code"] = {
				strategy = "chat",
				description = "Expliquer en détail le fonctionnement du code sélectionné.",
				opts = {
					short_name = "explain",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert pédagogue. Réponds TOUJOURS en français. Explique en détail le fonctionnement du code fourni, ligne par ligne si nécessaire, et donne le contexte général.",
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
							return make_code_prompt(context, "Explique ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Refactoriser pour la lisibilité"] = {
				strategy = "chat",
				description = "Refactoriser le code pour le rendre plus lisible et maintenable.",
				opts = {
					short_name = "refacto",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en refactorisation. Réponds TOUJOURS en français. Améliore la structure, la lisibilité et la maintenabilité du code fourni sans en changer la logique.",
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
							return make_code_prompt(context, "Refactorise ce code pour la lisibilité")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Ajouter des exemples d’utilisation"] = {
				strategy = "chat",
				description = "Fournir des exemples d’utilisation du code sélectionné.",
				opts = {
					short_name = "exemple",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en pédagogie logicielle. Réponds TOUJOURS en français. Propose des exemples d’utilisation pertinents et réalistes pour le code fourni.",
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
							return make_code_prompt(context, "Donne des exemples d'utilisation pour ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Traduire le code dans un autre langage"] = {
				strategy = "chat",
				description = "Traduire le code sélectionné dans un autre langage (à préciser).",
				opts = {
					short_name = "traduire",
					auto_submit = false,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en portage de code. Réponds TOUJOURS en français. Traduis le code fourni dans le langage cible précisé par l'utilisateur.",
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
							return make_code_prompt(context, "Traduis ce code dans le langage cible indiqué")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Sécuriser le code"] = {
				strategy = "chat",
				description = "Analyser et corriger les failles de sécurité dans le code sélectionné.",
				opts = {
					short_name = "secure",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en sécurité logicielle. Réponds TOUJOURS en français. Analyse le code fourni, identifie les failles de sécurité potentielles et propose des corrections.",
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
							return make_code_prompt(context, "Sécurise ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Générer la documentation API"] = {
				strategy = "chat",
				description = "Générer une documentation API complète pour le code sélectionné.",
				opts = {
					short_name = "apidoc",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en documentation logicielle. Réponds TOUJOURS en français. Génère une documentation API complète (docstrings, commentaires structurés) pour le code fourni.",
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
							return make_code_prompt(context, "Génère la documentation API pour ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Ajouter des assertions ou vérifications"] = {
				strategy = "chat",
				description = "Ajouter des assertions ou des vérifications d’entrées au code sélectionné.",
				opts = {
					short_name = "assert",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en robustesse logicielle. Réponds TOUJOURS en français. Ajoute des assertions ou des vérifications d’entrées pertinentes au code fourni.",
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
							return make_code_prompt(context, "Ajoute des assertions ou vérifications à ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Résumer le code"] = {
				strategy = "chat",
				description = "Fournir un résumé du code sélectionné.",
				opts = {
					short_name = "resume",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en synthèse logicielle. Réponds TOUJOURS en français. Résume le code fourni en mettant en avant la logique principale et la structure générale.",
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
							return make_code_prompt(context, "Résume ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Générer un plan de tests"] = {
				strategy = "chat",
				description = "Proposer un plan de tests pour le code sélectionné.",
				opts = {
					short_name = "plantest",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en qualité logicielle. Réponds TOUJOURS en français. Propose un plan de tests (unitaires, intégration, cas limites) adapté au code fourni.",
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
							return make_code_prompt(context, "Propose un plan de tests pour ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
			["Détecter les dépendances et impacts"] = {
				strategy = "chat",
				description = "Lister les dépendances et les impacts potentiels du code sélectionné.",
				opts = {
					short_name = "impact",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "Tu es un expert en architecture logicielle. Réponds TOUJOURS en français. Liste les dépendances du code fourni et analyse les impacts potentiels d'une modification.",
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
							return make_code_prompt(context, "Analyse les dépendances et impacts de ce code")
						end,
						opts = { contains_code = true },
					},
				},
			},
		},
	},
}
