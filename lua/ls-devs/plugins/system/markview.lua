-- ── markview ──────────────────────────────────────────────────────────────
-- Purpose : Markdown/Norg renderer with hybrid mode (raw syntax on current line)
-- Trigger : markdown, markdown_inline, html, norg filetypes
-- Note    : html.container_elements maps CodeCompanion XML chat tags to icons
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"OXY2DEV/markview.nvim",
	ft = { "markdown", "markdown_inline", "html", "norg" },
	---@return table
	opts = function()
		-- Builds a markview conceal spec for an HTML container element:
		-- conceals the closing tag and replaces the opening tag with a virtual-text icon.
		---@param icon string
		---@param hl_group string
		---@return table
		local function conceal_tag(icon, hl_group)
			return {
				on_node = { hl_group = hl_group },
				on_closing_tag = { conceal = "" },
				on_opening_tag = {
					conceal = "",
					virt_text_pos = "inline",
					virt_text = { { icon .. " ", hl_group } },
				},
			}
		end

		return {
			preview = {
				modes = { "n", "i", "no", "c" },
				hybrid_modes = { "i" }, -- show raw markdown on the current line while in insert mode
				callbacks = {
					-- Fires before render() — detaching here prevents any rendering entirely.
					-- Needed because lspsaga sets filetype="markdown" *before* buftype="nofile",
					-- so the timing window lets markview attach to the hover buffer before
					-- ignore_buftypes can catch it.
					---@param buffer integer
					---@param wins integer[]
					on_attach = function(buffer, wins)
						local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })
						local bt = vim.api.nvim_get_option_value("buftype", { buf = buffer })
						local name = vim.api.nvim_buf_get_name(buffer)

						-- Fast-path 1: buftype already set to nofile at attach time.
						-- (happens when buftype is set before filetype)
						if bt == "nofile" and ft ~= "codecompanion" then
							pcall(require("markview.actions").detach, buffer)
							pcall(require("markview.state").detach, buffer, true)
							return
						end

						-- Fast-path 2: anonymous buffer (no file path).
						-- LSP hover buffers are created with nvim_create_buf(false, true) and
						-- never given a name; real markdown files always have a path.
						-- BufAdd fires before the window is opened, so wins may be empty here;
						-- this check fires even in that race window.
						if name == "" and ft ~= "codecompanion" then
							pcall(require("markview.actions").detach, buffer)
							pcall(require("markview.state").detach, buffer, true)
							return
						end

						-- Slow-path: named buffer in floating windows only
						-- (covers edge cases like help:// URIs that do have names)
						if #wins == 0 then
							return -- no windows yet → not a float we need to block
						end
						for _, win in ipairs(wins) do
							if vim.api.nvim_win_get_config(win).relative == "" then
								return -- at least one normal window → keep attached
							end
						end
						-- Every window is floating (LSP hover, etc.) → prevent rendering.
						-- actions.detach() calls state.detach(buf, false) which clears
						-- attached_buffers but KEEPS buffer_states{enable=true}. Back in
						-- actions.attach() line 536, get_buffer_state(buf,false) still
						-- returns that state and render() fires. We also call
						-- state.detach(buf, true) to wipe buffer_states so
						-- get_buffer_state returns nil → render is never reached.
						pcall(require("markview.actions").detach, buffer)
						pcall(require("markview.state").detach, buffer, true)
					end,
					-- wins is a table of window IDs returned by vim.fn.win_findbuf()
					---@param _ integer
					---@param wins integer[]
					on_enable = function(_, wins)
						for _, win in ipairs(wins) do
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = "nc"
						end
					end,
				},
				filetypes = {
					"md",
					"markdown",
					"codecompanion",
				},
				-- "nofile" must be here: markview's spec.get() converts false→nil via
				-- `ok and res or nil`, so condition returning false becomes nil and
				-- markview falls back to these lists. codecompanion is safe because
				-- its condition returns true, which bypasses ignore_buftypes entirely.
				ignore_buftypes = { "help", "nofile" },
				-- codecompanion nofile buffers get rendered; other nofile/unnamed buffers are
				-- skipped; buffers shown only in floating windows (LSP hover, signature, etc.)
				-- are skipped; nil lets markview apply its own heuristics.
				---@param buffer integer
				---@return boolean?
				condition = function(buffer)
					local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt

					if bt == "nofile" and ft == "codecompanion" then
						return true
					elseif bt == "nofile" then
						return false
					elseif vim.api.nvim_buf_get_name(buffer) == "" then
						return false
					else
						-- Exclude buffers that only appear in floating windows
						-- (covers lspsaga hover_doc, LSP signature help, etc.)
						local wins = vim.fn.win_findbuf(buffer)
						if #wins > 0 then
							local all_floating = true
							for _, win in ipairs(wins) do
								if vim.api.nvim_win_get_config(win).relative == "" then
									all_floating = false
									break
								end
							end
							if all_floating then
								return false
							end
						end
						return nil
					end
				end,
			},
			html = {
				-- Maps CodeCompanion XML chat tags (buf, file, tool, etc.) to Nerd Font icons via conceal
				container_elements = {
					["^buf$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^file$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^help$"] = conceal_tag("󰘥", "CodeCompanionChatVariable"),
					["^image$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^symbols$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^url$"] = conceal_tag("󰖟", "CodeCompanionChatVariable"),
					["^var$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^tool$"] = conceal_tag("", "CodeCompanionChatTool"),
					["^user_prompt$"] = conceal_tag("", "CodeCompanionChatTool"),
					["^group$"] = conceal_tag("", "CodeCompanionChatToolGroup"),
				},
			},
		}
	end,
}
