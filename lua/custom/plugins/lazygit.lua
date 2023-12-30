vim.keymap.set('n', '<leader>gg', '<cmd>:LazyGit<cr>', { desc = 'LazyGit' })

return {
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
