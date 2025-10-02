return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  opts = {
    user_default_options = {
      tailwind = 'both',
      sass = { enable = false, parsers = { 'css' } },
    },
  },
}
