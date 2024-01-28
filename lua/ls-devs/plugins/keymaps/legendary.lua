return {
  "mrjones2014/legendary.nvim",
  event = "VeryLazy",
  dependencies = {
    { "kkharji/sqlite.lua" },
    {
      "mrjones2014/smart-splits.nvim",
      event = "VeryLazy",
      build = "./kitty/install-kittens.bash",
      opts = {
        resize_mode = {
          silent = true,
          hooks = {
            on_enter = function()
              vim.notify("Entering resize mode")
            end,
            on_leave = function()
              vim.notify("Exiting resize mode, bye")
            end,
          },
        },
      },
    },
  },
  config = function()
    local opts = { noremap = true, silent = true }

    local is_diag_for_cur_pos = function()
      local diagnostics = vim.diagnostic.get(0)
      local pos = vim.api.nvim_win_get_cursor(0)
      if #diagnostics == 0 then
        return false
      end
      local message = vim.tbl_filter(function(d)
        return d.col == pos[2] and d.lnum == pos[1] - 1
      end, diagnostics)
      return #message > 0
    end

    local open_help_tab = function(help_cmd, topic)
      vim.cmd.tabe()
      local winnr = vim.api.nvim_get_current_win()
      vim.cmd("silent! " .. help_cmd .. " " .. topic)
      vim.api.nvim_win_close(winnr, false)
    end

    require("legendary").setup({
      keymaps = {
        -- Legendary
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
        -- Switch both lines down
        {
          "<A-j>",
          { v = "<cmd>m .+1<CR>==", x = "<cmd>move '>+1<CR>gv-gv" },
          description = "Switch Lines Down",
          opts = opts,
        },
        -- Switch both lines up
        {
          "<A-k>",
          { v = "<cmd>m .-2<CR>==", x = "<cmd>move '<-2<CR>gv-gv" },
          description = "Switch Lines Up",
          opts = opts,
        },
        -- Paste
        {
          "p",
          { v = '"_dP' },
          description = "Paste Text",
          opts = opts,
        },
        -- Move line(s) down
        { "J", { x = ":move '>+1<CR>gv-gv" }, opts = opts },
        -- Move line(s) up
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
        -- Grep help
        {
          "<leader>hg",
          function()
            vim.ui.input({ prompt = "Grep help for: " }, function(input)
              if input == "" or not input then
                return
              end
              open_help_tab("helpgrep", input)
              if #vim.fn.getqflist() > 0 then
                vim.cmd.copen()
              end
            end)
          end,
          description = "Help Grep",
        },
        -- Ufo
        {
          "zR",
          function()
            require("ufo").openAllFolds()
          end,
          description = "UFO Open All Folds",
        },
        {
          "zM",
          function()
            require("ufo").closeAllFolds()
          end,
          description = "UFO Close All Folds",
        },
        {
          "<leader>p",
          function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
              vim.lsp.buf.hover()
            end
          end,
          description = "UFO Peek Under Cursor",
        },
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
          "<cmd>Lspsaga finder<CR>",
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
          "<leader>rnw",
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
            if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
              return require("lspsaga.diagnostic"):goto_prev()
            end
          end,
          description = "LSPSaga Diagnostic Jump Prev",
          opts = opts,
        },
        {
          "<leader>dn",
          function()
            if vim.bo.filetype ~= "cpp" or vim.bo.filetype ~= "c" then
              return require("lspsaga.diagnostic"):goto_next()
            end
          end,
          description = "LSPSaga Diagnostic Jump Next",
          opts = opts,
        },
        {
          "<leader>lo",
          "<cmd>Lspsaga outline<CR>",
          description = "LSPSaga Outline",
          opts = opts,
        },
        {
          "K",
          function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if winid then
              return
            end
            local ft = vim.bo.filetype
            if vim.tbl_contains({ "vim", "help" }, ft) then
              vim.cmd("silent! h " .. vim.fn.expand("<cword>"))
            elseif vim.tbl_contains({ "man" }, ft) then
              vim.cmd("silent! Man " .. vim.fn.expand("<cword>"))
            elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
              require("crates").show_popup()
            elseif is_diag_for_cur_pos() then
              vim.diagnostic.open_float()
            else
              vim.lsp.buf.hover()
            end
          end,
          description = "LSP Hover Doc",
          opts = opts,
        },
        {
          "<leader>K",
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
        -- Noice scroll doc forward
        {
          "<c-f>",
          function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end,
          mode = { "n", "i", "s" },
          description = "Noice Scroll Hover Doc Forward",
          opts = opts,
        },
        -- Noice scroll doc backward
        {
          "<c-b>",
          function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-f>"
            end
          end,
          mode = { "n", "i", "s" },
          description = "Noice Scroll Hover Doc Backward",
          opts = opts,
        },
        -- Noice Redirects
        {
          "<S-Enter>",
          function()
            require("noice").redirect(vim.fn.getcmdline())
          end,
          mode = { "c" },
          description = "Redirect Cmdline",
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
        -- LazyGit
        {
          "<leader>lg",
          function()
            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
              cmd = "lazygit",
              direction = "float",
              float_opts = {
                border = "rounded",
              },
              on_open = function(term)
                local keymap = vim.api.nvim_buf_set_keymap
                keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
              end,
            })
            lazygit:toggle()
          end,
          description = "LazyGit",
        },
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
        lazy_nvim = { auto_register = true },
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
          "LspAttach",
          'lua require("null-ls").enable({})',
          description = "Start null-ls when starting a lsp client",
        },
        {
          "VimLeave",
          ":silent !prettierd stop",
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
          "VimLeave",
          ":silent !prettierd stop",
          description = "Stop prettierd",
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
          { "InsertEnter", "InsertChange" },
          'lua require("notify").dismiss({ silent = true })',
          pattern = "*",
          description = "Notify dismiss",
        },
        {
          "TabLeave",
          function()
            if vim.fn.exists(":WindowsEnableAutowidth") > 0 then
              vim.cmd(":WindowsEnableAutowidth")
            end
            if vim.fn.exists(":OverseerClose") > 0 then
              vim.cmd(":OverseerClose")
            end
            if vim.fn.exists(":AerialClose") > 0 then
              vim.cmd(":AerialClose")
            end
          end,
          description = "TabLeave Close Overseer",
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
  end,
}