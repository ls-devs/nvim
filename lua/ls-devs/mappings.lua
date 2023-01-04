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

-- Buffers
keymap("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", opts)
keymap("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", opts)
keymap("n", "<leader>bd", "<cmd>lua require('bufdelete').bufdelete(0, true)<CR>", opts)
keymap("n", "<leader>bm", "<cmd>BufferLineCloseRight<CR><cmd>BufferLineCloseLeft<CR>", opts)
keymap("n", "<leader>x", "<cmd>bd<CR>", opts)

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

-- Yank
keymap("v", "y", ":!xclip -f -sel clip<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- File explorer
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
keymap("n", "<leader>²", "<cmd>NvimTreeFocus<CR>", opts)
keymap("n", "<leader>tr", "<cmd>NvimTreeRefresh<CR>", opts)
keymap("n", "<leader>tc", "<cmd>NvimTreeClose<CR>", opts)
keymap("n", "<leader>to", "<cmd>NvimTreeCollapse<CR>", opts)

-- Git
keymap("n", "<leader>gs", "<cmd>lua require('telescope.builtin').git_status()<CR>", opts)
keymap("n", "<leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<CR>", opts)
keymap("n", "<leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<CR>", opts)
keymap("n", "<leader>gb", "<cmd>Git<CR>", opts)
keymap("n", "<leader>gr", "<cmd>Gread<CR>", opts)

-- Diff view
keymap("n", "<leader>do", "<cmd>DiffviewOpen<CR>", opts)
keymap("n", "<leader>dc", "<cmd>DiffviewClose<CR>", opts)

-- Hop
keymap("n", "<leader>hh", "<cmd>HopChar2<cr>", opts)
keymap("n", "<leader>hf", "<cmd>HopChar1<cr>", opts)
keymap("n", "<leader>hp", "<cmd>HopPattern<cr>", opts)
keymap("n", "<leader>hl", "<cmd>HopLineStart<cr>", opts)
keymap("n", "<leader>hv", "<cmd>HopVertical<cr>", opts)
keymap("n", "<leader>hw", "<cmd>HopWord<cr>", opts)

-- Packer
keymap("n", "<leader>pS", "<cmd>PackerSync<CR>", opts)
keymap("n", "<leader>pI", "<cmd>PackerInstall<CR>", opts)
keymap("n", "<leader>pU", "<cmd>PackerUpdate<CR>", opts)
keymap("n", "<leader>pC", "<cmd>PackerCompile<CR>", opts)

-- Typescript
keymap("n", "<leader>ta", "<cmd>TypescriptAddMissingImports<CR>", opts)
keymap("n", "<leader>to", "<cmd>TypescriptOrganizeImports<CR>", opts)
keymap("n", "<leader>tu", "<cmd>TypescriptRemoveUnused<CR>", opts)
keymap("n", "<leader>tf", "<cmd>TypescriptFixAll<CR>", opts)
keymap("n", "<leader>tg", "<cmd>TypescriptGoToSourceDefinition<CR>", opts)
keymap("n", "<leader>tr", "<cmd>TypescriptRenameFile<CR>", opts)

-- Terminal
keymap("n", "<C-y>", ":ToggleTerm<CR>", opts)

-- Markdown
keymap("n", "<leader>md", "<cmd>Glow<CR>", opts)

-- No Highlight
keymap("n", "<leader>nh", "<cmd>nohl<CR>", opts)

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
keymap("n", "<leader>jo", "<cmd>call jukit#splits#output()<CR>", opts)
keymap("n", "<leader>jh", "<cmd>call jukit#splits#history()<CR>", opts)
keymap("n", "<leader>joh", "<cmd>call jukit#splits#output_and_history()<CR>", opts)
keymap("n", "<leader>jco", "<cmd>call jukit#splits#close_output_split()<CR>", opts)
keymap("n", "<leader>jch", "<cmd>call jukit#splits#close_history()<CR>", opts)
keymap("n", "<leader>jca", "<cmd>call jukit#splits#close_output_and_history(1)<CR>", opts)
keymap("n", "<leader>jhj", "<cmd>call jukit#splits#out_hist_scroll(1)<cr><CR>", opts)
keymap("n", "<leader>jhk", "<cmd>call jukit#splits#out_hist_scroll(0)<cr><CR>", opts)
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
