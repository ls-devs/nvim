-- ── markview ──────────────────────────────────────────────────────────────
-- Purpose : Markdown/Norg renderer with hybrid mode (raw syntax on current line)
-- Trigger : markdown, markdown_inline, html, norg filetypes
-- Note    : html.container_elements maps CodeCompanion XML chat tags to icons
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"OXY2DEV/markview.nvim",
	ft = { "markdown", "markdown_inline", "html", "norg" },
	keys = {
		{
			"<leader>um",
			"<cmd>Markview Toggle<CR>",
			desc = "Markview Toggle",
			noremap = true,
			silent = true,
		},
	},
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
					-- Strict guard: detach from anything that is not a real markdown
					-- file on disk or a codecompanion buffer.
					-- Runs before render(); returning early here is enough to block
					-- rendering on buffers that slipped past the condition check due
					-- to option-set timing races (lspsaga sets filetype='markdown'
					-- after buftype='nofile', briefly bypassing ignore_buftypes).
					---@param buffer integer
					on_attach = function(buffer)
						local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })
						local bt = vim.api.nvim_get_option_value("buftype", { buf = buffer })
						local name = vim.api.nvim_buf_get_name(buffer)

						local allowed = ft == "codecompanion"
							or (bt == "" and name ~= "" and vim.fn.filereadable(name) == 1)

						if not allowed then
							pcall(require("markview.actions").detach, buffer)
							pcall(require("markview.state").detach, buffer, true)
						end
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
					"markdown",
					"codecompanion",
				},
				ignore_buftypes = { "help", "nofile", "terminal", "prompt", "quickfix" },
				-- Never return nil — always give markview a definitive yes/no so
				-- the filetypes list is never consulted as a fallback. This prevents
				-- diagnostic / hover floats from matching "markdown" in the list.
				---@param buffer integer
				---@return boolean
				condition = function(buffer)
					local ft = vim.bo[buffer].filetype
					local bt = vim.bo[buffer].buftype

					if ft == "codecompanion" then
						return true
					end

					if bt ~= "" then
						return false
					end

					-- Reject any markdown buffer that lives inside a floating window.
					-- This catches all lspsaga/LSP hover/diagnostic floats regardless
					-- of what buftype or name they end up with.
					for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
						if vim.api.nvim_win_get_config(win).relative ~= "" then
							return false
						end
					end

					local name = vim.api.nvim_buf_get_name(buffer)
					if name == "" or vim.fn.filereadable(name) == 0 then
						return false
					end

					-- Only real markdown files on disk
					return ft == "markdown"
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
	-- lazy.nvim passes the evaluated opts table here; we call setup() manually
	-- so we can also register the float guard autocmd.
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("markview").setup(opts)

		-- Guard: runs after FileType=markdown fires on ANY buffer.
		-- vim.schedule defers to after lspsaga's bufopt() has finished setting
		-- ALL options (filetype + buftype + winopt conceallevel=2), so every
		-- check below sees the final, stable state.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			group = vim.api.nvim_create_augroup("markview_float_guard", { clear = true }),
			callback = function(ev)
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(ev.buf) then
						return
					end

					local ft = vim.bo[ev.buf].filetype
					if ft == "codecompanion" then
						return
					end

					local name = vim.api.nvim_buf_get_name(ev.buf)
					local is_real_file = name ~= "" and vim.fn.filereadable(name) == 1

					-- Float windows (e.g. lspsaga hover, code actions):
					-- markview.actions.detach() unconditionally fires on_detach which
					-- resets conceallevel=0 on every window — even if markview was never
					-- attached. Bypass actions.detach entirely: use state.detach directly
					-- (no callbacks) + actions.clear (only removes decorations, no winopt
					-- changes), then explicitly set conceallevel=2 so lspsaga's treesitter
					-- markdown conceal queries (hiding ``` fences) still work.
					for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
						if vim.api.nvim_win_get_config(win).relative ~= "" then
							pcall(require("markview.state").detach, ev.buf, true)
							pcall(require("markview.actions").clear, ev.buf)
							pcall(function()
								vim.wo[win].conceallevel = 2
							end)
							return
						end
					end

					if not is_real_file then
						pcall(require("markview.state").detach, ev.buf, true)
						pcall(require("markview.actions").clear, ev.buf)
					end
				end)
			end,
		})
	end,
}
