return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = { 'svelte', 'blade' },
        }),
        null_ls.builtins.formatting.eslint_d,

        null_ls.builtins.completion.luasnip,
        null_ls.builtins.completion.tags,

        null_ls.builtins.diagnostics.php,
      }
    })
  end,
}
