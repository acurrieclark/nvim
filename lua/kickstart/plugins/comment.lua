-- "gc" to comment visual regions/lines
return {
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
}
