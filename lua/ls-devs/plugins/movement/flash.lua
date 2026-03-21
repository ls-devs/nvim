-- ── flash.nvim ────────────────────────────────────────────────────────────
-- Purpose : Enhanced f/t/F/T motions with label hints (replaces flit.nvim +
--           leap.nvim), plus a full-window jump mode and treesitter-aware
--           selection; single plugin replaces the old flit/leap/telepath stack
-- Trigger : keys — f, F, t, T, s, S, r, R, <C-s>
-- Note    : Catppuccin integration is enabled via catppuccin.lua integrations
-- ─────────────────────────────────────────────────────────────────────────
return {
	"folke/flash.nvim",
	opts = {
		-- 52-char alphabet so up to 52 matches get a single-character label;
		-- beyond that flash falls back to two-character label pairs automatically
		labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM",
		label = {
			-- built-in rainbow uses HSL hue-rotation which ignores the catppuccin
			-- palette; disabled here — FlashRainbow1-7 are defined in catppuccin.lua
			-- custom_highlights and assigned below via label.format
			rainbow = { enabled = false },
			-- cycle through 7 catppuccin accent colours in label-index order so
			-- the first ~7 labels are visually distinct and palette-consistent;
			-- format is also called for unlabeled/cursor matches where opts.label
			-- is nil — fall back to the base FlashLabel group in that case
			format = function(opts)
				if not opts.label then
					return { { opts.label or "", "FlashLabel" } }
				end
				local hls = {
					"FlashRainbow1",
					"FlashRainbow2",
					"FlashRainbow3",
					"FlashRainbow4",
					"FlashRainbow5",
					"FlashRainbow6",
					"FlashRainbow7",
				}
				local labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM"
				local idx = (string.find(labels, opts.label, 1, true) or 1)
				return { { opts.label, hls[((idx - 1) % #hls) + 1] } }
			end,
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
						[" "] = "next", -- space cycles forward through label groups (flit-like)
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
