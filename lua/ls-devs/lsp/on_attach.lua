local lsp_signature = require("lsp_signature")

if not lsp_signature then
	return
end

local M = {}

M.on_attach = function(client, bufnr)
	require("lsp-inlayhints").on_attach(client, bufnr)
	lsp_signature.on_attach({
		floating_window = false,
		hint_prefix = "🐭 ",
	}, bufnr)

	if
		client.name == "sumneko_lua"
		or "tsserver"
		or "pyright"
		or "volar"
		or "rust-analyser"
		or "jsonls"
		or "intelephense"
		or "marksman"
		or "yamlls"
		or "clangd"
		or "cmake"
		or "dockerls"
		or "prismals"
	then
		client.server_capabilities.document_formatting = false
	end

	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap

	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	keymap(bufnr, "n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	keymap(bufnr, "n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
end

return M
