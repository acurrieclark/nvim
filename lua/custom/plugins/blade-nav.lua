return {
  'ricardoramirezr/blade-nav.nvim',
  dependencies = { 'saghen/blink.cmp' },
  ft = { 'blade', 'php' }, -- optional, improves startup time
  opts = {
    integrations = {
      cmp = false, -- we use blink.cmp, not nvim-cmp
    },
  },
}
