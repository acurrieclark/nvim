-- Useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup()

    require('which-key').add {
      { '<leader>C', '<cmd>bufdo :Bdelete<cr>', desc = 'Close All Buffers' },
      { '<leader>T', group = '[T]oggle' },
      { '<leader>T_', hidden = true },
      { '<leader>b', group = 'Buffer' },
      { '<leader>c', '<cmd>Bdelete<cr>', desc = 'Close Buffer' },
      { '<leader>d', group = 'Document' },
      { '<leader>e', group = 'Explorer' },
      { '<leader>eb', '<cmd>Neotree buffers<cr>', desc = 'Buffers' },
      { '<leader>ed', '<cmd>Neotree document_symbols<cr>', desc = 'Document Symbols' },
      { '<leader>ee', '<cmd>Neotree current reveal<cr>', desc = 'Open at Current File' },
      { '<leader>eg', '<cmd>Neotree git_status<cr>', desc = 'Git Status' },
      { '<leader>f', group = 'Find' },
      { '<leader>g', group = 'Git' },
      { '<leader>l', group = 'LSP' },
      { '<leader>n', group = 'NPM Dependencies' },
      { '<leader>o', '<cmd>OrganizeImports<cr>', desc = 'Organize Imports' },
      { '<leader>p', group = 'PHP' },
      { '<leader>s', '<cmd>lua require("persistence").load()<cr>', desc = 'Load Directory Session' },
      { '<leader>t', group = 'Tests' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>z', '<cmd>NoNeckPain<cr>', desc = 'Zen Mode' },
    }

  end,
}
