return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "BufReadPre", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local luasnip_vscode_loader = require("luasnip/loaders/from_vscode")
			luasnip_vscode_loader.lazy_load()

			local has_words_before = function()
				local unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				enabled = function()
					local context = require("cmp.config.context")
					local disabled = false
					disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
					disabled = disabled or (vim.fn.reg_recording() ~= "")
					disabled = disabled or (vim.fn.reg_executing() ~= "")
					disabled = disabled or context.in_treesitter_capture("comment")
					disabled = disabled or context.in_syntax_group("Comment")
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					else
						return not disabled
					end
				end,
				sorting = {
					priority_weight = 3,
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						require("cmp-under-comparator").under,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
						cmp.config.compare.recently_used,
					},
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				formatting = {
					expandable_indicator = true,
					fields = { "kind", "abbr", "menu" },
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
						symbol_map = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
						},
						before = function(entry, vim_item)
							vim_item.menu = ({
								nvim_lsp = "[LSP]",
								luasnip = "[SNIPPET]",
								buffer = "[BUFFER]",
								async_path = "[PATH]",
								emoji = "[EMOJI]",
								cmdline = "[CMD]",
								npm = "[NPM]",
								zsh = "[ZSH]",
								crates = "[CRATES]",
								rg = "[RG]",
								dotenv = "[ENV]",
								["sass-variables"] = "[SASS]",
							})[entry.source.name]
							return vim_item
						end,
					}),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer", max_item_count = 5 },
					{ name = "async_path", max_item_count = 3 },
					{ name = "luasnip", max_item_count = 3 },
					{ name = "sass-variables" },
					{ name = "dotenv" },
					{
						name = "rg",
						keyword_length = 3,
						options = {
							additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/.ignore.rg",
						},
					},
					{
						name = "npm",
						keyword_length = 4,
					},
					{ name = "crates" },
					{ name = "emoji" },
				},
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				window = {
					completion = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					}),
					documentation = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					}),
				},
			})
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" },
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "cmdline" },
				}),
			})
			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
		end,
		dependencies = {
			{ "hrsh7th/cmp-buffer", lazy = true },
			{ "hrsh7th/cmp-path", lazy = true },
			{ url = "https://codeberg.org/FelipeLema/cmp-async-path", lazy = true },
			{ "hrsh7th/cmp-emoji", lazy = true },
			{ "hrsh7th/cmp-cmdline", lazy = true },
			{ "hrsh7th/cmp-nvim-lsp", lazy = true },
			{ "onsails/lspkind.nvim", lazy = true },
			{ "SergioRibera/cmp-dotenv", lazy = true },
			{ "rafamadriz/friendly-snippets", lazy = true },
			{
				"L3MON4D3/LuaSnip",
				lazy = true,
				build = "make install_jsregexp",
			},
			{ "saadparwaiz1/cmp_luasnip", lazy = true },
			{ "lukas-reineke/cmp-under-comparator", lazy = true },
		},
	},
}
