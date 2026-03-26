-- ── lsp/powershell_es ────────────────────────────────────────────────────
-- Server  : PowerShell Editor Services
-- Language: PowerShell (.ps1, .psm1, .psd1)
-- Note    : cmd is NOT set here — it is overridden in plugins/lsp/manager.lua
--           immediately after vim.lsp.enable("powershell_es") to inject
--           -ExecutionPolicy Bypass (required on WSL where pwsh.exe blocks
--           scripts on the \\wsl.localhost UNC path).
--           bundle_path and shell are kept so the nvim-lspconfig cmd function
--           can read them via vim.lsp.config.powershell_es.* if ever needed.
-- ─────────────────────────────────────────────────────────────────────────
local bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"

local shell = vim.fn.executable("pwsh") == 1 and "pwsh"
	or vim.fn.executable("pwsh.exe") == 1 and "pwsh.exe"
	or vim.fn.executable("powershell.exe") == 1 and "powershell.exe"
	or "pwsh"

return {
	bundle_path = bundle_path,
	shell = shell,
	settings = {
		powershell = {
			codeFormatting = {
				autoCorrectAliases = true,
				useCorrectCasing = true,
			},
		},
	},
}
