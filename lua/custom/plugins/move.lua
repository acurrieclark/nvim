local opts = { noremap = true, silent = true }
-- Normal-mode commands
vim.keymap.set('n', '<c-j>', ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', '<c-k>', ':MoveLine(-1)<CR>', opts)

vim.keymap.set('v', '<c-j>', ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', '<c-k>', ':MoveBlock(-1)<CR>', opts)

return {
  'fedepujol/move.nvim'
}
