return {
  'vuki656/package-info.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  config = function()
    require('package-info').setup()
    pcall(require('telescope').load_extension, 'package-info')
  end,
  keys = {
    {
      '<leader>ns',
      function()
        require('package-info').show()
      end,
      desc = 'Show dependency versions',
      mode = 'n',
    },
    {
      '<leader>nc',
      function()
        require('package-info').hide()
      end,
      desc = 'Hide dependency versions',
      mode = 'n',
    },
    {
      '<leader>nt',
      function()
        require('package-info').toggle()
      end,
      desc = 'Toggle dependency versions',
      mode = 'n',
    },
    {
      '<leader>nu',
      function()
        require('package-info').update()
      end,
      desc = 'Update dependency on the line',
      mode = 'n',
    },
    {
      '<leader>nd',
      function()
        require('package-info').delete()
      end,
      desc = 'Delete dependency on the line',
      mode = 'n',
    },
    {
      '<leader>ni',
      function()
        require('package-info').install()
      end,
      desc = 'Install a new dependency',
      mode = 'n',
    },
    {
      '<leader>np',
      function()
        require('package-info').change_version()
      end,
      desc = 'Install a different dependency version',
      mode = 'n',
    },
  },
}
