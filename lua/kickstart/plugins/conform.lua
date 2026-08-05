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
      joelstein_blade = {
        command = 'vendor/bin/blade-format',
        args = { '$FILENAME' },
        stdin = false,
        cwd = function(self, ctx)
          return vim.fs.root(ctx.filename, { 'composer.json', '.git' })
        end,
      },
    },

    -- You can use 'stop_after_first' to run the first available formatter from the list
    formatters_by_ft = {
      nix = { 'alejandra' },
      python = { 'ruff_format' },
      lua = { 'stylua' },
      blade = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.root(bufname, { 'composer.json', '.git' })
        if root and vim.fn.executable(vim.fs.joinpath(root, 'vendor/bin/blade-format')) == 1 then
          return { 'joelstein_blade' }
        end
        return { 'blade-formatter', 'php_cs_fixer', stop_after_first = true }
      end,
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
      go = { 'gofmt' },
    },
  },
}
