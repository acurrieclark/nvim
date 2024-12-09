local disable_filetypes = { c = true, cpp = true }

-- Autoformat
return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>F',
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        require('conform').format { async = true, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype] }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- filetypes to disable lsp_fallback formatting for
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,

    formatters_by_ft = {
      lua = { 'stylua' },
      php = { 'php-cs-fixer' },
      blade = { 'blade-formatter', 'php-cs-fixer' },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      javascript = { { 'prettierd', 'prettier' } },
      typescript = { { 'prettierd', 'prettier' } },
      svelte = { { 'prettierd', 'prettier' } },
    },
  },
}
