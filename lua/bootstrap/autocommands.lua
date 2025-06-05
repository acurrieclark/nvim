-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- If a buffer is readonly enable close with q
-- and enable c-j and c-k to move up and down
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(event)
    if vim.bo[event.buf].readonly or not vim.api.nvim_get_option_value('modifiable', { buf = event.buf }) then
      vim.api.nvim_buf_set_keymap(0, 'n', '<c-j>', '<Down>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<c-k>', '<Up>', { noremap = true, silent = true })
      -- some buffers already have a q mapping
      if vim.o.filetype ~= 'neo-tree' then
        vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>q!<cr>', { noremap = true, silent = true })
      end
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

-- Open find files instead of netrw
local find_files_hijack_netrw = vim.api.nvim_create_augroup('find_files_hijack_netrw', { clear = true })
-- clear FileExplorer appropriately to prevent netrw from launching on folders
-- netrw may or may not be loaded before telescope-find-files
-- conceptual credits to nvim-tree and telescope-file-browser
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  once = true,
  callback = function()
    pcall(vim.api.nvim_clear_autocmds, { group = 'FileExplorer' })
  end,
})
vim.api.nvim_create_autocmd('VimEnter', {
  group = find_files_hijack_netrw,
  pattern = '*',
  callback = function()
    if vim.bo[0].filetype == 'netrw' or vim.fn.isdirectory(vim.fn.expand '%:p') == 0 then
      return
    end

    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = 0 })
    require('telescope').extensions.smart_open.smart_open {
      cwd_only = true,
    }
  end,
})
