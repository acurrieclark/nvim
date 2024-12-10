-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- If a buffer is readonly enable close with q
-- and enable c-j and c-k to move up and down
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(event)
    if vim.bo[event.buf].readonly or not vim.api.nvim_get_option_value('modifiable', { buf = event.buf }) then
      vim.api.nvim_buf_set_keymap(0, 'n', '<c-j>', '<Down>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<c-k>', '<Up>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>Bdelete<cr>', { noremap = true, silent = true })
    end
  end,
  group = vim.api.nvim_create_augroup('ReadOnlyBuffers', { clear = true }),
})

-- Don't continue comments with o and O
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove 'o'
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
