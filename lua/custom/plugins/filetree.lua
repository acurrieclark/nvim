return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  config = function()
    require('neo-tree').setup {
      window = {
        position = 'float',
        mappings = {
          ['<space>'] = 'none',
        },
      },
      sources = {
        'filesystem',
        'buffers',
        'git_status',
        'document_symbols', -- <-- external sources need to be a fully qualified path to the module
      },
      filesystem = {
        hijack_netrw_behavior = 'disabled',
      },
    }
  end,
}
