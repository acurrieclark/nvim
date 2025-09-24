return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  opts = { -- set to setup table
    tailwind = 'both',
    sass = { enable = false, parsers = { 'css' } },
  },
}
