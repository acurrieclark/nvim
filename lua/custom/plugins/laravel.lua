return {
  'adibhanna/laravel.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
  -- cmd = { 'Artisan', 'Laravel*' },
  keys = {
    -- { "<leader>la", ":LaravelArtisan<cr>", desc = "Laravel Artisan" },
    -- { "<leader>lr", ":LaravelRoute<cr>", desc = "Laravel Routes" },
    -- { "<leader>lm", ":LaravelMake<cr>", desc = "Laravel Make" },
  },
  event = { 'VeryLazy' },
  config = function()
    require('laravel').setup()
  end,
}
