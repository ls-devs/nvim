local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Resize
keymap("n", "<M-j>", ":resize -2<CR>", opts)
keymap("n", "<M-k>", ":resize +2<CR>", opts)
keymap("n", "<M-l>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-h>", ":vertical resize +2<CR>", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- File explorer
keymap("n", "<leader>e", "<cmd>NeoTreeFloatToggle<CR>", opts)
keymap("n", "<leader>to", "<cmd>NeoTreeShow<CR>", opts)
keymap("n", "<leader>tc", "<cmd>NeoTreeClose<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
keymap("n", "<leader>fp", "<cmd>Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fa", "<cmd>Telescope autocommands<CR>", opts)
keymap("n", "<leader>fc", "<cmd>Telescope commands<CR>", opts)
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", opts)
keymap("n", "<leader>fF", "<cmd>Telescope filetypes<CR>", opts)
keymap("n", "<leader>fo", "<cmd>Telescope vim_options<CR>", opts)
keymap("n", "<leader>fH", "<cmd>Telescope highlights<CR>", opts)
keymap("n", "<leader>fB", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
keymap("n", "<leader>fC", "<cmd>Telescope command_history<CR>", opts)
keymap("n", "<leader>fM", "<cmd>Telescope marks<CR>", opts)
keymap("n", "<leader>tm", "<cmd>Telescope media_files<CR>", opts)
keymap("n", "<leader>gs", "<cmd>lua require('telescope.builtin').git_status()<CR>", opts)
keymap("n", "<leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<CR>", opts)
keymap("n", "<leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<CR>", opts)

-- LSP
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>", opts)
keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

-- Lazy
keymap("n", "<leader>l", "<cmd>Lazy<CR>", opts)
keymap("n", "<leader>ls", "<cmd>Lazy sync<CR>", opts)
keymap("n", "<leader>li", "<cmd>Lazy install<CR>", opts)
keymap("n", "<leader>lu", "<cmd>Lazy update<CR>", opts)
keymap("n", "<leader>lc", "<cmd>Lazy build<CR>", opts)

-- Trouble
keymap("n", "<leader>v", "<cmd>Trouble<CR>", opts)

-- Todo
keymap("n", "<leader>T", "<cmd>TodoTrouble<CR>", opts)
keymap("n", "<leader>tt", "<cmd>TodoTelescope<CR>", opts)

-- JUKIT
-- Splits
keymap("n", "<leader>jjo", "<cmd>call jukit#splits#output()<CR>", opts)
keymap("n", "<leader>jjh", "<cmd>call jukit#splits#history()<CR>", opts)
keymap("n", "<leader>joh", "<cmd>call jukit#splits#output_and_history()<CR>", opts)
keymap("n", "<leader>jco", "<cmd>call jukit#splits#close_output_split()<CR>", opts)
keymap("n", "<leader>jch", "<cmd>call jukit#splits#close_history()<CR>", opts)
keymap("n", "<leader>jca", "<cmd>call jukit#splits#close_output_and_history(1)<CR>", opts)
keymap("n", "<leader>jhj", "<cmd>call jukit#splits#out_hist_scroll(1)<CR>", opts)
keymap("n", "<leader>jhk", "<cmd>call jukit#splits#out_hist_scroll(0)<CR>", opts)
keymap("n", "<leader>jht", "<cmd>call jukit#splits#toggle_auto_hist()<CR>", opts)
-- Cells
keymap("n", "<leader>jcc", "<cmd>call jukit#cells#create_below(0)<CR>", opts)
keymap("n", "<leader>jcC", "<cmd>call jukit#cells#create_above(0)<CR>", opts)
keymap("n", "<leader>jct", "<cmd>call jukit#cells#create_below(1)<CR>", opts)
keymap("n", "<leader>jcT", "<cmd>call jukit#cells#create_above(1)<CR>", opts)
keymap("n", "<leader>jcd", "<cmd>call jukit#cells#delete()<CR>", opts)
keymap("n", "<leader>jcm", "<cmd>call jukit#cells#merge_below()<CR>", opts)
keymap("n", "<leader>jcM", "<cmd>call jukit#cells#merge_above()<CR>", opts)
keymap("n", "<leader>jck", "<cmd>call jukit#cells#move_up()<CR>", opts)
keymap("n", "<leader>jcj", "<cmd>call jukit#cells#move_down()<CR>", opts)
keymap("n", "<leader>JJ", "<cmd>call jukit#cells#jump_to_next_cell()<CR>", opts)
keymap("n", "<leader>KK", "<cmd>call jukit#cells#jump_to_previous_cell()<CR>", opts)
keymap("n", "<leader>jdo", "<cmd>call jukit#cells#delete_outputs(0)<CR>", opts)
keymap("n", "<leader>jd", "<cmd>call jukit#cells#delete_outputs(1)<CR>", opts)
-- Send
keymap("n", "<leader>jss", "<cmd>call jukit#send#section(1)<CR>", opts)
keymap("n", "<leader>jsl", "<cmd>call jukit#send#line()<CR>", opts)
keymap("v", "<leader>jss", "<cmd>call jukit#send#selection()<CR>", opts)
keymap("n", "<leader>jsu", "<cmd>call jukit#send#until_current_section()<CR>", opts)
keymap("n", "<leader>jsa", "<cmd>call jukit#send#all()<CR>", opts)
-- Convert
keymap("n", "<leader>jcv", "<cmd>call jukit#convert#notebook_convert('jupyter-notebook')<CR>", opts)
