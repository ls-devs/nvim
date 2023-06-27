local M = {}

M.config = function()
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_set_keymap

  -- Leader key
  keymap("", "<Space>", "<Nop>", opts)
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  require("legendary").setup({
    lazy_nvim = { auto_register = true },
    keymaps = {
      { "<leader>LL", "<cmd>Legendary<CR>",           description = "Legendary",           opts = opts },
      { "<leader>LK", "<cmd>Legendary keymaps<CR>",   description = "Legendary keymaps",   opts = opts },
      { "<leader>LC", "<cmd>Legendary commands<CR>",  description = "Legendary commands",  opts = opts },
      { "<leader>LA", "<cmd>Legendary autocmds<CR>",  description = "Legendary autocmds",  opts = opts },
      { "<leader>LF", "<cmd>Legendary functions<CR>", description = "Legendary functions", opts = opts },
      -- Navigate buffers
      {
        "<C-d>",
        "<C-d>zz",
        description = "Navigate Down & Center",
        opts = opts,
      },
      {
        "<C-u>",
        "<C-u>zz",
        description = "Navigate Up & Center",
        opts = opts,
      },
      -- Resize
      -- Move text up and down
      {
        "<A-j>",
        { v = "<cmd>m .+1<CR>==", x = "<cmd>move '>+1<CR>gv-gv" },
        description = "Move Text Down",
        opts = opts,
      },
      {
        "<A-k>",
        { v = "<cmd>m .-2<CR>==", x = "<cmd>move '<-2<CR>gv-gv" },
        description = "Move Text Up",
        opts = opts,
      },
      {
        "p",
        { v = '"_dP' },
        description = "Paste Text",
        opts = opts,
      },
      { "J", { x = ":move '>+1<CR>gv-gv" }, opts = opts },
      { "K", { x = ":move '<-2<CR>gv-gv" }, opts = opts },

      -- Stay in indent mode
      {
        "<",
        { v = "<gv" },
        opts = opts,
      },
      {
        ">",
        { v = ">gv" },
        opts = opts,
      },
      -- Copilot
      {
        "<leader>cp",
        "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>",
        description = "Toggle Copilot",
        opts = opts,
      },
      -- Glow
      {
        "<leader>md",
        "<cmd>Glow<CR>",
        description = "Glow",
      },
      -- File explorer
      {
        "<leader>e",
        "<cmd>NeoTreeFloatToggle<CR>",
        description = "NeoTree Open Float",
        opts = opts,
      },
      {
        "<leader>to",
        "<cmd>NeoTreeShow<CR>",
        description = "NeoTree Show",
        opts = opts,
      },
      {
        "<leader>tc",
        "<cmd>NeoTreeClose<CR>",
        description = "NeoTree Close",
        opts = opts,
      },

      -- Telescope
      {
        "<leader>ff",
        "<cmd>Telescope find_files<CR>",
        description = "Telescope Find Files",
        opts = opts,
      },
      {
        "<leader>ft",
        "<cmd>Telescope live_grep<CR>",
        description = "Telescope Live Grep",
        opts = opts,
      },
      {
        "<leader>fb",
        "<cmd>Telescope buffers<CR>",
        description = "Telescope Buffers",
        opts = opts,
      },
      {
        "<leader>fh",
        "<cmd>Telescope help_tags<CR>",
        description = "Telescope Help Tags",
        opts = opts,
      },
      {
        "<leader>fp",
        "<cmd>Telescope oldfiles<CR>",
        description = "Telescope Recent Files",
        opts = opts,
      },
      {
        "<leader>fa",
        "<cmd>Telescope autocommands<CR>",
        description = "Telescope Autocommands",
        opts = opts,
      },
      {
        "<leader>fc",
        "<cmd>Telescope commands<CR>",
        description = "Telescope Commands",
        opts = opts,
      },
      {
        "<leader>fk",
        "<cmd>Telescope keymaps<CR>",
        description = "Telescope Keymaps",
        opts = opts,
      },
      {
        "<leader>fF",
        "<cmd>Telescope filetypes<CR>",
        description = "Telescope Filetypes",
        opts = opts,
      },
      {
        "<leader>fo",
        "<cmd>Telescope vim_options<CR>",
        description = "Telescope Vim Options",
        opts = opts,
      },
      {
        "<leader>fH",
        "<cmd>Telescope highlights<CR>",
        description = "Telescope Highlights",
        opts = opts,
      },
      {
        "<leader>tz",
        "<cmd>Telescope aerial<CR>",
        description = "Telescope aerial",
        opts = opts,
      },

      {
        "<leader>fB",
        "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        description = "Telescope Current Buffer Fuzzy Find",
        opts = opts,
      },
      {
        "<leader>fC",
        "<cmd>Telescope command_history<CR>",
        description = "Telescope Command History",
        opts = opts,
      },
      {
        "<leader>fM",
        "<cmd>Telescope marks<CR>",
        description = "Telescope Marks",
        opts = opts,
      },
      {
        "<leader>tm",
        "<cmd>Telescope media_files<CR>",
        description = "Telescope Media Files",
        opts = opts,
      },
      {
        "<leader>gs",
        "<cmd>lua require('telescope.builtin').git_status()<CR>",
        description = "Telescope Git Status",
        opts = opts,
      },
      {
        "<leader>gc",
        "<cmd>lua require('telescope.builtin').git_commits()<CR>",
        description = "Telescope Git Commits",
        opts = opts,
      },
      {
        "<leader>gb",
        "<cmd>lua require('telescope.builtin').git_branches()<CR>",
        description = "Telescope Git Branches",
        opts = opts,
      },
      -- Urlview
      {
        "<leader>ul",
        "<cmd>UrlView lazy<CR>",
        description = "UrlView Lazy",
        opts = opts,
      },
      {
        "<leader>ub",
        "<cmd>UrlView buffer<CR>",
        description = "UrlView Buffer",
        opts = opts,
      },
      {
        "<leader>uf",
        "<cmd>UrlView file<CR>",
        description = "UrlView File",
        opts = opts,
      },
      -- Ufo
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
      {
        "<leader>p",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
      },
      -- Overseer
      {
        "<leader>or",
        "<cmd>OverseerRun<CR>",
        description = "Overseer Run",
        opts = opts,
      },
      {
        "<leader>ot",
        "<cmd>OverseerToggle<CR>",
        description = "Overseer Toggle",
        opts = opts,
      },

      -- Live Server
      { "<leader>ss", "<cmd>LiveServerStart<CR>", description = "Start Live Server", opts = opts },
      { "<leader>sk", "<cmd>LiveServerStop<CR>",  description = "Stop Live Server",  opts = opts },

      -- LSP & LSP Saga
      {
        "<C-s>",
        function()
          return vim.lsp.buf.signature_help()
        end,

        description = "LSP Signature Help",
        opts = opts,
      },
      {
        "gh",
        "<cmd>Lspsaga lsp_finder<CR>",
        description = "LSPSaga Finder",
        opts = opts,
      },
      {
        "<leader>ca",
        {
          n = function()
            -- if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
            return require("lspsaga.codeaction"):code_action()
            -- end
          end,

          v = function()
            -- if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
            return require("lspsaga.codeaction"):code_action()
            -- end
          end,
        },
        description = "LSPSaga Code Actions",
        opts = opts,
      },
      {
        "<leader>rn",
        "<cmd>Lspsaga rename<CR>",
        description = "LSPSaga Rename",
        opts = opts,
      },
      {
        "<leader>wrn",
        "<cmd>Lspsaga rename ++project<CR>",
        description = "LSPSaga Rename Workspace",
        opts = opts,
      },
      {
        "gp",
        "<cmd>Lspsaga peek_definition<CR>",
        description = "LSPSaga Peek Definition",
        opts = opts,
      },
      {
        "gD",
        "<cmd>lua vim.lsp.buf.declaration()<CR>",
        description = "LSP Buf Declaration",
        opts = opts,
      },
      {
        "gd",
        "<cmd>Lspsaga goto_definition<CR>",
        description = "LSPSaga Goto Definition",
        opts = opts,
      },
      {
        "pt",
        "<cmd>Lspsaga peek_type_definition<CR>",
        description = "LSPSaga Peek Type Definition",
        opts = opts,
      },
      {
        "gt",
        "<cmd>Lspsaga goto_type_definition<CR>",
        description = "LSPSaga Goto Type Defintion",
        opts = opts,
      },
      {
        "<leader>fm",
        "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>",
        description = "LSP Buf Format",
        opts = opts,
      },
      {
        "<leader>cl",
        "<cmd>Lspsaga show_line_diagnostics<CR>",
        description = "LSPSaga Show Line Diagnostics",
        opts = opts,
      },
      {
        "<leader>cb",
        "<cmd>Lspsaga show_buf_diagnostics<CR>",
        description = "LSPSaga Show Buf Diagnostics",
        opts = opts,
      },
      {
        "<leader>cw",
        "<cmd>Lspsaga show_workspace_diagnostics<CR>",
        description = "LSPSaga Show Workspace Diagnostics",
        opts = opts,
      },
      {
        "<leader>cc",
        "<cmd>Lspsaga show_cursor_diagnostics<CR>",
        description = "LSPSaga Show Cursor Diagnostics",
        opts = opts,
      },
      {
        "<leader>dp",
        function()
          -- if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
          return require("lspsaga.diagnostic"):goto_prev()
          -- end
        end,
        description = "LSPSaga Diagnostic Jump Prev",
        opts = opts,
      },
      {
        "<leader>dn",
        function()
          -- if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
          return require("lspsaga.diagnostic"):goto_next()
          -- end
        end,
        description = "LSPSaga Diagnostic Jump Next",
        opts = opts,
      },
      {
        "<leader>o",
        "<cmd>Lspsaga outline<CR>",
        description = "LSPSaga Outline",
        opts = opts,
      },
      {
        "K",
        function()
          if vim.bo.filetype ~= "rust" then
            return require("lspsaga.hover"):render_hover_doc()
          end
        end,
        description = "LSPSaga Hover Doc",
        opts = opts,
      },
      {
        "<leader>K",
        function()
          -- if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
          return require("lspsaga.hover"):render_hover_doc("++keep")
          -- end
        end,
        description = "LSPSaga Hover Doc Keep",
        opts = opts,
      },
      {
        "<leader>ci",
        "<cmd>Lspsaga incoming_calls<CR>",
        description = "LSPSaga Incoming Calls",
        opts = opts,
      },
      {
        "<leader>co",
        "<cmd>Lspsaga outgoing_calls<CR>",
        description = "LSPSaga Outgoing Calls",
        opts = opts,
      },
      {
        "<leader>t",
        "<cmd>Lspsaga term_toggle<CR>",
        description = "LSPSaga Toggle Terminal",
        opts = opts,
      },
      {
        "<leader>t",
        { t = "<cmd>Lspsaga term_toggle<CR>" },
        description = "LSPSaga Toggle Terminal",
        opts = opts,
      },

      -- Aerial
      { "<leader>at", "<cmd>AerialToggle<CR>", description = "Aerial Toggle", opts = opts },
      { "<leader>an", "<cmd>AerialNext<CR>",   description = "Aerial Next",   opts = opts },
      { "<leader>ap", "<cmd>AerialPrev<CR>",   description = "Aerial Prev",   opts = opts },
      -- Lazy
      {
        "<leader>l",
        "<cmd>Lazy<CR>",
        description = "Lazy",
        opts = opts,
      },
      {
        "<leader>ls",
        "<cmd>Lazy sync<CR>",
        description = "Lazy Sync",
        opts = opts,
      },
      {
        "<leader>li",
        "<cmd>Lazy install<CR>",
        description = "Lazy Install",
        opts = opts,
      },
      {
        "<leader>lu",
        "<cmd>Lazy update<CR>",
        description = "Lazy Update",
        opts = opts,
      },
      {
        "<leader>lc",
        "<cmd>Lazy build<CR>",
        description = "Lazy Build",
        opts = opts,
      },

      -- Trouble
      {
        "<leader>v",
        "<cmd>Trouble<CR>",
        description = "Trouble",
        opts = opts,
      },

      -- Todo
      {
        "<leader>T",
        "<cmd>TodoTrouble<CR>",
        description = "TodoTrouble",
        opts = opts,
      },
      {
        "<leader>tt",
        "<cmd>TodoTelescope<CR>",
        description = "TodoTelescope",
        opts = opts,
      },

      -- LazyGit
      { "<leader>lg", ":LazyGit<CR>", description = "LazyGit" },

      -- JUKIT
      -- Splits
      {
        "<leader>jjo",
        "<cmd>call jukit#splits#output()<CR>",
        description = "Jukit Splits Output",
        opts = opts,
      },
      {
        "<leader>jjh",
        "<cmd>call jukit#splits#history()<CR>",
        description = "Jukit Splits History",
        opts = opts,
      },
      {
        "<leader>joh",
        "<cmd>call jukit#splits#output_and_history()<CR>",
        description = "Jukit Splits Output & History",
        opts = opts,
      },
      {
        "<leader>jco",
        "<cmd>call jukit#splits#close_output_split()<CR>",
        description = "Jukit Splits Close Output",
        opts = opts,
      },
      {
        "<leader>jch",
        "<cmd>call jukit#splits#close_history()<CR>",
        description = "Jukit Splits Close History",
        opts = opts,
      },
      {
        "<leader>jca",
        "<cmd>call jukit#splits#close_output_and_history(1)<CR>",
        description = "Jukit Splits Close Ouput & History",
        opts = opts,
      },
      {
        "<leader>jhj",
        "<cmd>call jukit#splits#out_hist_scroll(1)<CR>",
        description = "Jukit Splits Scroll Down",
        opts = opts,
      },
      {
        "<leader>jhk",
        "<cmd>call jukit#splits#out_hist_scroll(0)<CR>",
        description = "Jukit Splits Scroll Up",
        opts = opts,
      },
      {
        "<leader>jht",
        "<cmd>call jukit#splits#toggle_auto_hist()<CR>",
        description = "Jukit Toggle Auto History",
        opts = opts,
      },
      -- Cells
      {
        "<leader>jcc",
        "<cmd>call jukit#cells#create_below(0)<CR>",
        description = "Jukit Cells Create Below",
        opts = opts,
      },
      {
        "<leader>jcC",
        "<cmd>call jukit#cells#create_above(0)<CR>",
        description = "Jukit Cells Create Above",
        opts = opts,
      },
      {
        "<leader>jct",
        "<cmd>call jukit#cells#create_below(1)<CR>",
        description = "Jukit Cells Create Text Below",
        opts = opts,
      },
      {
        "<leader>jcT",
        "<cmd>call jukit#cells#create_above(1)<CR>",
        description = "Jukit Cells Create Text Above",
        opts = opts,
      },
      {
        "<leader>jcd",
        "<cmd>call jukit#cells#delete()<CR>",
        description = "Jukit Cells Delete",
        opts = opts,
      },
      {
        "<leader>jcm",
        "<cmd>call jukit#cells#merge_below()<CR>",
        description = "Jukit Cells Merge Below",
        opts = opts,
      },
      {
        "<leader>jcM",
        "<cmd>call jukit#cells#merge_above()<CR>",
        description = "Jukit Cells Merge Above",
        opts = opts,
      },
      {
        "<leader>jck",
        "<cmd>call jukit#cells#move_up()<CR>",
        description = "Jukit Cells Move Up",
        opts = opts,
      },
      {
        "<leader>jcj",
        "<cmd>call jukit#cells#move_down()<CR>",
        description = "Jukit Cells Move Down",
        opts = opts,
      },
      {
        "<leader>JJ",
        "<cmd>call jukit#cells#jump_to_next_cell()<CR>",
        description = "Jukit Cells Jump To Next",
        opts = opts,
      },
      {
        "<leader>KK",
        "<cmd>call jukit#cells#jump_to_previous_cell()<CR>",
        description = "Jukit Cells Jump To Previous",
        opts = opts,
      },
      {
        "<leader>jdo",
        "<cmd>call jukit#cells#delete_outputs(0)<CR>",
        description = "Jukit Delete Output Cell",
        opts = opts,
      },
      {
        "<leader>jd",
        "<cmd>call jukit#cells#delete_outputs(1)<CR>",
        description = "Jukit Delete Output Text",
        opts = opts,
      },
      -- Send
      {
        "<leader>jss",
        "<cmd>call jukit#send#section(1)<CR>",
        description = "Jukit Send Section",
        opts = opts,
      },
      {
        "<leader>jsl",
        "<cmd>call jukit#send#line()<CR>",
        description = "Jukit Send Line",
        opts = opts,
      },
      {
        "<leader>jss",
        { v = "<cmd>call jukit#send#selection()<CR>" },
        description = "Jukit Send Selection",
        opts = opts,
      },
      {
        "<leader>jsu",
        "<cmd>call jukit#send#until_current_section()<CR>",
        description = "Jukit Send Until Current Section",
        opts = opts,
      },
      {
        "<leader>jsa",
        "<cmd>call jukit#send#all()<CR>",
        description = "Jukit Send All",
        opts = opts,
      },
      -- Convert
      {
        "<leader>jcv",
        "<cmd>call jukit#convert#notebook_convert('jupyter-notebook')<CR>",
        description = "Jukit Covert",
        opts = opts,
      },
    },
    extensions = {
      -- load keymaps and commands from nvim-tree.lua
      nvim_tree = true,
      op_nvim = true,
      smart_splits = {
        directions = { "h", "j", "k", "l" },
        mods = {
          -- for moving cursor between windows
          move = "<C>",
          -- for resizing windows
          resize = "<M>",
          -- for swapping window buffers
          swap = false, -- false disables creating a binding
        },
      },
      diffview = true,
    },
    autocmds = {
      {
        "VimLeave",
        ":silent !eslint_d stop",
        description = "Stop eslint_d",
        opts = {
          pattern = { "*.jsx", "*.tsx", "*.vue", "*.js", "*.ts" },
        },
      },
      {
        "VimLeave",
        ":silent !prettier_d_slim stop",
        description = "Stop prettier_d_slim",
        opts = {
          pattern = {
            "*.jsx",
            "*.tsx",
            "*.vue",
            "*.js",
            "*.ts",
            "*.css",
            "*.scss",
            "*.less",
            "*.html",
            "*.json",
            "*.jsonc",
            "*.yaml",
            "*.md",
            "*.mdx",
            "*.graphql",
          },
        },
      },
      {
        { "BufNewFile", "BufRead" },
        ":silent set filetype=glsl",
        description = "Set filetype to glsl",
        opts = {
          pattern = { "*.vert", "*.frag" },
        },
      },
      {
        { "User LspProgressStatusUpdated" },
        'lua require("lualine").refresh()',
        description = "Refresh Lualine",
        opts = {
          -- group = "lualine_augroup",
        },
      },
    },
    sort = {
      most_recent_first = true,
      user_items_first = true,
      item_type_bias = nil,
      frecency = {
        db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
        max_timestamps = 10,
      },
    },
  })
end

return M
