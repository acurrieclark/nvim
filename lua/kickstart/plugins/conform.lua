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

    formatters = {
      pint_blade = {
        inherit = 'pint',
        prepend_args = { '--blade' },
      },
    },

    -- You can use 'stop_after_first' to run the first available formatter from the list
    formatters_by_ft = {
      nix = { 'alejandra' },
      python = { 'ruff_format' },
      lua = { 'stylua' },
      blade = { 'pint_blade' },
      php = function(bufnr)
        local clients = vim.lsp.get_clients { bufnr = bufnr }
        for _, client in ipairs(clients) do
          if client.supports_method('textDocument/formatting', { bufnr = bufnr }) then
            return {}
          end
        end
        return { 'pint' }
      end,
      javascript = { 'oxfmt' },
      typescript = { 'oxfmt' },
      svelte = { 'oxfmt' },
      css = { 'oxfmt' },
      json = { 'oxfmt' },
      html = { 'oxfmt' },
      markdown = { 'oxfmt' },
      go = { 'gofmt' },
    },
  },
}
