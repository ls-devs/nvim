-- ── fidget.nvim ───────────────────────────────────────────────────────────
-- Purpose : LSP progress spinner displayed in the bottom-right corner
-- Trigger : LspAttach
-- Note    : override_vim_notify is false — noice owns vim.notify routing;
--           fidget is scoped to LSP $progress messages only
-- ─────────────────────────────────────────────────────────────────────────
return {
	"j-hui/fidget.nvim",
	event = { "LspAttach" },
	config = function()
		require("fidget").setup({
			progress = {
				-- Event-driven; 0 disables polling in favour of LSP push notifications
				poll_rate = 0,
				-- Hide spinners while typing to avoid distracting visual noise
				suppress_on_insert = true,
				-- Skip tasks that completed before fidget attached to the LSP client
				ignore_done_already = true,
				ignore_empty_message = true,

				-- Returns the client name so the group title persists after the client disconnects
				clear_on_detach = function(client_id)
					local client = vim.lsp.get_client_by_id(client_id)
					return client and client.name or nil
				end,

				-- Group all progress messages from the same LSP client together
				notification_group = function(msg)
					return msg.lsp_client.name
				end,
				ignore = {},

				display = {
					render_limit = 16,
					-- Keep completed task indicators visible for 3 seconds before clearing
					done_ttl = 3,
					done_icon = " ",
					done_style = "Constant",
					-- Never expire in-progress tasks; they clear only when the LSP reports done
					progress_ttl = math.huge,
					-- Animated clock spinner cycling every 0.7 s
					progress_icon = { pattern = "clock", period = 0.7 },

					progress_style = "WarningMsg",
					group_style = "Title",
					icon_style = "Question",
					priority = 30,
					-- Don't add LSP progress events to the notification history list
					skip_history = true,

					format_message = function(msg)
						local message = msg.message
						if not message then
							message = msg.done and " Completed" or " In progress..."
						end
						if msg.percentage ~= nil then
							message = string.format(" %s (%.0f%%)", message, msg.percentage)
						end
						return message
					end,

					format_annote = function(msg)
						if msg.title then
							return msg.title .. " "
						else
							return ""
						end
					end,

					format_group_name = function(group)
						return tostring(group)
					end,
					overrides = {},
				},

				lsp = {
					progress_ringbuf_size = 0, -- unlimited ring buffer for LSP progress messages
					log_handler = false,
				},
			},

			notification = {
				poll_rate = 10,
				filter = vim.log.levels.INFO,
				history_size = 128,
				-- Noice owns vim.notify; fidget must not intercept it
				override_vim_notify = false,

				configs = { default = require("fidget.notification").default_config },

				-- Delegate notifications with on_open callbacks to nvim-notify (e.g. noice)
				redirect = function(msg, level, opts)
					if opts and opts.on_open then
						return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
					end
				end,

				view = {
					-- Newest entries appear at the bottom of the notification window
					stack_upwards = true,
					icon_separator = " ",
					group_separator = "", -- no divider line between notification groups
					group_separator_hl = "Comment",
					render_message = function(msg, cnt)
						return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
					end,
				},

				window = {
					normal_hl = "Fidget",
					winblend = 0,
					border = "rounded",
					-- Below completion menus (~50) but above normal windows
					zindex = 45,
					-- 0 = unconstrained; window size is determined by content
					max_width = 0,
					max_height = 0,
					x_padding = 1,
					y_padding = 0,
					align = "top",
					relative = "editor",
					avoid = { "NvimTree", "TestExplorer" },
				},
			},

			logger = {
				level = vim.log.levels.WARN,
				max_size = 10000,
				float_precision = 0.01,

				path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
			},
		})
	end,
}
