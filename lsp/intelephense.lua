-- ── lsp/intelephense ──────────────────────────────────────────────────────
-- Server  : intelephense
-- Language: PHP
-- Config  : Extended stubs list (core PHP + WordPress ecosystem),
--           global composer stub paths, cache flush on attach
-- Note    : Formatting handled by conform (prettierd)
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		intelephense = {
			-- Core PHP extensions plus the full WordPress ecosystem (WooCommerce,
			-- ACF Pro, WP-CLI, Genesis, Polylang, xdebug, etc.)
			stubs = {
				"bcmath",
				"bz2",
				"Core",
				"curl",
				"date",
				"dom",
				"fileinfo",
				"filter",
				"gd",
				"gettext",
				"hash",
				"iconv",
				"imap",
				"intl",
				"json",
				"libxml",
				"mbstring",
				"mcrypt",
				"mysql",
				"mysqli",
				"password",
				"pcntl",
				"pcre",
				"PDO",
				"pdo_mysql",
				"Phar",
				"readline",
				"regex",
				"session",
				"SimpleXML",
				"sockets",
				"sodium",
				"standard",
				"superglobals",
				"tokenizer",
				"xml",
				"xdebug",
				"xmlreader",
				"xmlwriter",
				"yaml",
				"zip",
				"zlib",
				"wordpress-stubs",
				"woocommerce-stubs",
				"acf-pro-stubs",
				"wordpress-globals",
				"wp-cli-stubs",
				"genesis-stubs",
				"polylang-stubs",
			},
			environment = {
				-- Globally installed composer PHP stubs (php-stubs/* and wpsyntex/*)
				includePaths = {
					vim.env.HOME .. "/.config/composer/vendor/php-stubs/",
					vim.env.HOME .. "/.config/composer/vendor/wpsyntex/",
				},
			},
			-- Flush the intelephense index cache on every attach to avoid stale data
			clearCache = true,
			files = {
				maxSize = 5000000, -- 5 MB per-file limit; raise for monorepos with large generated files
			},
		},
	},
}
