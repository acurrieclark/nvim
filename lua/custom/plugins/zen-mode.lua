return {
  "shortcuts/no-neck-pain.nvim",
  version = '*',
  config = function()
    require("no-neck-pain").setup({
      width = 120,
      autocmds = {
        enableOnVimEnter = true,
      },
      buffers = {
        colors = {
          background = "catppuccin-mocha",
        },
        right = {
          enabled = false,
        },
        wo = {
          fillchars = 'eob: ',
          winfixwidth = true,
        }
      },
      integrations = {
        NeoTree = {
          reopen = false
        }
      }
    });
  end
}
