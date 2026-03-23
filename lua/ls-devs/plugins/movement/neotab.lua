-- ── neotab.nvim ───────────────────────────────────────────────────────────
-- Purpose : Smart tab-out of closing brackets, quotes, and delimiters
-- Trigger : event — InsertEnter
-- Note    : tabkey="" because blink.cmp owns <Tab> and calls neotab.tabout()
--           as the final fallback in its Tab keymap chain
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"kawre/neotab.nvim",
	event = "InsertEnter",
	opts = {
		tabkey = "", -- Tab is managed by blink.cmp; neotab is invoked programmatically
		reverse_key = "", -- <S-Tab> disabled to avoid conflict with blink.cmp select_prev
		act_as_tab = true, -- insert a real tab when the cursor is not inside a tracked pair
		behavior = "nested", ---@type ntab.behavior
		pairs = { ---@type ntab.pair[]
			{ open = "(", close = ")" },
			{ open = "[", close = "]" },
			{ open = "{", close = "}" },
			{ open = "'", close = "'" },
			{ open = '"', close = '"' },
			{ open = "`", close = "`" },
			{ open = "<", close = ">" },
		},
		exclude = {},
		smart_punctuators = {
			enabled = false,
			semicolon = {
				enabled = false,
				ft = { "cs", "c", "cpp", "java" },
			},
			escape = {
				enabled = false,
				triggers = {}, ---@type table<string, ntab.trigger>
			},
		},
	},
}
