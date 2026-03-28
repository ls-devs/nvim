---@diagnostic disable: undefined-global
-- ── utils/custom_functions ───────────────────────────────────────────────
-- Purpose : Shared utility functions used across plugin specs and keymaps.
-- Trigger : Required on-demand by plugin configs (not loaded at startup)
-- Provides: HelpGrep, CustomHover, OpenURLs, OrigamiHLFolds,
--           GhSwitch, KeymapsList, AutocmdsList, CommandsList, HighlightsList,
--           DapChromeDebug, DapNodeDebug
-- ─────────────────────────────────────────────────────────────────────────
---@class LsDevsUtils
local M = {}

-- ── Snacks picker item types ─────────────────────────────────────────────
---@alias SnacksPickerHighlight {[1]: string, [2]: string|nil}

---@class SnacksPickerKeymapItem
---@field idx integer
---@field score integer
---@field text string
---@field _mode string
---@field _lhs string
---@field _desc string
---@field _local boolean

---@class SnacksPickerAutocmdItem
---@field idx integer
---@field score integer
---@field text string
---@field _event string
---@field _pattern string
---@field _group string
---@field _desc string
---@field _is_cmd boolean
---@field _buflocal boolean

---@class SnacksPickerCommandItem
---@field idx integer
---@field score integer
---@field text string
---@field _name string
---@field _nargs string
---@field _desc string
---@field _def string
---@field _local boolean

---@class SnacksPickerHighlightItem
---@field idx integer
---@field score integer
---@field text string
---@field _name string
--- Opens a `:helpgrep` prompt and displays matching help topics in a new tab.
--- The quickfix list is opened automatically when results are found.
--- Returns silently if the user cancels or provides an empty input.
---@return nil
M.HelpGrep = function()
	---@param help_cmd string
	---@param topic string
	local open_help_tab = function(help_cmd, topic)
		vim.cmd.tabe()
		local winnr = vim.api.nvim_get_current_win()
		vim.cmd("silent! " .. help_cmd .. " " .. topic)
		vim.api.nvim_win_close(winnr, false)
	end

	vim.ui.input({ prompt = "Grep help for: " }, function(input)
		if input == "" or not input then
			return
		end
		open_help_tab("helpgrep", input)
		if #vim.fn.getqflist() > 0 then
			return vim.cmd.copen()
		end
	end)
end

--- Opens `url` in the default system browser using the platform-appropriate command:
--- `open` (macOS), `wslview` (WSL), `xdg-open` (Linux), or `start` (Windows).
---@param url string The URL to open
M.OpenURLs = function(url)
	local opener
	if vim.fn.has("macunix") == 1 then
		opener = "open"
	elseif vim.fn.has("wsl") == 1 then
		opener = "wslview"
	elseif vim.fn.has("linux") == 1 and vim.fn.has("wsl") == 0 then
		opener = "xdg-open"
	elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
		opener = "start"
	end
	local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
	vim.fn.system(openCommand)
end

--- Peek a folded line under the cursor (UFO) or show LSP hover via Lspsaga.
--- On a closed fold, opens a preview float; otherwise delegates to hover_doc.
---@return nil
M.CustomHover = function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.cmd("Lspsaga hover_doc")
	end
end

--- Returns fold-aware `h` and `l` motion functions (logic adapted from nvim-origami).
---
--- `h` behaviour (per repeat when a count is given):
---   - cursor past first non-blank col   : normal `h`
---   - cursor at first non-blank col, fold open : close the fold with `zc`
---   - cursor at col 0, inside a fold    : jump to first non-blank of the line above (`k^`)
---   - cursor at col 0, no fold          : normal `h`
---
--- `l` behaviour (per repeat when a count is given):
---   - cursor on a closed fold           : open the fold with `zo`
---   - cursor at end-of-line, in a fold  : jump to first non-blank of the line below (`j^`)
---   - otherwise                         : normal `l`
---
--- Both honour `vim.v.count1` so count-prefixed motions (e.g. `3h`, `5l`) work correctly.
---@return fun() h
---@return fun() l
-- h/l folds from nvim-origami as custom functions
M.OrigamiHLFolds = function()
	-- helper
	---@param cmdStr string
	local function normal(cmdStr)
		vim.cmd.normal({ cmdStr, bang = true })
	end

	-- `h` closes folds when at or before the first non-blank character of a line.
	-- Pressing h anywhere before the first char triggers fold-close, not cursor movement.
	local h = function()
		local count = vim.v.count1
		for _ = 1, count, 1 do
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local line = vim.api.nvim_get_current_line()
			local first_char_col = (line:find("%S") or 1) - 1 -- 0-indexed

			if col <= first_char_col then
				local foldclosed = vim.fn.foldclosed(".")
				if foldclosed > -1 then
					-- cursor on a closed fold: normal h
					normal("h")
				else
					local foldlevel = vim.fn.foldlevel(".")
					if foldlevel > 0 then
						-- inside an open fold at/before first char: close it
						local ok = pcall(normal, "zc")
						if not ok then
							normal("h")
						end
					else
						normal("h")
					end
				end
			else
				normal("h")
			end
		end
	end

	-- `l` on a folded line opens the fold.
	-- When inside a fold and at end of line, jumps to first non-blank of the line below.
	local l = function()
		local count = vim.v.count1
		for _ = 1, count, 1 do
			local foldclosed = vim.fn.foldclosed(".")
			if foldclosed > -1 then
				pcall(normal, "zo")
			else
				local col = vim.api.nvim_win_get_cursor(0)[2]
				local line = vim.api.nvim_get_current_line()
				if col >= #line - 1 then
					local foldlevel = vim.fn.foldlevel(".")
					if foldlevel > 0 then
						normal("j^")
					else
						pcall(normal, "l")
					end
				else
					pcall(normal, "l")
				end
			end
		end
	end
	return h, l
