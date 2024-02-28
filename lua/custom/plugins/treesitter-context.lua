return {
  'nvim-treesitter/nvim-treesitter-context',
  opts = {
    max_lines = 3,
    separator = '━',
  },
  config = function(_, opts)
    require('treesitter-context').setup(opts or {})

    vim.keymap.set('n', '<leader>Tc', '<cmd>TSContextToggle<CR>', {
      desc = 'Toggle Treesitter Context',
    })
  end,
}
