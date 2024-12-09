-- [[ Basic Keymaps ]]

-- Clear search highlight on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode with <Esc><Esc>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev {
    severity = vim.diagnostic.severity.ERROR,
  }
end, { desc = 'Go to previous error' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next {
    severity = vim.diagnostic.severity.ERROR,
  }
end, { desc = 'Go to next error' })
vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_prev {
    severity = vim.diagnostic.severity.WARN,
  }
end, { desc = 'Go to previous warning' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_next {
    severity = vim.diagnostic.severity.WARN,
  }
end, { desc = 'Go to next warning' })
vim.keymap.set('n', '<leader>di', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- Quickly envoke the q macro
vim.keymap.set('n', 'Q', '@q')
vim.keymap.set('v', 'Q', ':norm @q<CR>')

-- Select next/previous buffer
vim.keymap.set('n', '<C-l>', ':wincmd w<CR>', { silent = true })
vim.keymap.set('n', '<C-h>', ':wincmd p<CR>', { silent = true })

-- Remap Accidental capitals
vim.cmd [[
  cnoreabbrev W w
  cnoreabbrev Wq wq
  cnoreabbrev WQ wq
  cnoreabbrev Q! q!
]]

-- When joining lines, keep the same cursor position
vim.keymap.set('n', 'J', 'mzJ`z')

-- When moving up and down the page, or searching, keep the cursor centred
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Move to just before the last character on the line and enter insert mode
vim.keymap.set('n', '<C-;>', '$i')

-- delete/change selection, but don't add to paste register
vim.keymap.set({ 'v' }, '<leader>d', [["_d]])
vim.keymap.set({ 'v' }, '<leader>c', [["_c]])

-- add a line above/below current line
vim.keymap.set('n', ']<space>', [[o<Esc>0"_Dk]])
vim.keymap.set('n', '[<space>', [[O<Esc>0"_Dj]])

-- Define the function to check if the current line is empty
local function is_line_empty()
  local line = vim.api.nvim_get_current_line()
  return line:gsub('%s', '') == ''
end

-- Function to input a sequence of keys
local function input_keys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'n', true)
end

-- Define the function to perform the custom "o" behavior
function CustomO()
  -- Check if the current line is empty or not
  if is_line_empty() then
    -- If the line is empty, add an additional new line below the new one
    input_keys 'o<Esc>O'
  else
    -- If the line has content, use the normal `o` command
    input_keys 'o'
  end
end

-- `o` behaves as expected on a line with content, but adds an additional line below if empty
vim.api.nvim_set_keymap('n', 'o', ':lua CustomO()<CR>', { noremap = true, silent = true })