end

--- Switch or add GitHub accounts using a Snacks picker.
--- Parses `gh auth status` to list logged-in accounts, marks the active one,
--- and appends an "Add new account" entry that opens an interactive terminal.
--- On account selection, runs `gh auth switch -u <username>` and notifies.
---@return nil
M.GhSwitch = function()
	local output = vim.fn.system("gh auth status 2>&1")
	local accounts = {}
	local current_user = nil

	for line in output:gmatch("[^\n]+") do
		local user = line:match("%s+account%s+(%S+)")
		if user then
			current_user = user
		elseif line:match("Active account: true") and current_user then
			table.insert(accounts, { name = current_user, active = true })
			current_user = nil
		elseif line:match("Active account: false") and current_user then
			table.insert(accounts, { name = current_user, active = false })
			current_user = nil
		end
	end

	local items = {}
	for i, acc in ipairs(accounts) do
		items[i] = { idx = i, score = 0, text = acc.name, _active = acc.active, _name = acc.name }
	end
	table.insert(items, { idx = #items + 1, score = 0, text = "Add new account", _new = true })

	Snacks.picker.pick({
		title = " 󰊤  GitHub Auth",
		items = items,
		format = function(item)
			if item._new then
				return { { "  Add new account", "SnacksPickerSpecial" } }
			end
			if item._active then
				return {
					{ " 󰀄  " .. item._name, "SnacksPickerLabel" },
					{ "  active", "SnacksPickerComment" },
				}
			end
			return { { " 󰀄  " .. item._name, "SnacksPickerFile" } }
		end,
		confirm = function(picker, item)
			picker:close()
			if item._new then
				Snacks.terminal.open("gh auth login", {
					win = {
						position = "float",
						border = "rounded",
						width = 0.5,
						height = 0.4,
						title = " 󰊤  gh auth login ",
						title_pos = "left",
					},
				})
			elseif item._active then
				Snacks.notify("Already active: " .. item._name, { level = vim.log.levels.INFO, title = "GitHub Auth" })
			else
				vim.fn.system("gh auth switch -u " .. item._name)
				Snacks.notify("Switched to " .. item._name, { level = vim.log.levels.INFO, title = "GitHub Auth" })
			end
		end,
	})
end

--- Browse all described keybindings via a compact single-pane Snacks picker.
--- Collects global keymaps and current-buffer-local keymaps for all modes,
--- deduplicates (buffer-local wins), and presents them in a centered float.
--- Format: key(22)  description(45)  mode  [buf]
--- Sort priority: <leader> non-local → other non-local → buffer-local (plugin noise last).
--- Confirm feeds the selected key back to Neovim so it executes immediately.
---@return nil
M.KeymapsList = function()
	local modes = { "n", "v", "x", "i", "c", "t", "o", "s" }
	local items = {}
	local seen = {}

	local function collect(kms, is_local)
		for _, km in ipairs(kms) do
			if km.desc and km.desc ~= "" then
				local id = km.mode .. "|" .. km.lhs
				if not seen[id] then
					seen[id] = true
					table.insert(items, {
						idx = 0,
						score = 0,
						text = km.desc .. " " .. km.lhs .. " " .. km.mode,
						_mode = km.mode,
						_lhs = km.lhs,
						_desc = km.desc,
						_local = is_local,
					})
				end
			end
		end
	end

	for _, mode in ipairs(modes) do
		-- buffer-local first: they shadow globals with the same lhs
		collect(vim.api.nvim_buf_get_keymap(0, mode), true)
		collect(vim.api.nvim_get_keymap(mode), false)
	end

	-- 0 = user <leader> maps, 1 = other global maps, 2 = buffer-local (plugin noise)
	local function priority(item)
		if not item._local and item._lhs:lower():match("^<leader>") then
			return 0
		elseif not item._local then
			return 1
		else
			return 2
		end
	end

	table.sort(items, function(a, b)
		local pa, pb = priority(a), priority(b)
		if pa ~= pb then
			return pa < pb
		end
		return a._lhs:lower() < b._lhs:lower()
	end)
	for i, v in ipairs(items) do
		v.idx = i
	end

	local mode_hl = {
		n = "SnacksPickerKeymapMode",
		v = "Title",
		x = "Title",
		i = "Function",
		c = "Keyword",
		t = "SnacksPickerSpecial",
		o = "DiagnosticWarn",
		s = "DiagnosticInfo",
	}

	Snacks.picker.pick({
		title = "   Keybindings",
		items = items,
		layout = {
			reverse = true,
			layout = {
				box = "vertical",
				width = 0.60,
				height = 0.75,
				border = "rounded",
				title = "   Keybindings ",
				title_pos = "center",
				{ win = "list", border = "none" },
				{ win = "input", height = 1, border = "top" },
			},
		},
		---@param item SnacksPickerKeymapItem
		---@return SnacksPickerHighlight[]
		format = function(item)
			local a = Snacks.picker.util.align
			local lhs = Snacks.util.normkey(item._lhs)
			-- normkey expands <leader> to the raw char or to "<Space>" notation;
			-- replace both back to the readable <leader> token
			local leader = vim.g.mapleader or "\\"
			lhs = lhs:gsub("^" .. vim.pesc(leader), "<leader>")
			lhs = lhs:gsub("^<[Ss]pace>", "<leader>")
			return {
				{ a(lhs, 22), "SnacksPickerKeymapLhs" },
				{ "  " },
				{ item._mode, mode_hl[item._mode] or "SnacksPickerKeymapMode" },
				{ item._local and " buf" or "    ", item._local and "SnacksPickerBufNr" or nil },
				{ "  " },
				{ item._desc, "Normal" },
			}
		end,
		confirm = function(picker, item)
			picker:close()
			vim.schedule(function()
				local key = vim.api.nvim_replace_termcodes(item._lhs, true, false, true)
				vim.api.nvim_feedkeys(key, "m", false)
			end)
		end,
	})
end

--- Browse all autocommands in a compact single-pane Snacks picker.
--- Sorted by event name. Buffer-local entries are marked with a "b" badge.
--- Format: event(22)  [b] description/command(45)  pattern(18)  group
--- Confirm closes the picker (purely informational).
---@return nil
M.AutocmdsList = function()
	local raw = vim.api.nvim_get_autocmds({})
	local items = {}

	for i, au in ipairs(raw) do
		local desc = (au.desc and au.desc ~= "") and au.desc
			or (au.command and au.command ~= "") and au.command
			or "‹callback›"
		items[i] = {
			idx = i,
			score = 0,
			text = au.event .. " " .. (au.pattern or "") .. " " .. desc .. " " .. tostring(au.group_name or ""),
			_event = au.event,
			_pattern = au.pattern or "*",
			_group = tostring(au.group_name or ""),
			_desc = desc,
			_is_cmd = au.command and au.command ~= "",
			_buflocal = au.buflocal,
		}
	end

	table.sort(items, function(a, b)
		return a._event < b._event
	end)
	for i, v in ipairs(items) do
		v.idx = i
	end

	Snacks.picker.pick({
		title = "   Autocommands",
		items = items,
		layout = {
			reverse = true,
			layout = {
				box = "vertical",
				width = 0.75,
				height = 0.75,
				border = "rounded",
				title = "   Autocommands ",
				title_pos = "center",
				{ win = "list", border = "none" },
				{ win = "input", height = 1, border = "top" },
			},
		},
		---@param item SnacksPickerAutocmdItem
		---@return SnacksPickerHighlight[]
		format = function(item)
			local a = Snacks.picker.util.align
			return {
				{ a(item._event, 22), "SnacksPickerAuEvent" },
				{ "  " },
				{ item._buflocal and "b " or "  ", item._buflocal and "SnacksPickerBufNr" or nil },
				{ a(item._desc, 45), item._is_cmd and "SnacksPickerComment" or "Normal" },
				{ "  " },
				{ a(item._pattern, 18), "SnacksPickerAuPattern" },
				{ "  " },
				{ item._group, "SnacksPickerAuGroup" },
			}
		end,
		confirm = function(picker, _)
			picker:close()
		end,
	})
end

--- Browse all user-defined commands in a compact single-pane Snacks picker.
--- Includes buffer-local commands (marked "b") which shadow globals with the same name.
--- Format: [b] :CommandName  nargs-badge  description/definition
--- Confirm feeds `:CommandName ` to the command line so it can be invoked immediately.
---@return nil
M.CommandsList = function()
	local items = {}
	local seen = {}

	local nargs_label = { ["0"] = "no-args", ["1"] = "1-arg ", ["*"] = "n-args", ["?"] = "opt   ", ["+"] = "1+args" }
	local nargs_hl = {
		["0"] = "NonText",
		["1"] = "SnacksPickerSpecial",
		["*"] = "Function",
		["?"] = "DiagnosticHint",
		["+"] = "DiagnosticWarn",
	}

	local function collect(cmds, is_local)
		for name, cmd in pairs(cmds) do
			if not seen[name] then
				seen[name] = true
				local desc = (cmd.desc and cmd.desc ~= "") and cmd.desc or ""
				table.insert(items, {
					idx = 0,
					score = 0,
					text = name .. " " .. desc,
					_name = name,
					_nargs = cmd.nargs or "0",
					_desc = desc,
					_def = (cmd.definition and cmd.definition ~= "" and cmd.definition ~= "completion") and cmd.definition or "",
					_local = is_local,
				})
			end
		end
	end

	collect(vim.api.nvim_buf_get_commands(0, {}), true)
	collect(vim.api.nvim_get_commands({}), false)

	table.sort(items, function(a, b)
		return a._name < b._name
	end)
	for i, v in ipairs(items) do
		v.idx = i
	end

	Snacks.picker.pick({
		title = "   Commands",
		items = items,
		layout = {
			reverse = true,
			layout = {
				box = "vertical",
				width = 0.60,
				height = 0.75,
				border = "rounded",
				title = "   Commands ",
				title_pos = "center",
				{ win = "list", border = "none" },
				{ win = "input", height = 1, border = "top" },
			},
		},
		---@param item SnacksPickerCommandItem
		---@return SnacksPickerHighlight[]
		format = function(item)
			local a = Snacks.picker.util.align
			local n = item._nargs
			return {
				{ item._local and "b " or "  ", item._local and "SnacksPickerBufNr" or nil },
				{ a(":" .. item._name, 30), "SnacksPickerCmd" },
				{ "  " },
				{ a(nargs_label[n] or n, 6), nargs_hl[n] or "NonText" },
				{ "  " },
				{ item._desc ~= "" and item._desc or item._def, item._desc ~= "" and "Normal" or "NonText" },
			}
		end,
		confirm = function(picker, item)
			picker:close()
			vim.schedule(function()
				vim.api.nvim_feedkeys(":" .. item._name .. " ", "n", false)
			end)
		end,
	})
end

--- Browse all highlight groups in a compact single-pane Snacks picker.
--- Each group name is rendered using its own highlight so you see the style at a glance.
--- Confirm copies the group name to the system clipboard.
---@return nil
M.HighlightsList = function()
	local groups = vim.fn.getcompletion("", "highlight")
	local items = {}

	for i, name in ipairs(groups) do
		items[i] = { idx = i, score = 0, text = name, _name = name }
	end

	Snacks.picker.pick({
		title = "   Highlights",
		items = items,
		layout = {
			reverse = true,
			layout = {
				box = "vertical",
				width = 0.45,
				height = 0.75,
				border = "rounded",
				title = "   Highlights ",
				title_pos = "center",
				{ win = "list", border = "none" },
				{ win = "input", height = 1, border = "top" },
			},
		},
		---@param item SnacksPickerHighlightItem
		---@return SnacksPickerHighlight[]
		format = function(item)
			-- Render name with its own hl group — instant visual preview of the style
			return { { item._name, item._name } }
		end,
		confirm = function(picker, item)
			picker:close()
			vim.fn.setreg("+", item._name)
			Snacks.notify("Copied: " .. item._name, { level = vim.log.levels.INFO, title = "Highlights" })
		end,
	})
end

-- ── DAP shared helpers ───────────────────────────────────────────────────

--- Walk up from start_dir to find the nearest directory containing a package.json.
--- This makes DAP project-aware in monorepos / multi-project workspaces:
--- editing admin-ui/src/App.tsx  → finds admin-ui/package.json
--- editing src/backoffice/x.ts   → finds GSF_Backbone_Node/package.json
---@param start_dir string absolute path to start from
---@return string pkg_path, string project_root
local function find_pkg_root(start_dir)
	local dir = start_dir
	local prev = nil
	while dir ~= prev do
		local pkg = dir .. "/package.json"
		if vim.fn.filereadable(pkg) == 1 then
			return pkg, dir
		end
		prev = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	-- Nothing found walking up — fall back to cwd
	local cwd = vim.fn.getcwd()
	return cwd .. "/package.json", cwd
end

-- ── DAP Arc Debug (WSL) ──────────────────────────────────────────────────
--
-- Arc is packaged as MSIX: when you launch it normally while Arc is already
-- running, Windows routes the activation to the existing instance (ignoring
-- any CLI args like --remote-debugging-port). To work around this we kill
-- all Arc processes first, then start a fresh instance with the debug flags.
--
-- Workflow:
--   1. Prompt for the URL to debug
--   2. If CDP port 9222 is already open → attach directly (Arc already in debug mode)
--   3. If Arc is running → kill it, wait 1s, then launch fresh debug instance
--   4. If Arc not running → launch fresh debug instance
--   5. Poll port 9222 up to 20s, then attach pwa-chrome DAP
-- ─────────────────────────────────────────────────────────────────────────
---@param preset_url? string       When provided, skip the URL input prompt (used by DapNodeDebug)
---@param web_root_override? string  Explicit webRoot for the Chrome DAP session; falls back to nearest package.json root
---@return nil
M.DapChromeDebug = function(preset_url, web_root_override)
	local dap = require("dap")
	local cdp_port = 9222
	local relay_port = 9223

	-- WSL2 networking: Arc's CDP binds to Windows 127.0.0.1 which is unreachable
	-- from WSL2 NAT mode directly (localhostForwarding is broken when Docker Desktop is running).
	-- In NAT mode the Windows host is reachable via the WSL2 gateway (always 172.x.x.x).
	-- In mirrored networking mode the nameserver in /etc/resolv.conf is the home router
	-- (e.g. 192.168.x.x), NOT the Windows host; use 127.0.0.1 instead (works in mirrored mode).
	local ns = vim.fn.system("awk '/nameserver/{print $2; exit}' /etc/resolv.conf"):gsub("[\r\n]+$", "")
	local windows_host = (ns ~= "" and ns:match("^172%.")) and ns or "127.0.0.1"

	-- Resolve Arc's real MSIX executable via Get-AppxPackage.
	-- Works whether Arc was installed via Windows Store or their standalone setup .exe.
	local arc_install = vim.fn
		.system(
			"powershell.exe -NoProfile -c \"(Get-AppxPackage -Name 'TheBrowserCompany.Arc' | Select-Object -First 1 -ExpandProperty InstallLocation)\" 2>/dev/null"
		)
		:gsub("[\r\n]+$", "")
	local arc_win = arc_install .. "\\Arc.exe"
	local arc_wsl = arc_install
		:gsub("^(%a):\\", function(d)
			return "/mnt/" .. d:lower() .. "/"
		end)
		:gsub("\\", "/") .. "/Arc.exe"

	---@return boolean
	local function cdp_ready()
		-- Arc CDP binds to Windows 127.0.0.1:cdp_port (unreachable from WSL2 directly).
		-- The relay forwards 0.0.0.0:relay_port → 127.0.0.1:cdp_port on Windows,
		-- making it reachable as windows_host:relay_port from WSL.
		local r =
			vim.fn.system(string.format("curl -sf --max-time 1 http://%s:%d/json/version 2>/dev/null", windows_host, relay_port))
		return r ~= "" and r:match("Browser") ~= nil
	end

	---@return boolean
	local function arc_running()
		local r = vim.fn
			.system(
				'powershell.exe -NoProfile -c "(Get-Process -Name Arc -ErrorAction SilentlyContinue | Measure-Object).Count" 2>/dev/null'
			)
			:gsub("[\r\n]+$", "")
		return tonumber(r) ~= nil and tonumber(r) > 0
	end

	---@param max_ms integer
	---@param cb fun(ok: boolean)
	local function wait_for_cdp(max_ms, cb)
		local elapsed = 0
		local interval = 400
		local function poll()
			if cdp_ready() then
				cb(true)
			elseif elapsed >= max_ms then
				cb(false)
			else
				elapsed = elapsed + interval
				vim.defer_fn(poll, interval)
			end
		end
		poll()
	end

	---@param url string
	local function attach(url)
		local web_root
		if web_root_override then
			web_root = web_root_override
		else
			local _, wr = find_pkg_root(vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h"))
			web_root = wr
		end
		dap.run({
			type = "pwa-chrome",
			request = "attach",
			name = "Arc (WSL relay)",
			address = windows_host,
			port = relay_port,
			webRoot = web_root,
			sourceMaps = true,
			protocol = "inspector",
			urlFilter = url:match("^(https?://[^/]+)") .. "*",
		})
	end

	---@param url string
	local function launch_arc(url)
		-- Arc (MSIX): direct exe invocation strips CLI args through activation.
		-- Fix: embed args in a .lnk shortcut opened via ShellExecute.
		--
		-- WSL2 networking: Arc CDP binds to Windows 127.0.0.1:cdp_port — unreachable
		-- from WSL. A Windows-side .NET relay forwards 0.0.0.0:relay_port → 127.0.0.1:cdp_port.
		--
		-- Key design: the relay PS1 is written to %TEMP% from inside the launch PS1,
		-- NOT passed as a UNC path (\\wsl.localhost\...) to a hidden child process.
		-- Windows blocks UNC-path script execution in hidden processes even with -ExecutionPolicy Bypass.
		-- Add-Type C# compilation takes 5-15s, so we wait up to 30s.
		-- We also try to add a Windows Firewall rule for port relay_port (silently; may need elevation).

		-- Single launch PS1 that self-contains the relay source, writes it to %TEMP%, and runs it.
		-- [=[ ... ]=] avoids conflicts with ]] inside C# and '@ inside PowerShell here-strings.
		local launch_template = [=[
# Write relay to Windows temp so it runs from a proper local path (UNC blocked in hidden procs)
$relayPath = "$env:TEMP\arc-cdp-relay.ps1"
Set-Content -Path $relayPath -Encoding UTF8 -Value @'
Add-Type @"
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;
public class ArcCdpRelay {
    public static void Start(int listenPort, string targetHost, int targetPort) {
        var listener = new TcpListener(IPAddress.Any, listenPort);
        listener.Start();
        while (true) {
            var client = listener.AcceptTcpClient();
            ThreadPool.QueueUserWorkItem(_ => {
                TcpClient remote = null;
                try {
                    remote = new TcpClient(targetHost, targetPort);
                    var cin = client.GetStream();
                    var rin = remote.GetStream();
                    var done = new System.Threading.ManualResetEventSlim(false);
                    ThreadPool.QueueUserWorkItem(__ => {
                        try { byte[] b = new byte[65536]; int n; while ((n = cin.Read(b, 0, b.Length)) > 0) rin.Write(b, 0, n); } catch {}
                        done.Set();
                    });
                    try { byte[] b = new byte[65536]; int n; while ((n = rin.Read(b, 0, b.Length)) > 0) cin.Write(b, 0, n); } catch {}
                    done.Wait(300000);
                } catch {}
                finally {
                    try { client.Close(); } catch {}
                    try { if (remote != null) remote.Close(); } catch {}
                }
            });
        }
    }
}
"@
[ArcCdpRelay]::Start(RELAY_PORT, "127.0.0.1", CDP_PORT)
'@

# Firewall rule for relay port (silently — may require elevation)
$null = & netsh advfirewall firewall delete rule name="DAP CDP Relay RELAY_PORT" 2>$null
$null = & netsh advfirewall firewall add rule name="DAP CDP Relay RELAY_PORT" dir=in action=allow protocol=TCP localport=RELAY_PORT profile=any 2>$null

# Check if relay already running; if not, start it and wait up to 30s (Add-Type needs ~10-15s)
$relayRunning = $false
try { $t = [System.Net.Sockets.TcpClient]::new(); $t.Connect("127.0.0.1", RELAY_PORT); $t.Close(); $relayRunning = $true } catch {}
if (-not $relayRunning) {
    Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-NoProfile","-ExecutionPolicy","Bypass","-File",$relayPath
    $waited = 0
    while ($waited -lt 30000) {
        Start-Sleep -Milliseconds 500
        $waited += 500
        try { $t = [System.Net.Sockets.TcpClient]::new(); $t.Connect("127.0.0.1", RELAY_PORT); $t.Close(); break } catch {}
    }
}

Get-Process -Name "Arc" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 1200
$sh = New-Object -COM WScript.Shell
$lnk = $sh.CreateShortcut("$env:TEMP\arc-debug.lnk")
$lnk.TargetPath = "ARC_EXE"
$lnk.Arguments = "--remote-debugging-port=CDP_PORT --no-first-run `"--user-data-dir=$env:TEMP\dap-arc-CDP_PORT`" `"DEBUG_URL`""
$lnk.Save()
Start-Process "$env:TEMP\arc-debug.lnk"
]=]
		-- Use function form in gsub replacements so \ and % in paths are taken literally.
		local launch_content = launch_template
			:gsub("RELAY_PORT", tostring(relay_port))
			:gsub("ARC_EXE", function()
				return arc_win
			end)
			:gsub("CDP_PORT", tostring(cdp_port))
			:gsub("DEBUG_URL", function()
				return url
			end)

		local launch_path = "/tmp/dap-arc-launch.ps1"
		local lf = io.open(launch_path, "w")
		if not lf then
			vim.notify("[DAP] Cannot write launch script to " .. launch_path, vim.log.levels.ERROR)
			return
		end
		lf:write(launch_content)
		lf:close()
		local launch_win = vim.fn.system("wslpath -w " .. launch_path):gsub("[\r\n]+$", "")
		vim.fn.jobstart({ "powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", launch_win })
	end

	---@param url string
	local function proceed(url)
		if cdp_ready() then
			vim.notify("[DAP] CDP port " .. cdp_port .. " already open, attaching…", vim.log.levels.INFO)
			attach(url)
			return
		end

		if vim.fn.filereadable(arc_wsl) == 0 then
			vim.notify("[DAP] Arc not found.\nResolved path: " .. arc_wsl .. "\nCheck Arc installation.", vim.log.levels.ERROR)
			return
		end

		local was_running = arc_running()
		if was_running then
			vim.notify(
				"[DAP] Killing Arc and relaunching with --remote-debugging-port=" .. cdp_port .. "…",
				vim.log.levels.INFO
			)
		else
			vim.notify("[DAP] Launching Arc with remote debugging…", vim.log.levels.INFO)
		end

		launch_arc(url)
		wait_for_cdp(40000, function(ok)
			if ok then
				attach(url)
			else
				vim.notify(
					string.format(
						"[DAP] Arc CDP relay not ready after 40s (checked %s:%d).\n\n"
							.. "The relay (arc-cdp-relay.ps1) may have failed to start.\n"
							.. "Check: open Windows PowerShell and run:\n"
							.. "  Test-NetConnection 127.0.0.1 -Port %d\n\n"
							.. "If relay is missing, copy %%TEMP%%\\arc-cdp-relay.ps1 and run it manually.\n"
							.. "Then press <leader>dC again.",
						windows_host,
						relay_port,
						relay_port
					),
					vim.log.levels.ERROR
				)
			end
		end)
	end

	if preset_url then
		proceed(preset_url)
	else
		vim.ui.input({ prompt = "Debug URL: ", default = "http://localhost:3000" }, function(url)
			if not url or url == "" then
				return
			end
			proceed(url)
		end)
	end
end

-- ── DAP Node Debug (WSL / Linux) ─────────────────────────────────────────
-- Monorepo-aware debug launcher. Discovers the nearest package.json and all
-- sibling workspace packages (npm/yarn workspaces, lerna, pnpm, or a generic
-- shallow scan of the git root's children).  Supports:
--
--   Backend:   ts-node / tsx / ts-node-esm scripts  → pwa-node attach
--   Frontend:  vite / next / react-scripts / nuxt   → pwa-chrome attach
--   Full Stack: launch backend + attach frontend in one action,
--               including cross-package (e.g. backend in `source`,
--               frontend in `admin-ui`)
--
-- Package-manager aware: auto-detects npm / yarn / pnpm / bun.
-- Usage: <leader>dN
-- ─────────────────────────────────────────────────────────────────────────

--- Find the workspace/monorepo root above a package root.
--- Stops at the first dir containing: lerna.json, pnpm-workspace.yaml,
--- turbo.json, a package.json with "workspaces", or a .git directory.
---@param pkg_root string  directory containing the nearest package.json
---@return string  workspace root (equals pkg_root for single-package repos)
local function find_workspace_root(pkg_root)
	local dir = vim.fn.fnamemodify(pkg_root, ":h")
	local prev = nil
	while dir ~= prev do
		if
			vim.fn.filereadable(dir .. "/lerna.json") == 1
			or vim.fn.filereadable(dir .. "/pnpm-workspace.yaml") == 1
			or vim.fn.filereadable(dir .. "/turbo.json") == 1
		then
			return dir
		end
		local p = dir .. "/package.json"
		if vim.fn.filereadable(p) == 1 then
			local ok, decoded = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(p), "\n"))
			if ok and decoded and decoded.workspaces then
				return dir
			end
		end
		if vim.fn.isdirectory(dir .. "/.git") == 1 then
			return dir
		end
		prev = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	return pkg_root
