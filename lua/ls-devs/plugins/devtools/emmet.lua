-- ── nvim-emmet ────────────────────────────────────────────────────────────
-- Purpose : Emmet abbreviation expansion (e.g. div.container>ul>li*3)
-- Trigger : ft = html / js / ts / vue / svelte / astro
-- Note    : Complements emmet_language_server LSP (which drives completions);
--           the <leader>xe wrap-with-abbreviation command is wired via a
--           LspAttach autocmd in core/autocmds.lua
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"olrtg/nvim-emmet",
	ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
}
