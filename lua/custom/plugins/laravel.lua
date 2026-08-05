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
    { '<leader>Ll', function() require('laravel').commands.run('laravel') end, desc = 'Laravel: Master picker' },
    { '<leader>La', function() require('laravel').commands.run('artisan') end, desc = 'Laravel: Artisan' },
    { '<leader>Lr', function() require('laravel').commands.run('routes') end, desc = 'Laravel: Routes' },
    { '<leader>Lm', function() require('laravel').commands.run('make') end, desc = 'Laravel: Make' },
    { '<leader>Lc', function() require('laravel').commands.run('commands') end, desc = 'Laravel: Custom commands' },
    { '<leader>Lo', function() require('laravel').commands.run('resources') end, desc = 'Laravel: Resources' },
    { '<leader>Lt', function() require('laravel').commands.run('actions') end, desc = 'Laravel: Code actions' },
    { '<leader>Lu', function() require('laravel').commands.run('hub') end, desc = 'Laravel: Artisan Hub' },
    { '<leader>Lp', function() require('laravel').commands.run('command_center') end, desc = 'Laravel: Command Center' },
    { '<leader>Lh', function() require('laravel').commands.run('docs') end, desc = 'Laravel: Docs' },
    { '<c-g>', function() require('laravel').commands.run('view:finder') end, desc = 'Laravel: View finder' },
    {
      'gf',
      function()
        local laravel = require('laravel')
        if laravel.app('gf').cursorOnResource() then
          return '<cmd>lua require("laravel").commands.run("gf")<cr>'
        end
        return 'gf'
      end,
      expr = true,
      noremap = true,
      desc = 'Laravel: Go to resource',
    },
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
    vim.g.Laravel = require('laravel')
  end,
}
