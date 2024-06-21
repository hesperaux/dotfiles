
vim.cmd("set expandtab")
vim.cmd("set tabstop=8")
vim.cmd("set softtabstop=0")
vim.cmd("set shiftwidth=4 smarttab")
vim.cmd("set conceallevel=1")

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

vim.keymap.set('n', '<C-u>', '<C-u>zz', {})
vim.keymap.set('n', '<C-d>', '<C-d>zz', {})
vim.keymap.set('n', '<C-h>', '<C-w>h', {})
vim.keymap.set('n', '<C-j>', '<C-w>j', {})
vim.keymap.set('n', '<C-k>', '<C-w>k', {})
vim.keymap.set('n', '<C-l>', '<C-w>l', {})
vim.keymap.set('n', '<leader>sv', '<C-w>v<C-w>l', {})
vim.keymap.set('n', '<leader>sh', '<C-w>s<C-w>j', {})
vim.keymap.set('n', 'U', '<C-R>', {}) -- Redo command
vim.keymap.set('n', '<leader><', 'V`]<', {})
vim.keymap.set('n', '<leader>>', 'V`]>', {})
vim.keymap.set('n', "<C-W><C-W>", ":BufferClose<CR>", {})
vim.keymap.set("n", "<C-W>,", ":vertical resize -10<CR>", {noremap=true})
vim.keymap.set("n", "<C-W>.", ":vertical resize +10<CR>", {noremap=true})
vim.keymap.set('n', '<leader>eo', 'o<Esc>k', {})
vim.keymap.set('n', '<leader>eO', 'O<Esc>j', {})
vim.keymap.set('n', '<leader>nd', ':NoiceDismiss<CR>', {})

-- barbar shortcuts
-- Move to previous/next
vim.keymap.set('n', '<leader>n', '<Cmd>BufferPrevious<CR>', {})
vim.keymap.set('n', '<leader>N', '<Cmd>BufferNext<CR>', {})
vim.keymap.set('n', '<C-,>', '<Cmd>BufferPrevious<CR>', {})
vim.keymap.set('n', '<C-.>', '<Cmd>BufferNext<CR>', {})
-- vim.keymap.set('n', '<C-H>', '<Cmd>BufferPrevious<CR>', opts)
-- vim.keymap.set('n', '<C-L>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', {})
vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', {})
-- Goto buffer in position...
-- vim.keymap.set('n', '<C-1>', '<Cmd>BufferGoto 1<CR>', {})
-- vim.keymap.set('n', '<C-2>', '<Cmd>BufferGoto 2<CR>', {})
-- vim.keymap.set('n', '<C-3>', '<Cmd>BufferGoto 3<CR>', {})
-- vim.keymap.set('n', '<C-4>', '<Cmd>BufferGoto 4<CR>', {})
-- vim.keymap.set('n', '<C-5>', '<Cmd>BufferGoto 5<CR>', {})
-- vim.keymap.set('n', '<C-6>', '<Cmd>BufferGoto 6<CR>', {})
-- vim.keymap.set('n', '<C-7>', '<Cmd>BufferGoto 7<CR>', {})
-- vim.keymap.set('n', '<C-8>', '<Cmd>BufferGoto 8<CR>', {})
-- vim.keymap.set('n', '<C-9>', '<Cmd>BufferGoto 9<CR>', {})
-- vim.keymap.set('n', '<C-0>', '<Cmd>BufferLast<CR>', {})
-- Pin/unpin buffer
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', {})
-- Close buffer
-- vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', {})
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
-- vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>', {})
-- Sort automatically by...
vim.keymap.set('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', {})
vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', {})
vim.keymap.set('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', {})
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', {})
vim.keymap.set('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', {})

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
