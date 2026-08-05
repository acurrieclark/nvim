-- "gc" to comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  opts = {
    pre_hook = function(ctx)
      local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
      if not ok or not parser then
        return vim.bo.commentstring
      end

      local ts_ok, ts_commentstring = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if not ts_ok then
        return vim.bo.commentstring
      end

      return ts_commentstring.create_pre_hook()(ctx)
    end,
  },
  -- context dependent comments in files like svelte
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
      custom_calculation = function(_, language_tree)
        if vim.bo.filetype == 'blade' and language_tree._lang ~= 'javascript' then
          return '{{-- %s --}}'
        elseif (vim.bo.filetype == 'antlers.php' or vim.bo.filetype == 'antlers.html') and language_tree._lang ~= 'javascript' then
          return '{{# %s #}}'
        end
      end,
    },
  },
}
