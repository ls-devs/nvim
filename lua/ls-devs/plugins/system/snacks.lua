---@diagnostic disable: undefined-global
-- ── snacks.nvim ───────────────────────────────────────────────────────────
-- Purpose : QoL collection replacing bigfile, alpha, telescope, toggleterm,
--           dressing-input; adds quickfile, scroll, indent, scope, words,
--           bufdelete, gitbrowse, toggle.
-- Trigger : lazy=false, priority=1000 (required for snacks setup autocmds)
-- Sub-modules (not imported by lazy.nvim):
--   snacks/dashboard.lua  — dashboard preset + sections
--   snacks/picker.lua     — picker layout + keymaps
--   snacks/keys.lua       — all lazy keys specs
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = { { "echasnovski/mini.icons", lazy = false } },

	-- ── init ─────────────────────────────────────────────────────────────
	-- Runs before setup(). Wires autocmds that must fire before VimEnter.
	init = function()
		-- Terminal mode keymaps — mirrors old toggleterm set_terminal_keymaps().
		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = function()
				local o = { noremap = true, silent = true, buffer = 0 }
				vim.keymap.set("t", "<C-x>", [[<Cmd>q!<CR>]], o)
				vim.keymap.set("t", "<C-q>", [[<Cmd>hide<CR>]], o)
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], o)
				vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], o)
				vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], o)
				vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], o)
				vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], o)
			end,
		})

		-- Dashboard: hide statusline/tabline while visible; guard against
		-- lualine/tabby re-enabling them when floats (picker, neo-tree) open.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "snacks_dashboard",
			callback = function()
				vim.opt_local.laststatus = 0
				vim.opt_local.showtabline = 0
				vim.b.miniindentscope_disable = true

				local dash_buf = vim.api.nvim_get_current_buf()
				local aug = vim.api.nvim_create_augroup("DashboardStatusGuard_" .. dash_buf, { clear = true })

				---@return boolean
				local function dash_visible()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_buf(win) == dash_buf then
							return true
						end
					end
					return false
				end

				-- OptionSet fires synchronously on any laststatus/showtabline change.
				-- Reset to 0 while dashboard is still visible; prevents status leak
				-- when opening picker/neo-tree floats over the dashboard.
				local guarding = false
				local function guard()
					if guarding then
						return
					end
					if dash_visible() then
						guarding = true
						vim.o.laststatus = 0
						vim.o.showtabline = 0
						guarding = false
					else
						pcall(vim.api.nvim_del_augroup_by_id, aug)
					end
				end

				vim.api.nvim_create_autocmd("OptionSet", {
					group = aug,
					pattern = "laststatus",
					callback = guard,
				})
				vim.api.nvim_create_autocmd("OptionSet", {
					group = aug,
					pattern = "showtabline",
					callback = guard,
				})
				vim.api.nvim_create_autocmd("BufUnload", {
					buffer = dash_buf,
					once = true,
					callback = function()
						pcall(vim.api.nvim_del_augroup_by_id, aug)
						vim.opt.laststatus = 3
						vim.opt.showtabline = 2
					end,
				})
			end,
		})

		-- Re-render dashboard after ALL plugins (including VeryLazy) finish loading
		-- so the startup section shows the post-VeryLazy plugin count.
		-- Snacks caches M.lazy_stats after the first render (intentional design), so we
		-- must reset it before calling update() to force a fresh query of lazy.stats.
		-- vim.schedule ensures we run after lazy.nvim's own VeryLazy handlers complete.
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			once = true,
			callback = function()
				vim.schedule(function()
					pcall(function()
						local snacks_dash = require("snacks.dashboard")
						snacks_dash.lazy_stats = nil
						Snacks.dashboard.update()
					end)
				end)
			end,
		})

		-- Disable number/relativenumber in picker preview when the file is markdown.
		-- relativenumber is already off globally; this also clears number for .md files.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			---@param ev vim.api.keyset.create_autocmd.callback_args
			callback = function(ev)
				for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
					if vim.w[win].snacks_picker_preview then
						vim.wo[win].number = false
						vim.wo[win].relativenumber = false
					end
				end
			end,
		})
	end,

	-- ── opts ─────────────────────────────────────────────────────────────
	opts = {
		-- ── bigfile (replaces LunarVim/bigfile.nvim) ──────────────────────
		bigfile = { enabled = true, size = 6 * 1024 * 1024 }, -- 6 MB

		-- ── dashboard / picker — loaded from sub-modules ──────────────────
		dashboard = require("ls-devs.plugins.system.snacks.dashboard"),
		picker = require("ls-devs.plugins.system.snacks.picker"),

		-- ── input (replaces stevearc/dressing.nvim vim.ui.input) ──────────
		input = {
			enabled = true,
			win = { relative = "editor", border = "rounded", title_pos = "center" },
		},

		-- ── terminal (replaces akinsho/toggleterm.nvim) ───────────────────
		terminal = {
			win = {
				position = "float",
				border = "rounded",
				width = 0.65,
				height = 0.4,
				title_pos = "left",
				wo = { winblend = 0 },
			},
		},

		-- ── lazygit (replaces utils/custom_functions.lua M.LazyGit) ───────
		lazygit = {
			configure = true,
			win = { border = "rounded", width = 0.9, height = 0.9 },
		},

		-- ── quickfile ─────────────────────────────────────────────────────
		quickfile = { enabled = true },

		-- ── scroll ────────────────────────────────────────────────────────
		-- Smooth animated scrolling. Excludes picker preview windows so the
		-- animation doesn't fire when scrolling through search results.
		scroll = {
			enabled = true,
			animate = {
				duration = { step = 15, total = 250 },
				easing = "outQuad",
			},
			---@param buf integer
			---@return boolean
			filter = function(buf)
				if vim.g.snacks_scroll == false or vim.b[buf].snacks_scroll == false then
					return false
				end
				if vim.bo[buf].buftype ~= "" then
					return false
				end
				local ft = vim.bo[buf].filetype
				if ft:find("^snacks") then
					return false
				end
				for _, win in ipairs(vim.fn.win_findbuf(buf)) do
					if vim.w[win].snacks_picker_preview then
						return false
					end
				end
				return true
			end,
		},

		-- ── indent ────────────────────────────────────────────────────────
		indent = {
			enabled = true,
			indent = { char = "│" },
			scope = { enabled = true },
			---@param buf integer
			---@return boolean
			filter = function(buf)
				return vim.g.snacks_indent ~= false
					and vim.b[buf].snacks_indent ~= false
					and vim.bo[buf].buftype == ""
					and not vim.tbl_contains({
						"snacks_dashboard",
						"snacks_picker_list",
						"snacks_picker_input",
						"lazy",
						"noice",
						"TelescopePrompt",
					}, vim.bo[buf].filetype)
			end,
		},

		-- ── scope / words / bufdelete ──────────────────────────────────────
		scope = { enabled = true },
		words = {
			enabled = true,
			debounce = 200,
			notify_jump = false,
			notify_end = true,
			foldopen = true,
			jumplist = true,
			modes = { "n", "i" },
		},
		bufdelete = { enabled = true },

		-- ── gitbrowse ─────────────────────────────────────────────────────
		-- Opens current file/line/commit/branch in the browser (GitHub, etc.)
		gitbrowse = { enabled = true },

		-- ── notifier (replaces rcarriga/nvim-notify) ──────────────────────
		-- Intercepts vim.notify and renders pretty floating popups.
		-- noice.notify.enabled is set to false so noice does NOT override
		-- vim.notify; snacks owns it entirely.
		notifier = {
			enabled = true,
			timeout = 3000,
			style = "compact",
			top_down = false, -- stack upward from bottom-right (matches old nvim-notify)
			width = { min = 20, max = 0.6 },
			height = { min = 1, max = 0.6 },
			wrap = true, -- wrap long lines so the full message is always visible
			margin = { top = 0, right = 1, bottom = 1 },
			icons = {
				error = " ",
				warn = " ",
				info = " ",
				debug = " ",
				trace = "✎ ",
			},
			-- Suppress noisy hover "no info" messages (previously in noice routes).
			---@param notif table
			---@return boolean
			filter = function(notif)
				return not (notif.msg and notif.msg:find("No information available"))
			end,
		},

		-- ── statuscolumn ──────────────────────────────────────────────────
		-- Structured sign column: fold chevrons (⌄/›) from nvim-ufo, ordered
		-- git signs, and relative line numbers — all in one consistent layout.
		statuscolumn = { enabled = true },

		-- ── explorer / image ──────────────────────────────────────────────
		-- neo-tree owns the explorer. image is enabled only when the terminal
		-- supports the Kitty graphics protocol (kitty, WezTerm, Ghostty).
		explorer = { enabled = false },
		image = {
			enabled = vim.env.TERM == "xterm-kitty"
				or vim.env.TERM_PROGRAM == "WezTerm"
				or vim.env.TERM_PROGRAM == "ghostty",
		},

		-- ── toggle ────────────────────────────────────────────────────────
		-- Keymaps are wired in config() via :map() for which-key integration.
		toggle = { enabled = true },
	},

	-- ── config ───────────────────────────────────────────────────────────
	-- Injects runtime Neovim version into dashboard header, calls setup,
	-- then wires toggle keymaps via Snacks.toggle.*:map().
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		local version = vim.version()
		opts.dashboard.preset.header = table.concat({
			"███████╗ █████╗  ██████╗████████╗ ██████╗ ██████╗ ██╗   ██╗",
			"██╔════╝██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝",
			"█████╗  ███████║██║        ██║   ██║   ██║██████╔╝ ╚████╔╝ ",
			"██╔══╝  ██╔══██║██║        ██║   ██║   ██║██╔══██╗  ╚██╔╝  ",
			"██║     ██║  ██║╚██████╗   ██║   ╚██████╔╝██║  ██║   ██║   ",
			"╚═╝     ╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝  ",
			"",
			("v%d.%d.%d"):format(version.major, version.minor, version.patch),
		}, "\n")
		require("snacks").setup(opts)

		-- Toggle keymaps — :map() wires which-key icon/color integration.
		-- <leader>u prefix; avoids uo/uc/un/ut/ui/us (taken by debuggers).
		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.line_number():map("<leader>ul")
		Snacks.toggle.inlay_hints():map("<leader>uI")
		Snacks.toggle.treesitter():map("<leader>uT")
		Snacks.toggle.words():map("<leader>uw")
		Snacks.toggle.scroll():map("<leader>uS")
		Snacks.toggle.indent():map("<leader>ug")
	end,

	-- ── keys ─────────────────────────────────────────────────────────────
	keys = require("ls-devs.plugins.system.snacks.keys"),
}
