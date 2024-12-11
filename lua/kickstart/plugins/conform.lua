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
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        require('conform').format { async = true, lsp_format = lsp_format_opt }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
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
    },
  },
}
