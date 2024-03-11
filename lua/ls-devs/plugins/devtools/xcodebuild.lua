return {
	"wojciech-kulik/xcodebuild.nvim",
	ft = "swift",
	dependencies = {
		{ "nvim-telescope/telescope.nvim", lazy = true },
		{ "MunifTanjim/nui.nvim", lazy = true },
	},
	opts = {
		restore_on_start = true,
		auto_save = true,
		show_build_progress_bar = true,
		prepare_snapshot_test_previews = true,
		test_search = {
			file_matching = "filename_lsp",
			target_matching = true,
			lsp_client = "sourcekit",
			lsp_timeout = 200,
		},
		commands = {
			cache_devices = true,
			extra_build_args = "-parallelizeTargets",
			extra_test_args = "-parallelizeTargets",
			project_search_max_depth = 3,
		},
		logs = {
			auto_open_on_success_tests = false,
			auto_open_on_failed_tests = false,
			auto_open_on_success_build = false,
			auto_open_on_failed_build = true,
			auto_close_on_app_launch = false,
			auto_close_on_success_build = false,
			auto_focus = true,
			filetype = "objc",
			open_command = "silent botright 20split {path}",
			logs_formatter = "xcbeautify --disable-colored-output",
			only_summary = false,
			show_warnings = true,
			notify = function(message, severity)
				vim.notify(message, severity)
			end,
			notify_progress = function(message)
				vim.cmd("echo '" .. message .. "'")
			end,
		},
		console_logs = {
			enabled = true,
			format_line = function(line)
				return line
			end,
			filter_line = function(line)
				return true
			end,
		},
		marks = {
			show_signs = true,
			success_sign = "✔",
			failure_sign = "✖",
			show_test_duration = true,
			show_diagnostics = true,
			file_pattern = "*Tests.swift",
		},
		quickfix = {
			show_errors_on_quickfixlist = true,
			show_warnings_on_quickfixlist = true,
		},
		test_explorer = {
			enabled = true,
			auto_open = true,
			auto_focus = true,
			open_command = "botright 42vsplit Test Explorer",
			open_expanded = true,
			success_sign = "✔",
			failure_sign = "✖",
			progress_sign = "…",
			disabled_sign = "⏸",
			partial_execution_sign = "‐",
			not_executed_sign = " ",
			show_disabled_tests = false,
			animate_status = true,
			cursor_follows_tests = true,
		},
		code_coverage = {
			enabled = false,
			file_pattern = "*.swift",

			covered_sign = "",
			partially_covered_sign = "┃",
			not_covered_sign = "┃",
			not_executable_sign = "",
		},
		code_coverage_report = {
			warning_coverage_level = 60,
			error_coverage_level = 30,
			open_expanded = false,
		},
		integrations = {
			nvim_tree = {
				enabled = true,
				should_update_project = function(path)
					return true
				end,
			},
		},
		highlights = {},
	},
}
