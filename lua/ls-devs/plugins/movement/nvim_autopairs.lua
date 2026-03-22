-- ── nvim-autopairs ────────────────────────────────────────────────────────
-- Purpose : Auto-close brackets, quotes, and tags on insert
-- Trigger : event — InsertEnter
-- Note    : check_ts uses treesitter to suppress pairing inside strings and
--           comments; <M-e> (fast_wrap) wraps the next token in a bracket pair
-- ─────────────────────────────────────────────────────────────────────────
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true, -- use treesitter to avoid inserting pairs inside strings/comments
		ts_config = {
			lua = { "string", "source" },
			javascript = { "string", "template_string" },
			java = false, -- disable treesitter check for Java entirely
		},
		disable_filetype = {
			"TelescopePrompt",
			"spectre_panel",
			"guihua",
			"guihua_rust",
			"clap_input",
			"snacks_picker_input",
		},
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0, -- Offset from pattern match
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true, -- don't wrap when a comma already follows the cursor
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	},
}