end

--- Collect all package roots found within a workspace root.
--- Handles: npm/yarn workspaces field, lerna.json, pnpm-workspace.yaml, and
--- a generic shallow scan of direct children for non-standard monorepos.
---@param workspace_root string
---@param current_pkg_root string  always included even if not in workspace globs
---@return string[]
local function workspace_packages(workspace_root, current_pkg_root)
	local result = {}
	local seen = {}

	local function add(dir)
		dir = vim.fn.resolve(dir)
		if seen[dir] or vim.fn.isdirectory(dir) ~= 1 or vim.fn.filereadable(dir .. "/package.json") ~= 1 then
			return
		end
		seen[dir] = true
		table.insert(result, dir)
	end

	local function expand(patterns)
		for _, pat in ipairs(patterns) do
			for _, d in ipairs(vim.fn.glob(workspace_root .. "/" .. pat, false, true)) do
				add(d)
			end
		end
	end

	-- npm / yarn workspaces field
	local root_pkg = workspace_root .. "/package.json"
	if vim.fn.filereadable(root_pkg) == 1 then
		local ok, p = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(root_pkg), "\n"))
		if ok and p and p.workspaces then
			local ws = (type(p.workspaces) == "table" and not p.workspaces[1]) and (p.workspaces.packages or {}) or p.workspaces
			expand(ws)
		end
	end

	-- lerna.json
	local lerna_path = workspace_root .. "/lerna.json"
	if vim.fn.filereadable(lerna_path) == 1 then
		local ok, lj = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(lerna_path), "\n"))
		if ok and lj then
			expand(lj.packages or { "packages/*" })
		end
	end

	-- pnpm-workspace.yaml (minimal parse — extract patterns after "- ")
	local pnpm_path = workspace_root .. "/pnpm-workspace.yaml"
	if vim.fn.filereadable(pnpm_path) == 1 then
		local pats = {}
		for _, line in ipairs(vim.fn.readfile(pnpm_path)) do
			local pat = line:match("^%s*%-+%s*['\"]?([^'\"#%s]+)['\"]?")
			if pat then
				table.insert(pats, pat)
			end
		end
		expand(pats)
	end

	-- Generic shallow scan: direct children of workspace root with package.json.
	-- Covers non-standard monorepos where packages live directly at the repo root.
	if workspace_root ~= current_pkg_root then
		for _, d in ipairs(vim.fn.glob(workspace_root .. "/*", false, true)) do
			if
				vim.fn.isdirectory(d) == 1
				and not d:match("[/\\]node_modules$")
				and not d:match("[/\\]%.git$")
				and not d:match("[/\\]%.")
			then
				add(d)
			end
		end
	end

	-- Always include the buffer's own package root
	add(current_pkg_root)
	return result
