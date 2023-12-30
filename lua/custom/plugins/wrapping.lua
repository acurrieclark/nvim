return {
  "andrewferrier/wrapping.nvim",
  config = function()
    require("wrapping").setup(
      {
        notify_on_switch = false
      }
    )
    require('wrapping').soft_wrap_mode()
  end
}
