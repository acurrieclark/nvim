-- "gc" to comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  opts = {
    pre_hook = function()
      print 'Setting up Comment.nvim'
      return vim.bo.commentstring
    end,
  },
  config = function(_, opts)
    print 'Setting up Comment.nvim from config.lua'
    require('Comment').setup(opts)

    local ft = require 'Comment.ft'
    ft.set('blade', { '{{-- %s --}}', '{{-- %s --}}' })
    ft.set('antlers', { '{{# %s #}}', '{{# %s #}}' })
  end,
  -- context dependent comments in files like svelte
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
}
