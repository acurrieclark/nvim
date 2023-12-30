return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require("telescope").load_extension("ui-select")
  end,
}
