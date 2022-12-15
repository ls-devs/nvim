return {
	settings = {
		intelephense = {
			stubs = {
				"bcmath",
				"bz2",
				"mysql",
				"psql",
				"calendar",
				"Core",
				"curl",
				"zip",
				"zlib",
				"wordpress",
				"woocommerce",
				"acf-pro",
				"wordpress-globals",
				"wp-cli",
				"genesis",
				"polylang",
			},
			environment = {
				includePaths = "/home/laurent/.config/composer/vendor/php-stubs/",
			},
			files = {
				maxSize = 5000000,
			},
		},
	},
}
