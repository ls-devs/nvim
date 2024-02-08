return {
	ensure_installed = {

		-- LSP
		"eslint",
		"astro",
		"html",
		"lemminx",
		"mdx_analyzer",
		"cssls",
		"cssmodules_ls",
		"emmet_language_server",
		"volar",
		"tailwindcss",
		"prismals",
		"jsonls",
		"intelephense",
		"sqlls",
		"yamlls",
		"dockerls",
		"docker_compose_language_service",
		"marksman",
		"rust_analyzer",
		"pyright",
		"cmake",
		"lua_ls",
		"clangd",
		"bashls",
		"vimls",
		"graphql",
		"wgsl_analyzer",
		"svelte",
		"taplo",
		"vls",
		"kotlin_language_server",

		-- Lintters
		"gitlint",
		"stylelint",
		"djlint",
		"jsonlint",
		"hadolint",
		"markdownlint",
		"cmakelint",
		"yamllint",
		"cpplint",
		"sqlfluff",
		"shellcheck",

		-- Formatters
		"prettierd",
		"mdformat",
		"cmakelang",
		"clang-format",
		"yq",
		"stylua",
		"gersemi",
		"black",
		"isort",
		"sql-formatter",
		"rustfmt",
		"shellharden",

		-- Debuggers
		"debugpy",
		"node-debug2-adapter",
		"bash-debug-adapter",
		"php-debug-adapter",
		"codelldb",
		"js-debug-adapter",
		"chrome-debug-adapter",
		"kotlin-debug-adapter",
	},

	auto_update = true,

	run_on_start = true,

	start_delay = 3000,

	debounce_hours = 5,
}
