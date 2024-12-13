return {
  'phpactor/phpactor',
  enabled = false,
  build = 'composer install --no-dev --optimize-autoloader',
  ft = 'php',
  keys = {
    { '<Leader>pm', ':PhpactorContextMenu<CR>', desc = 'Context Menu' },
    { '<Leader>pn', ':PhpactorClassNew<CR>', desc = 'New Class' },
  },
}
