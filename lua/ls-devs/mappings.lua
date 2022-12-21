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

-- Resize
keymap("n", "<M-j>", ":resize -2<CR>", opts)
keymap("n", "<M-k>", ":resize +2<CR>", opts)
keymap("n", "<M-l>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-h>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
--[[ keymap("n", "<leader>mf", "<cmd>lua require('telescope').extensions.media_files.media_files<CR>", opts) ]]
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<C-y>", ":ToggleTerm<CR>", opts)
keymap("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<cr>", opts)

-- Rest-nvim
keymap("n", "<leader>rh", "<Plug>RestNvim", opts)
keymap("n", "<leader>rl", "<Plug>RestNvimLast", opts)
keymap("n", "<leader>rp", "<Plug>RestNvimPreview", opts)

-- DAP
keymap("n", "<leader>uo", "<cmd>lua require('dapui').toggle()<CR>", opts)
keymap("n", "<leader>uc", "<cmd>lua require('dapui').close()<CR>", opts)
keymap("n", "<leader>un", ":DapContinue<CR>", opts)
keymap("n", "<leader>ut", ":DapTerminate<CR>", opts)
keymap("n", "<leader>bb", ":DapToggleBreakpoint<CR>", opts)

-- JUKIT
-- Splits
keymap("n", "<leader>jo", "<cmd>call jukit#splits#output()<cr>", opts)
keymap("n", "<leader>jh", "<cmd>call jukit#splits#history()<cr>", opts)
keymap("n", "<leader>joh", "<cmd>call jukit#splits#output_and_history()<cr>", opts)
keymap("n", "<leader>joc", "<cmd>call jukit#close_output_split<cr>", opts)
keymap("n", "<leader>jhc", "<cmd>call jukit#splits#close_history()<cr>", opts)
keymap("n", "<leader>jcoh", "<cmd>call jukit#splits#close_output_and_history(1)<cr>", opts)
-- Cells
keymap("n", "<leader>jcc", "<cmd>call jukit#cells#create_below(0)<cr>", opts)
keymap("n", "<leader>jcC", "<cmd>call jukit#cells#create_above(0)<cr>", opts)
keymap("n", "<leader>jct", "<cmd>call jukit#cells#create_below(1)<cr>", opts)
keymap("n", "<leader>jcT", "<cmd>call jukit#cells#create_above(1)<cr>", opts)
keymap("n", "<leader>jcd", "<cmd>call jukit#cells#delete()<cr>", opts)
keymap("n", "<leader>jcm", "<cmd>call jukit#cells#merge_below()<cr>", opts)
keymap("n", "<leader>jcM", "<cmd>call jukit#cells#merge_above()<cr>", opts)
keymap("n", "<leader>jck", "<cmd>call jukit#cells#move_up()<cr>", opts)
keymap("n", "<leader>jcj", "<cmd>call jukit#cells#move_down()<cr>", opts)
keymap("n", "<leader>JJ", "<cmd>call jukit#cells#jump_to_next_cell()<cr>", opts)
keymap("n", "<leader>KK", "<cmd>call jukit#cells#jump_to_previous_cell()<cr>", opts)
keymap("n", "<leader>jdo", "<cmd>call jukit#cells#delete_outputs(0)<cr>", opts)
keymap("n", "<leader>jda", "<cmd>call jukit#cells#delete_outputs(1)<cr>", opts)
-- Send
keymap("n", "<leader>jss", "<cmd>call jukit#send#section(1)<cr>", opts)
keymap("n", "<leader>jsl", "<cmd>call jukit#send#line()<cr>", opts)
keymap("v", "<leader>jss", "<cmd>call jukit#send#selection()<cr>", opts)
keymap("n", "<leader>jsu", "<cmd>call jukit#send#until_current_section()<cr>", opts)
keymap("n", "<leader>jsa", "<cmd>call jukit#send#all()<cr>", opts)
-- Convert
keymap("n", "<leader>jcv", "<cmd>call jukit#convert#notebook_convert('jupyter-notebook')<cr>", opts)
