return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
    require('catppuccin').setup({
      transparent_background = true
    })
  end
}
