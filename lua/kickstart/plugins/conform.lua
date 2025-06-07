-- filetypes to disable lsp_fallback formatting for
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
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            async = true,
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_after_save = function(bufnr)
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        lsp_format = lsp_format_opt,
        async = true,
      }
    end,

    -- You can use 'stop_after_first' to run the first available formatter from the list
    formatters_by_ft = {
      nix = { 'alejandra' },
      python = { 'ruff_format' },
      lua = { 'stylua' },
      php = { 'php_cs_fixer' },
      blade = { 'blade-formatter', 'php_cs_fixer', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
      go = { 'gofmt' },
    },
  },
}
