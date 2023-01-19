-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to space
vim.g.mapleader = ' '

-- Disable arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

-- Map resize windows
map('n', '<C-up>', ':resize +2<CR>')
map('n', '<C-down>', ':resize -2<CR>')
map('n', '<C-left>', ':vertical resize -2<CR>')
map('n', '<C-right>', ':vertical resize +2<CR>')

-- Go to another tab
map('n', 't1', ':tabn 1<CR>')
map('n', 't2', ':tabn 2<CR>')
map('n', 't3', ':tabn 3<CR>')
map('n', 't4', ':tabn 4<CR>')
map('n', 't5', ':tabn 5<CR>')
map('n', 't6', ':tabn 6<CR>')
map('n', 't7', ':tabn 7<CR>')
map('n', 't8', ':tabn 8<CR>')
map('n', 't9', ':tabn 9<CR>')

map('n', '<leader>t', '<cmd>TransparentToggle<cr>')

-- Manipulate tabs
map('n', 'tt', ':tabnew<CR>')
map('n', 'tc', ':tabclose<CR>')

-- Open the error list
map('n', 'co', ':copen<CR>')
map('n', 'cd', ':cclose<CR>')

-- Map the windows funcions
map('n', '<leader>%', ':vsplit<CR>')
map('n', '<leader>\"', ':split<CR>')

-- Map the fzf
map('n', '<F4>', ':Files<CR>')
-- map('n', '<F5>', ':Buffers<CR>')
-- map('n', '<F6>', ':Tags<CR>')
map('n', '<F7>', ':Snippets<CR>')
-- map('n', '<F8>', ':History:<CR>')
-- map('n', '<F11>', ':Colors<CR>')

map('n', '<F2>', '<cmd>Telescope find_files<cr>')
map('n', '<F5>', '<cmd>Telescope buffers<cr>')
map('n', '<F6>', '<cmd>Telescope live_grep<cr>')

-- HL search toggle
map('n', '<F10>', '<cmd>set hlsearch!<cr>')


-- Exit with jk
map('i', 'jk', '<esc>')

-- Remap the tests
map('n', '<leader>ta', '<cmd>TestSuite<cr>')
map('n', '<leader>tn', '<cmd>TestNearest<cr>')
map('n', '<leader>tf', '<cmd>TestFile<cr>')
map('n', '<leader>tl', '<cmd>TestLast<cr>')
