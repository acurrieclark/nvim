vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.fn.sign_define("DiagnosticSignError",
      { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn",
      { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo",
      { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint",
      { text = "󰌵", texthl = "DiagnosticSignHint" })
    require('neo-tree').setup {
      window = {
        position = "float",
        mappings = {
          ["<space>"] = "none",
        }
      },
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols" -- <-- external sources need to be a fully qualified path to the module
      }
    }
  end,
}
