local disable_filetypes = { c = true, cpp = true }

-- Autoformat
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
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

    -- You can use 'stop_after_first' to run the first available formatter from the list
    formatters_by_ft = {
      lua = { 'stylua' },
      php = { 'php-cs-fixer' },
      blade = { 'blade-formatter', 'php-cs-fixer', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
