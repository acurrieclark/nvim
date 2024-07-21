-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- If a buffer is readonly enable close with q and esc
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(event)
    if vim.bo[event.buf].readonly or not vim.api.nvim_buf_get_option(event.buf, 'modifiable') then
      vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>q!<cr>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<esc>', '<cmd>q!<cr>', { noremap = true, silent = true })
    end
  end,
  group = vim.api.nvim_create_augroup('ReadOnlyClose', { clear = true }),
})

-- Don't continue comments with o and O
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove { 'o' }
  end,
  group = vim.api.nvim_create_augroup('CustomOFormatting', { clear = true }),
})

-- Save all buffers when leaving nvim
vim.cmd [[
  augroup Autosave
    autocmd!
    autocmd BufLeave,FocusLost * silent! wall
  augroup END
]]
