-- ── lsp/omnisharp ─────────────────────────────────────────────────────────
-- Server  : OmniSharp
-- Language: C# / .NET
-- Config  : Formatting disabled; Roslyn analyzers, import completion,
--           and decompilation support enabled
-- Note    : Formatting handled by conform (csharpier);
--           LoadProjectsOnDemand reduces startup overhead in large solutions
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client, _bufnr)
		-- Formatting is owned by conform (csharpier); prevent OmniSharp from
		-- registering its own formatter so there is no conflict
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
			OrganizeImports = true,
		},
		MsBuild = {
			-- Only load MSBuild projects when their files are first opened,
			-- avoiding a full solution scan at server start
			LoadProjectsOnDemand = true,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
			-- Analyze all workspace files, not only those currently open
			AnalyzeOpenDocumentsOnly = false,
			-- Allow go-to-definition to navigate into decompiled .NET assemblies
			EnableDecompilationSupport = true,
		},
		Sdk = {
			-- Surface .NET SDK prerelease versions in completion and analysis
			IncludePrereleases = true,
		},
	},
}
