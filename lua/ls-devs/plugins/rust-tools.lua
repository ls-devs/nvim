return function()
  local rt = require("rust-tools")
  local extension_path = vim.env.HOME .. "~/.vscode-insiders/extensions/vadimcn.vscode-lldb-1.8.1/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  rt.setup({
    tools = {
      runnables = {
        use_telescope = true,
      },
      inlay_hints = { auto = true, show_parameter_hints = true, locationLinks = false },
      hover_actions = { auto_focus = true },
    },
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {

      on_attach = function(_, bufnr)
        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
        vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap(bufnr, "n", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        keymap(bufnr, "n", "<leader>fm", "<cmd>lua vim.lsp.buf.format( { timeout_ms = 5000  })<CR>", opts)
        keymap(bufnr, "n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        keymap(bufnr, "n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        keymap(bufnr, "n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        keymap(bufnr, "n", "<leader>uo", "<cmd>lua require('dapui').toggle()<CR>", opts)
        keymap(bufnr, "n", "<leader>uc", "<cmd>lua require('dapui').close()<CR>", opts)
        keymap(bufnr, "n", "<leader>un", ":DapContinue<CR>", opts)
        keymap(bufnr, "n", "<leader>ut", ":DapTerminate<CR>", opts)
        keymap(bufnr, "n", "<leader>bb", ":DapToggleBreakpoint<CR>", opts)
      end,
      ["rust-analyzer"] = {
        inlayHints = { auto = true, show_parameter_hints = true, locationLinks = false },
        lens = {
          enable = true,
        },
        checkonsave = {
          command = "clippy",
        },
      },
    },
  })
end
