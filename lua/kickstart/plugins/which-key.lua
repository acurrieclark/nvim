-- Useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  config = function()
    require('which-key').register({
      s = {
        [[<cmd>lua require("persistence").load()<cr>]],
        'Load Directory Session',
      },
      z = {
        '<cmd>NoNeckPain<cr>',
        'Zen Mode',
      },
      o = {
        '<cmd>OrganizeImports<cr>',
        'Organize Imports',
      },
      e = {
        name = 'Explorer',
        e = { '<cmd>Neotree current reveal<cr>', 'Open at Current File' },
        g = { '<cmd>Neotree git_status<cr>', 'Git Status' },
        b = { '<cmd>Neotree buffers<cr>', 'Buffers' },
        d = { '<cmd>Neotree document_symbols<cr>', 'Document Symbols' },
      },
      g = {
        name = 'Git',
      },
      f = {
        name = 'Find',
      },
      d = {
        name = 'Document',
      },
      C = {
        '<cmd>bufdo :Bdelete<cr>',
        'Close All Buffers',
      },
      c = {
        '<cmd>Bdelete<cr>',
        'Close Buffer',
      },
      w = {
        name = '[W]orkspace',
      },
      T = { name = '[T]oggle', _ = 'which_key_ignore' },
      t = { name = 'Tests' },
    }, { prefix = '<leader>' })

    require('which-key').register({
      ['<leader>'] = { name = 'VISUAL <leader>' },
    }, { mode = 'v' })
  end,
}
