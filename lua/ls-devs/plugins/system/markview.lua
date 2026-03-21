-- ── markview ──────────────────────────────────────────────────────────────
-- Purpose : Markdown/Norg renderer with hybrid mode (raw syntax on current line)
-- Trigger : markdown, markdown_inline, html, norg filetypes
-- Note    : html.container_elements maps CodeCompanion XML chat tags to icons
-- ─────────────────────────────────────────────────────────────────────────
return {
	"OXY2DEV/markview.nvim",
	ft = { "markdown", "markdown_inline", "html", "norg" },
	opts = function()
		-- Builds a markview conceal spec for an HTML container element:
		-- conceals the closing tag and replaces the opening tag with a virtual-text icon.
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
			modes = { "n", "i", "no", "c" },
			hybrid_modes = { "i", "n" },
			callbacks = {
				on_enable = function(_, win)
					vim.wo[win].conceallevel = 2
					vim.wo[win].concealcursor = "nc"
				end,
			},

			preview = {
				modes = { "n", "i", "no", "c" },
				hybrid_modes = { "i" }, -- show raw markdown on the current line while in insert mode
				filetypes = {
					"md",
					"markdown",
					"codecompanion",
				},
				ignore_buftypes = { "alpha" },
				-- codecompanion nofile buffers get rendered; other nofile/unnamed buffers are
				-- skipped; nil lets markview apply its own heuristics.
				condition = function(buffer)
					local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt

					if bt == "nofile" and ft == "codecompanion" then
						return true
					elseif bt == "nofile" then
						return false
					elseif vim.api.nvim_buf_get_name(buffer) == "" then
						return false
					else
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
