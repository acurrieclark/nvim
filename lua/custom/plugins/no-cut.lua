return {
  'maarutan/nvim-nocut',
  config = function()
    require('no-cut').setup {
      d = false, -- Remap 'd'
      x = false, -- Remap 'x' use x how 'd' with cut
      s = false, -- Keep default behavior for 's'
      c = true, -- Remap 'c'
      dd = false, -- Remap 'dd'
      D = false, -- Remap 'D'
      C = true, -- Remap 'C'
      S = false, -- Keep default behavior for 'S'
      visual_commands = {
        d = false,
        c = true,
      },
      paste_without_copy = true,
      exceptions = { 'Y' },
    }
  end,
}
