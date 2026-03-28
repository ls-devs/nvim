-- ── powershell_es ────────────────────────────────────────────────────────
-- Purpose : Start PowerShell Editor Services when a PS file is opened.
-- Trigger : ft (ps1 / psm1 / psd1) — lazy.nvim fires the config function
--           AFTER the FileType event, so vim.lsp.start attaches correctly.
-- Note    : Standalone spec (not a dependency) to avoid lazy.nvim spec-merge
--           dropping the trigger. Uses dir= so no network fetch is needed.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	{
		-- Local "virtual" plugin — no download, just runs config on ft trigger.
		dir = vim.fn.stdpath("config"),
		name = "powershell-es-lsp",
		ft = { "ps1", "psm1", "psd1" },
		config = function()
			local bufnr = vim.api.nvim_get_current_buf()
			local ps_bundle = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
			if not vim.uv.fs_stat(ps_bundle) then
				return
			end
			local ps_shell = vim.fn.executable("pwsh") == 1 and "pwsh"
				or vim.fn.executable("pwsh.exe") == 1 and "pwsh.exe"
				or vim.fn.executable("powershell.exe") == 1 and "powershell.exe"
				or nil
			if not ps_shell then
				return
			end
			local ps_cache = vim.fn.stdpath("cache")
			local ps_cmd_str = string.format(
				"& '%s/PowerShellEditorServices/Start-EditorServices.ps1'"
					.. " -BundledModulesPath '%s'"
					.. " -LogPath '%s/powershell_es.log'"
					.. " -SessionDetailsPath '%s/powershell_es.session.json'"
					.. " -FeatureFlags @() -AdditionalModules @()"
					.. " -HostName nvim -HostProfileId 0 -HostVersion 1.0.0"
					.. " -Stdio -LogLevel Information",
				ps_bundle,
				ps_bundle,
				ps_cache,
				ps_cache
			)
			local blink_ok, blink = pcall(require, "blink.cmp")
			vim.lsp.start({
				name = "powershell_es",
				capabilities = blink_ok and blink.get_lsp_capabilities() or nil,
				cmd = {
					ps_shell,
					"-NoLogo",
					"-NoProfile",
					"-ExecutionPolicy",
					"Bypass",
					"-Command",
					ps_cmd_str,
				},
				root_dir = vim.fs.root(bufnr, { ".git", "PSScriptAnalyzerSettings.psd1" }) or vim.fn.getcwd(),
				settings = {
					powershell = {
						codeFormatting = {
							autoCorrectAliases = true,
							useCorrectCasing = true,
						},
					},
				},
			}, { bufnr = bufnr })
		end,
	},
}
