local M = {}

M.config = function()
  local opts = { noremap = true, silent = true }
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  require("legendary").setup({
    keymaps = {
      { "<leader>LL", "<cmd>Legendary<CR>",          description = "Legendary", opts = opts },
      -- Leader key
      {
        "<Space>",
        "<Nop>",
        description = "Leader Key",
        opts = opts,
      },
      -- Window navigation
      {
        "<C-h>",
        "<C-w>h",
        description = "Navigate Window Left",
        opts = opts,
      },
      {
        "<C-j>",
        "<C-w>j",
        description = "Navigate Window Down",
        opts = opts,
      },
      {
        "<C-k>",
        "<C-w>k",
        description = "Navigate Window Up",
        opts = opts,
      },
      {
        "<C-l>",
        "<C-w>l",
        description = "Navigate Window Right",
        opts = opts,
      },
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
      {
        "<A-h>",
        ":resize -2<CR>",
        description = "Resize H-",
        opts = opts,
      },
      {
        "<A-l>",
        ":resize +2<CR>",
        description = "Resize  H+",
        opts = opts,
      },
      {
        "<A-j>",
        ":vertical resize -2<CR>",
        description = "Resize V-",
        opts = opts,
      },
      {
        "<A-k>",
        ":vertical resize +2<CR>",
        description = "Resize V+",
        opts = opts,
      },

      -- Move text up and down
      {
        "<A-j>",
        { v = ":m .+1<CR>==", x = ":move '>+1<CR>gv-gv" },
        description = "Move Text Down",
        opts = opts,
      },
      {
        "<A-k>",
        { v = ":m .-2<CR>==", x = ":move '<-2<CR>gv-gv" },
        description = "Move Text Up",
        opts = opts,
      },
      {
        "p",
        { v = '"_dP' },
        description = "Paste Text",
        opts = opts,
      },
      { "J",          { x = ":move '>+1<CR>gv-gv" }, opts = opts },
      { "K",          { x = ":move '<-2<CR>gv-gv" }, opts = opts },

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

      -- LSP & LSP Saga
      {
        "<C-s>",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
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
        { n = "<cmd>Lspsaga code_action<CR>", v = "<cmd>Lspsaga code_action<CR>" },
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
        "gt",
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
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        description = "LSPSaga Diagnostic Jump Prev",
        opts = opts,
      },
      {
        "<leader>dn",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
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
        "<cmd>Lspsaga hover_doc<CR>",
        description = "LSPSaga Hover Doc",
        opts = opts,
      },
      {
        "<leader>k",
        "<cmd>Lspsaga hover_doc ++keep<CR>",
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
      diffview = true,
    },
    sort = {
      -- sort most recently used item to the top
      most_recent_first = true,
      -- sort user-defined items before built-in items
      user_items_first = true,
      -- sort the specified item type before other item types,
      -- value must be one of: 'keymap', 'command', 'autocmd', 'group', nil
      item_type_bias = nil,
      -- settings for frecency sorting.
      -- https://en.wikipedia.org/wiki/Frecency
      -- Set `frecency = false` to disable.
      -- this feature requires sqlite.lua (https://github.com/kkharji/sqlite.lua)
      -- and will be automatically disabled if sqlite is not available.
      -- NOTE: THIS TAKES PRECEDENCE OVER OTHER SORT OPTIONS!
      frecency = {
        -- the directory to store the database in
        db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
        -- the maximum number of timestamps for a single item
        -- to store in the database
        max_timestamps = 10,
      },
    },
  })
end

return M
