-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Don't continue comments with o and O
local custom_o_formatting = vim.api.nvim_create_augroup('CustomOFormatting', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove { 'o' }
  end,
  group = custom_o_formatting,
})

-- Save all buffers when leaving nvim
vim.cmd [[
  augroup Autosave
    autocmd!
    autocmd BufLeave,FocusLost * silent! wall
  augroup END
]]