end

--- Detect the package manager in use for a project directory.
---@param dir string
---@return string  "npm" | "yarn" | "pnpm" | "bun"
local function detect_pkg_manager(dir)
	if vim.fn.filereadable(dir .. "/pnpm-lock.yaml") == 1 then
		return "pnpm"
	end
	if vim.fn.filereadable(dir .. "/yarn.lock") == 1 then
		return "yarn"
	end
	if vim.fn.filereadable(dir .. "/bun.lockb") == 1 or vim.fn.filereadable(dir .. "/bun.lock") == 1 then
		return "bun"
	end
	return "npm"
end

-- { pattern, default_port } — matched against the script command string
-- { cmd_pattern, default_port } — matched against the script command string
local FRONTEND_PATTERNS = {
	{ "vite", 5173 },
	{ "next dev", 3000 },
	{ "react%-scripts start", 3000 },
	{ "nuxt dev", 3000 },
	{ "webpack.*serve", 3000 },
	{ "astro dev", 4321 },
	{ "ng serve", 4200 }, -- Angular CLI
	{ "svelte%-kit dev", 5173 }, -- SvelteKit
	{ "kit dev", 5173 }, -- SvelteKit (newer package name)
	{ "remix dev", 3000 }, -- Remix
	{ "gatsby develop", 8000 }, -- Gatsby
	{ "parcel", 1234 }, -- Parcel bundler
	{ "storybook dev", 6006 }, -- Storybook (new CLI)
	{ "start%-storybook", 6006 }, -- Storybook (old CLI)
	{ "expo start", 8081 }, -- Expo / React Native
	{ "solid%-start dev", 3000 }, -- SolidStart
	{ "qwik dev", 5173 }, -- Qwik
	{ "http%-server", 8080 }, -- generic http-server
	{ "serve", 3000 }, -- serve package
}

