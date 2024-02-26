return {
  "smjonas/inc-rename.nvim",
  config = function() require("inc_rename").setup() end,
  keys = {
    {
      "<leader>r",
      function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      desc = "Rename",
      mode = { "n", "v" },
      expr = true
    },
  },
}
