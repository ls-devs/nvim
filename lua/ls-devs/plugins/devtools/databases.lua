-- ── vim-dadbod-ui ─────────────────────────────────────────────────────────
-- Purpose : Interactive database UI for querying SQL databases
-- Trigger : cmd / keys
-- Provides: Connection manager, query buffers, result viewer
-- Behavior: <leader>Du from snacks_dashboard → wipe dashboard, open DBUI
--           <leader>Du with real buffers open  → open DBUI in a new tab
--           <leader>Du when DBUI visible       → DBUIToggle (close)
--           <leader>Du with no real buffers    → open DBUI normally
-- Note    : vim-dadbod is the backend driver; vim-dadbod-completion adds
--           SQL autocomplete for sql/mysql/plsql/sqlite filetypes.
--           DML (INSERT/UPDATE/DELETE/CREATE) works in any query buffer;
--           results show rows affected. Custom table helpers add DML
--           templates as child items under each table in the drawer.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "sqlite" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
		"DBUIRenameBuffer",
		"DBUILastQueryInfo",
	},
	keys = {
		{
			"<leader>Du",
			function()
				local ft = vim.bo.filetype

				-- From dashboard: wipe it and open DBUI in the freed window
				if ft == "snacks_dashboard" or ft == "starter" then
					vim.cmd("bwipeout")
					vim.cmd("DBUI")
					return
				end

				-- Scan all tabs: if DBUI is already visible anywhere, navigate to it
				-- (or toggle it closed if it's in the current tab)
				for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
						if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dbui" then
							if tabpage == vim.api.nvim_get_current_tabpage() then
								vim.cmd("DBUIToggle")
							else
								vim.api.nvim_set_current_tabpage(tabpage)
							end
							return
						end
					end
				end

				-- If real (non-special, non-empty) buffers exist, open in a new tab
				local has_real = false
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if
						vim.api.nvim_buf_is_loaded(buf)
						and vim.bo[buf].buftype == ""
						and vim.api.nvim_buf_get_name(buf) ~= ""
					then
						has_real = true
						break
					end
				end

				if has_real then
					vim.cmd("tabnew")
				end
				vim.cmd("DBUI")
			end,
			desc = "DBUI toggle",
		},
		{ "<leader>Da", "<cmd>DBUIAddConnection<CR>", desc = "DBUI add connection" },
		{ "<leader>Df", "<cmd>DBUIFindBuffer<CR>", desc = "DBUI find buffer" },
		{ "<leader>Dr", "<cmd>DBUIRenameBuffer<CR>", desc = "DBUI rename buffer" },
		{ "<leader>Di", "<cmd>DBUILastQueryInfo<CR>", desc = "DBUI last query info" },
		{
			"<leader>Dq",
			function()
				-- DBUI tree heading labels that are NOT table/view names.
				-- cword under these nodes should be ignored.
				local DBUI_TREE_HEADINGS = {
					Tables = true,
					Views = true,
					Routines = true,
					Triggers = true,
					Indexes = true,
					Functions = true,
					Procedures = true,
					Types = true,
					Sequences = true,
					Enums = true,
				}

				local ft = vim.bo.filetype
				local cword = ""
				if ft == "dbui" then
					-- Only use cword when the cursor is on an actual table/view node
					local w = vim.fn.expand("<cword>")
					if not DBUI_TREE_HEADINGS[w] then
						cword = w
					end
				elseif ft == "sql" or ft == "mysql" or ft == "plsql" or ft == "sqlite" then
					-- Pre-fill with the identifier under the cursor so the user can
					-- just hit <CR> when the cursor is already on a table name
					cword = vim.fn.expand("<cword>")
				end

				local function open_dml(tbl)
					if not tbl or tbl == "" then
						return
					end
					local ops = {
						{
							label = "󰆼  SELECT   – query rows",
							sql = "SELECT *\nFROM " .. tbl .. "\nLIMIT 10;",
						},
						{
							label = "󰐕  INSERT   – insert row",
							sql = "INSERT INTO " .. tbl .. "\n  (col1, col2)\nVALUES\n  (val1, val2);",
						},
						{
							label = "󰏫  UPDATE   – modify rows",
							sql = "UPDATE " .. tbl .. "\nSET\n  col = val\nWHERE id = ;",
						},
						{
							label = "󰆴  DELETE   – remove rows",
							sql = "DELETE FROM " .. tbl .. "\nWHERE id = ;",
						},
						{
							label = "󰩺  TRUNCATE – empty table",
							sql = "TRUNCATE TABLE " .. tbl .. ";",
						},
						{
							label = "󰐗  COUNT    – count rows",
							sql = "SELECT COUNT(*)\nFROM " .. tbl .. ";",
						},
					}

					vim.ui.select(ops, {
						prompt = "DML › " .. tbl,
						format_item = function(o)
							return o.label
						end,
						snacks = {
							hidden = { "preview" },
							layout = {
								layout = {
									backdrop = false,
									width = 0.45,
									min_width = 55,
									max_width = 80,
									box = "vertical",
									border = "rounded",
									title = "{title}",
									title_pos = "center",
									{ win = "input", height = 1, border = "bottom" },
									{ win = "list", border = "none" },
								},
							},
						},
					}, function(op)
						if not op then
							return
						end

						-- Reuse any existing open SQL query buffer or create a new one
						local target = nil
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							local bft = vim.bo[buf].filetype
							if
								(bft == "sql" or bft == "mysql" or bft == "plsql") and vim.api.nvim_buf_is_loaded(buf)
							then
								target = buf
								break
							end
						end

						if not target then
							target = vim.api.nvim_create_buf(true, false)
							-- Give the buffer a recognizable name (query-1.sql, query-2.sql, …)
							local n = #vim.tbl_filter(function(b)
								return vim.api.nvim_buf_get_name(b):match("query%-%d+%.sql$") ~= nil
							end, vim.api.nvim_list_bufs())
							pcall(vim.api.nvim_buf_set_name, target, ("query-%d.sql"):format(n + 1))
							vim.bo[target].filetype = "sql"
						end

						-- Propagate DB connection from current buffer (dbui sets b:db)
						local ok, db = pcall(vim.api.nvim_buf_get_var, 0, "db")
						if ok and db then
							pcall(vim.api.nvim_buf_set_var, target, "db", db)
						end
						local ok2, dbkey = pcall(vim.api.nvim_buf_get_var, 0, "dbui_db_key_name")
						if ok2 and dbkey then
							pcall(vim.api.nvim_buf_set_var, target, "dbui_db_key_name", dbkey)
						end

						vim.api.nvim_set_current_buf(target)
						local new_lines = vim.split(op.sql, "\n")
						local count = vim.api.nvim_buf_line_count(target)
						-- Add blank separator if buffer already has content
						if count > 1 or (count == 1 and vim.api.nvim_buf_get_lines(target, 0, 1, false)[1] ~= "") then
							table.insert(new_lines, 1, "")
						end
						vim.api.nvim_buf_set_lines(target, count, count, false, new_lines)
						vim.api.nvim_win_set_cursor(0, { count + #new_lines, 0 })
					end)
				end

				if cword ~= "" then
					open_dml(cword)
				else
					vim.ui.input({ prompt = "Table name: ", default = cword }, function(input)
						open_dml(input)
					end)
				end
			end,
			desc = "DBUI DML query template",
		},
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_winwidth = 45 -- sidebar always on the left
		vim.g.db_ui_win_position = "left"
		vim.g.db_ui_show_help = 0
		-- Route all DBUI notifications through vim.notify so Snacks
		-- picks them up and displays them in the bottom-right corner
		vim.g.db_ui_use_nvim_notify = 1
		-- Custom table helpers: adds DML query templates that appear as
		-- child items when expanding a table in the DBUI drawer.
		-- {table} and {schema} are replaced automatically by dadbod-ui.
		vim.g.db_ui_table_helpers = {
			postgresql = {
				["Insert"] = 'INSERT INTO {optional_schema}"{table}" ({columns}) VALUES ({values});',
				["Update"] = 'UPDATE {optional_schema}"{table}" SET {column} = {value} WHERE {condition};',
				["Delete"] = 'DELETE FROM {optional_schema}"{table}" WHERE {condition};',
				["Truncate"] = 'TRUNCATE TABLE {optional_schema}"{table}";',
				["Count"] = 'SELECT COUNT(*) FROM {optional_schema}"{table}";',
			},
			mysql = {
				["Insert"] = "INSERT INTO {optional_schema}`{table}` ({columns}) VALUES ({values});",
				["Update"] = "UPDATE {optional_schema}`{table}` SET {column} = {value} WHERE {condition};",
				["Delete"] = "DELETE FROM {optional_schema}`{table}` WHERE {condition};",
				["Truncate"] = "TRUNCATE TABLE {optional_schema}`{table}`;",
				["Count"] = "SELECT COUNT(*) FROM {optional_schema}`{table}`;",
			},
			sqlite = {
				["Insert"] = 'INSERT INTO "{table}" ({columns}) VALUES ({values});',
				["Update"] = 'UPDATE "{table}" SET {column} = {value} WHERE {condition};',
				["Delete"] = 'DELETE FROM "{table}" WHERE {condition};',
				-- SQLite has no TRUNCATE — use DELETE FROM without a WHERE clause
				["Clear"] = 'DELETE FROM "{table}";',
				["Count"] = 'SELECT COUNT(*) FROM "{table}";',
			},
			-- Oracle PL/SQL helpers (double-quoted identifiers, no backticks)
			plsql = {
				["Insert"] = 'INSERT INTO {optional_schema}"{table}" ({columns}) VALUES ({values});',
				["Update"] = 'UPDATE {optional_schema}"{table}" SET {column} = {value} WHERE {condition};',
				["Delete"] = 'DELETE FROM {optional_schema}"{table}" WHERE {condition};',
				["Truncate"] = 'TRUNCATE TABLE {optional_schema}"{table}";',
				["Count"] = 'SELECT COUNT(*) FROM {optional_schema}"{table}";',
			},
		}
	end,
}