-- Script names treated as "server" processes when no cmd pattern matches.
-- These are run as plain background jobs (no --inspect-brk) so they still
-- appear in the picker and can act as the backend half of Full Stack.
---@diagnostic disable-next-line: unused-local
local SERVER_NAMES = {
	"^start$",
	"^serve$",
	"^server$",
	"^api$",
	"^backend$",
	"^watch$",
	"dev:server",
	"dev:api",
	"dev:back",
	"dev:be",
	"start:server",
	"start:api",
}

---@param project_root string
---@return integer|nil
local function vite_config_port(project_root)
	for _, cfg in ipairs({ "vite.config.ts", "vite.config.js", "vite.config.mts" }) do
		local path = project_root .. "/" .. cfg
		if vim.fn.filereadable(path) == 1 then
			local p = table.concat(vim.fn.readfile(path), "\n"):match("port%s*:%s*(%d+)")
			if p then
				return tonumber(p)
			end
		end
	end
end

--- Build debuggable entries for a single package.json.
---@param pkg_path string  absolute path to package.json
---@param pkg_root string  directory containing package.json
---@return table[]
local function entries_for_package(pkg_path, pkg_root)
	local ok, pkg = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(pkg_path), "\n"))
	if not ok or not pkg then
		return {}
	end
	local pkg_name = (pkg.name and pkg.name ~= "") and pkg.name or vim.fn.fnamemodify(pkg_root, ":t")
	local pkg_manager = detect_pkg_manager(pkg_root)
	local entries = {}
	for name, cmd in pairs(pkg.scripts or {}) do
		-- Backend: ts-node / tsx / ts-node-esm
		local file = cmd:match("ts%-node%s+([%w%./%-%_]+%.ts)")
			or cmd:match("tsx%s+([%w%./%-%_]+%.ts)")
			or cmd:match("ts%-node%-esm%s+([%w%./%-%_]+%.ts)")
		if file then
			table.insert(entries, {
				name = name,
				kind = "backend",
				file = file,
				cwd = pkg_root,
				pkg_name = pkg_name,
				pkg_manager = pkg_manager,
			})
		else
			-- Frontend: vite / next / react-scripts / nuxt / etc.
			for _, pat in ipairs(FRONTEND_PATTERNS) do
				if cmd:match(pat[1]) then
					local port = (pat[1] == "vite" and vite_config_port(pkg_root)) or pat[2]
					table.insert(entries, {
						name = name,
						kind = "frontend",
						script = name,
						port = port,
						cwd = pkg_root,
						pkg_name = pkg_name,
						pkg_manager = pkg_manager,
					})
					break
				end
			end
		end
	end
	return entries
