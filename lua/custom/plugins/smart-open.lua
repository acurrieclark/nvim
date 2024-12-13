return {
  'danielfalk/smart-open.nvim',
  event = 'VimEnter',
  lazy = false,
  priority = 1000,
  branch = '0.2.x',
  opts = {},
  dependencies = {
    'kkharji/sqlite.lua',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = {
    {
      '<leader><leader>',
      function()
        require('telescope').extensions.smart_open.smart_open {
          cwd_only = true,
        }
      end,
    },
  },
}
