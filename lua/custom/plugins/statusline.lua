local mocha = require("catppuccin.palettes").get_palette "mocha"
return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  opts = {
    sections = {
      lualine_x = {
        {
          require("noice").api.status.mode.get,
          cond = require("noice").api.status.mode.has,
          color = { fg = mocha.red },
        },
        {
          require("noice").api.status.search.get,
          cond = require("noice").api.status.search.has,
          color = { fg = mocha.yellow, bg = mocha.surface0 },
        },
        {
          require("noice").api.status.command.get,
          cond = require("noice").api.status.command.has,
          color = { fg = "#999999" },
        },
        'filetype',
      },
    },
    options = {
      theme = 'catppuccin',
      section_separators = { left = '', right = '' },
      component_separators = '',
    },
  },
}