end

---@alias NodeEntry
---| { name:string, kind:"backend",   file:string,   cwd:string, pkg_name:string, pkg_manager:string }
---| { name:string, kind:"frontend",  script:string, port:integer, cwd:string, pkg_name:string, pkg_manager:string }
---| { name:string, kind:"fullstack", backend:table, frontend:table }

---@return nil
M.DapNodeDebug = function()
	local dap = require("dap")
	local inspect_port = 9229

	local buf_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
	local pkg_path, project_root = find_pkg_root(buf_dir)

	if vim.fn.filereadable(pkg_path) == 0 then
		vim.notify("[DAP] No package.json found (searched from " .. buf_dir .. ")", vim.log.levels.WARN)
		return
	end

	-- Discover all sibling packages in the workspace / monorepo
	local workspace_root = find_workspace_root(project_root)
	local pkg_roots = workspace_packages(workspace_root, project_root)

	---@type NodeEntry[]
	local all_entries = {}
	local all_backends = {}
	local all_frontends = {}

	for _, root in ipairs(pkg_roots) do
		local p = root .. "/package.json"
		if vim.fn.filereadable(p) == 1 then
			for _, e in ipairs(entries_for_package(p, root)) do
				table.insert(all_entries, e)
				if e.kind == "backend" then
					table.insert(all_backends, e)
				elseif e.kind == "frontend" then
					table.insert(all_frontends, e)
				end
			end
		end
	end

	table.sort(all_entries, function(a, b)
		local function rank(e)
			local n, k = e.name, (e.kind == "backend" and 0 or 1)
			if n:match("^start") then
				return k * 10
			end
			if n:match("^dev") then
				return k * 10 + 1
			end
			return k * 10 + 2
		end
		return rank(a) < rank(b)
	end)

	-- Offer cross-package full-stack when both backend and frontend exist
	if #all_backends > 0 and #all_frontends > 0 then
		table.insert(all_entries, 1, {
			name = "⚡ Full Stack",
			kind = "fullstack",
			backend = all_backends[1],
			frontend = all_frontends[1],
		})
	end

	if #all_entries == 0 then
		vim.notify(
			"[DAP] No debuggable scripts found in workspace\n"
				.. "(ts-node/tsx backend scripts or vite/next/react-scripts dev servers)\n"
				.. "Workspace root: "
				.. workspace_root,
			vim.log.levels.WARN
		)
		return
	end

	---@param entry NodeEntry
	local function start_debug(entry)
		-- ── Full Stack: backend as bg job + frontend DAP ─────────────────
		if entry.kind == "fullstack" then
			local be = entry.backend
			vim.fn.jobstart({ be.pkg_manager, "run", be.name }, { cwd = be.cwd })
			vim.notify("[DAP] " .. be.pkg_name .. ": starting backend '" .. be.name .. "'…", vim.log.levels.INFO)
			start_debug(entry.frontend)
			return
		end

		-- ── Frontend: start dev server then attach Arc ────────────────────
		if entry.kind == "frontend" then
			local dev_port = entry.port
			local function http_ready()
				return vim.fn
					.system(string.format("bash -c '>/dev/tcp/127.0.0.1/%d' 2>/dev/null && echo ok || echo fail", dev_port))
					:match("ok") ~= nil
			end

			local url = "http://localhost:" .. dev_port

			if http_ready() then
				vim.notify(
					"[DAP] " .. entry.pkg_name .. ": dev server already on :" .. dev_port .. ", opening Arc…",
					vim.log.levels.INFO
				)
				M.DapChromeDebug(url, entry.cwd)
				return
			end

			vim.fn.jobstart({ entry.pkg_manager, "run", entry.script }, { cwd = entry.cwd })
			vim.notify(
				string.format(
					"[DAP] %s: starting '%s' (→ :%d), attaching Arc when ready…",
					entry.pkg_name,
					entry.script,
					dev_port
				),
				vim.log.levels.INFO
			)

			local elapsed, interval = 0, 500
			local function poll()
				if http_ready() then
					vim.notify("[DAP] " .. entry.pkg_name .. ": dev server ready on :" .. dev_port, vim.log.levels.INFO)
					M.DapChromeDebug(url, entry.cwd)
				elseif elapsed >= 30000 then
					vim.notify("[DAP] Dev server not ready after 30s", vim.log.levels.ERROR)
				else
					elapsed = elapsed + interval
					vim.defer_fn(poll, interval)
				end
			end
			vim.defer_fn(poll, interval)
			return
		end

		-- ── Backend: ts-node/tsx with --inspect-brk → pwa-node attach ────
		local function port_open()
			return vim.fn
				.system(string.format("bash -c '>/dev/tcp/127.0.0.1/%d' 2>/dev/null && echo ok || echo fail", inspect_port))
				:match("ok") ~= nil
		end

		local function attach()
			dap.run({
				type = "pwa-node",
				request = "attach",
				name = "Node.js [" .. entry.pkg_name .. "]",
				port = inspect_port,
				cwd = entry.cwd,
				sourceMaps = true,
				skipFiles = { "<node_internals>/**", "**/node_modules/**" },
				resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
			})
		end

		if port_open() then
			vim.notify("[DAP] Port " .. inspect_port .. " already open, attaching…", vim.log.levels.INFO)
			attach()
			return
		end

		vim.fn.jobstart(
			{ "node", "--inspect-brk=" .. inspect_port, "-r", "ts-node/register", entry.file },
			{ cwd = entry.cwd }
		)
		vim.notify(
			string.format("[DAP] %s: starting '%s' (%s) with --inspect-brk…", entry.pkg_name, entry.name, entry.file),
			vim.log.levels.INFO
		)

		local elapsed, interval = 0, 300
		local function poll()
			if port_open() then
				attach()
			elseif elapsed >= 15000 then
				vim.notify("[DAP] Node inspect port not ready after 15s", vim.log.levels.ERROR)
			else
				elapsed = elapsed + interval
				vim.defer_fn(poll, interval)
			end
		end
		vim.defer_fn(poll, interval)
	end

	if #all_entries == 1 then
		start_debug(all_entries[1])
	else
		local labels = vim.tbl_map(function(e)
			if e.kind == "fullstack" then
				return string.format(
					"⚡ Full Stack  [%s::%s + %s::%s → :%d]",
					e.backend.pkg_name,
					e.backend.name,
					e.frontend.pkg_name,
					e.frontend.name,
					e.frontend.port
				)
			elseif e.kind == "backend" then
				return string.format("[%s] %s  →  %s  (backend)", e.pkg_name, e.name, e.file)
			else
				return string.format("[%s] %s  →  :%d  (frontend)", e.pkg_name, e.name, e.port)
			end
		end, all_entries)
		vim.ui.select(labels, { prompt = "Select entry point:" }, function(_, idx)
			if idx then
				start_debug(all_entries[idx])
			end
		end)
	end
end

return M
