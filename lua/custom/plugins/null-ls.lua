local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = { "svelte" },
        }),
        null_ls.builtins.completion.luasnip,
        null_ls.builtins.completion.tags,

        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.eslint_d,

        null_ls.builtins.diagnostics.php,
      },
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })
  end,
}
