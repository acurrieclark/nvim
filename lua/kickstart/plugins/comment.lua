-- "gc" to comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  opts = {
    pre_hook = function()
      return vim.bo.commentstring
    end,
  },
  -- context dependent comments in files like svelte
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
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
