-- ── flash.nvim ────────────────────────────────────────────────────────────
-- Purpose : Enhanced f/t/F/T motions with label hints (replaces flit.nvim +
--           leap.nvim), plus a full-window jump mode and treesitter-aware
--           selection; single plugin replaces the old flit/leap/telepath stack
-- Trigger : keys — f, F, t, T, s, S, r, R, <C-s>
-- Note    : Catppuccin integration is enabled via catppuccin.lua integrations
-- ─────────────────────────────────────────────────────────────────────────
return {
	"folke/flash.nvim",
	config = function(_, opts)
		require("flash").setup(opts)
		-- flash.rainbow creates groups named FlashColor{color}{shade} using its own
		-- Tailwind CSS palette. Patch that palette's entries with catppuccin hex values
		-- AFTER setup() so flash uses our colours when it lazily creates the groups.
		-- shade=7 → flash reads M.colors[color][700] for bg and M.colors[color][50] for fg.
		local function patch_rainbow()
			local ok, palette = pcall(require, "catppuccin.palettes")
			if not ok then
				return
			end
			local c = palette.get_palette()
			local base = c.base:sub(2) -- strip leading # for flash's color table
			-- Map each slot in flash's rainbow cycle to a catppuccin accent colour
			local map = {
				red = c.red:sub(2),
				amber = c.peach:sub(2),
				lime = c.yellow:sub(2),
				green = c.green:sub(2),
				teal = c.teal:sub(2),
				cyan = c.sky:sub(2),
				blue = c.blue:sub(2),
				violet = c.lavender:sub(2),
				fuchsia = c.pink:sub(2),
				rose = c.flamingo:sub(2),
			}
			local rainbow = require("flash.rainbow")
			local shade = (opts.label.rainbow.shade or 5) * 100
			-- fg_shade: flash uses [50] when shade>500, [900] when <500, [950] when ==500
			local fg_shade = shade > 500 and 50 or shade < 500 and 900 or 950
			for color, hex in pairs(map) do
				rainbow.colors[color] = rainbow.colors[color] or {}
				rainbow.colors[color][shade] = hex
				rainbow.colors[color][fg_shade] = base
			end
			rainbow.hl = {} -- clear cache so groups are recreated with patched colours
		end
		patch_rainbow()
		-- reapply when switching catppuccin flavour
		vim.api.nvim_create_autocmd("ColorScheme", { callback = patch_rainbow })
	end,
	opts = { -- 52-char alphabet so up to 52 matches get a single-character label;
		-- beyond that flash falls back to two-character label pairs automatically
		labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM",
		label = {
			-- distance-based rainbow: flash creates FlashColor{name}{shade} groups
			-- (e.g. FlashColorred700) from its Tailwind palette; the config function
			-- above patches those entries with catppuccin hex values after setup()
			rainbow = { enabled = true, shade = 7 },
			current = false, -- no label on the match at the cursor (already there)
		},
		jump = {
			nohlsearch = true, -- clear hlsearch immediately after any flash jump
		},
		modes = {
			-- char mode replaces native f/t/F/T: shows label hints for repeated
			-- matches so you can jump directly without pressing ; multiple times
			char = {
				enabled = true, -- activate f/t/F/T label hints (flit.nvim equivalent)
				jump_labels = true, -- show labels on all matches (flit behaviour); default is false
				keys = { "f", "F", "t", "T", ";", ",", " " }, -- <Space> cycles to next group of labels
				search = {
					wrap = false, -- don't wrap around the buffer (matches flit behaviour)
				},
				highlight = {
					backdrop = true, -- dim non-jump characters for clarity
				},
				jump = {
					register = false, -- don't pollute the jump register for f/t motions
				},
				multi_window = false, -- restrict to current window (matches flit scope)
				-- <Space> advances to the next batch of labels when matches exceed label count
				char_actions = function(motion)
					return {
						[";"] = "next",
						[","] = "prev",
						[" "] = "next", -- space cycles forward (flit-like)
						-- pressing the same motion key again repeats in the same direction
						-- (native vim feel: f→next after fe, F→prev after Fe, etc.)
						["f"] = motion == "f" and "next" or "prev",
						["F"] = motion == "F" and "next" or "prev",
						["t"] = motion == "t" and "next" or "prev",
						["T"] = motion == "T" and "next" or "prev",
					}
				end,
			},
		},
	},
	keys = {
		-- char mode (f/t/F/T) — entries here make lazy.nvim load flash on first press;
		-- flash's setup() then owns these keys via modes.char
		{ "f", mode = { "n", "x", "o" }, desc = "Flash f" },
		{ "F", mode = { "n", "x", "o" }, desc = "Flash F" },
		{ "t", mode = { "n", "x", "o" }, desc = "Flash t" },
		{ "T", mode = { "n", "x", "o" }, desc = "Flash T" },
		-- Full-window jump: type a pattern and pick a label
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash jump",
		},
		-- Treesitter-aware jump: highlight AST nodes and jump to one
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash treesitter",
		},
		-- Remote flash: apply an operator on a distant location without moving cursor
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote flash",
		},
		-- Treesitter search: search + select a treesitter node in operator/visual mode
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Flash treesitter search",
		},
		-- Toggle flash on/off while inside the / or ? search prompt
		{
			"<C-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle flash search",
		},
	},
}
