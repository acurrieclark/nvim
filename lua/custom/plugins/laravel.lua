return {
  'adalessa/laravel.nvim',
  dependencies = {
    'tpope/vim-dotenv',
    'nvim-telescope/telescope.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
    'kevinhwang91/promise-async',
  },
  cmd = { 'Laravel' },
  keys = {
    { '<leader>Ll', function() Laravel.pickers.laravel() end, desc = 'Laravel: Master picker' },
    { '<leader>La', function() Laravel.pickers.artisan() end, desc = 'Laravel: Artisan' },
    { '<leader>Lr', function() Laravel.pickers.routes() end, desc = 'Laravel: Routes' },
    { '<leader>Lm', function() Laravel.pickers.make() end, desc = 'Laravel: Make' },
    { '<leader>Lc', function() Laravel.pickers.commands() end, desc = 'Laravel: Custom commands' },
    { '<leader>Lo', function() Laravel.pickers.resources() end, desc = 'Laravel: Resources' },
    { '<leader>Lt', function() Laravel.commands.run('actions') end, desc = 'Laravel: Code actions' },
    { '<leader>Lu', function() Laravel.commands.run('hub') end, desc = 'Laravel: Artisan Hub' },
    { '<leader>Lp', function() Laravel.commands.run('command_center') end, desc = 'Laravel: Command Center' },
    { '<leader>Lh', function() Laravel.run('artisan docs') end, desc = 'Laravel: Docs' },
    { '<c-g>', function() Laravel.commands.run('view:finder') end, desc = 'Laravel: View finder' },
  },
  event = { 'VeryLazy' },
  opts = {
    features = {
      pickers = {
        provider = 'telescope',
      },
    },
  },
  config = function(_, opts)
    require('laravel').setup(opts)
  end,
}
