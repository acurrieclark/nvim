return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = true },
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      '<leader>N',
      function()
        local snacks = require 'snacks'
        snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
  },
}
