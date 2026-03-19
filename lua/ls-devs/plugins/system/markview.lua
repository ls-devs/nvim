return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	opts = function()
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
				hybrid_modes = { "i" },
				filetypes = {
					"md",
					"markdown",
					"codecompanion",
				},
				ignore_buftypes = { "alpha" },
				condition = function(buffer)
					local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt

					if bt == "nofile" and ft == "codecompanion" then
						return true
					elseif bt == "nofile" then
						return false
					else
						return nil
					end
				end,
			},
			html = {
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
