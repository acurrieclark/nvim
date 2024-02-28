-- LSP Configuration & Plugins
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local builtin = require 'telescope.builtin'

        map('gd', function()
          builtin.lsp_definitions {
            defaults = {
              path_display = { 'smart' },
            },
          }
        end, '[G]oto [D]efinition')
        map('gr', function()
          builtin.lsp_references {
            defaults = {
              path_display = { 'smart' },
            },
          }
        end, '[G]oto [R]eferences')
        map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('gy', builtin.lsp_type_definitions, 'Type [D]efinition')

        map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Rename the variable under your cursor
        --  Most Language Servers support renaming across files, etc.
        map('<leader>R', vim.lsp.buf.rename, 'Rename')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<c-cr>', vim.lsp.buf.code_action, 'Code Action')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end

        map('<leader>F', function()
          vim.lsp.buf.format()
        end, 'Format current buffer with LSP')

        local svelte_hack_group = vim.api.nvim_create_augroup('svelte_ondidchangetsorjsfile', { clear = true })

        -- HACK: to make Svelte files work with LSP when updates are made to project ts files
        if client.name == 'svelte' then
          vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
            pattern = { '*.js', '*.ts' },
            callback = function(ctx)
              client.notify('$/onDidChangeTsOrJsFile', {
                uri = ctx.file,
                changes = {
                  { text = table.concat(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false), '\n') },
                },
              })
            end,
            group = svelte_hack_group,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local util = require 'lspconfig.util'
    -- TODO: Add keymap to organize imports in any language
    local function organize_imports_ts()
      local params = {
        command = '_typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = '',
      }
      vim.lsp.buf.execute_command(params)
    end

    local function organize_imports()
      vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
    end
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim

      svelte = {
        root_dir = function(fname)
          return util.root_pattern 'svelte.config.js'(fname) or util.root_pattern('package.json', 'tsconfig.json')(fname)
        end,
        commands = {
          OrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
          },
        },
      },
      denols = {
        root_dir = function(fname)
          return util.root_pattern('deno.json', 'deno.jsonc')(fname)
        end,
        commands = {
          OrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
          },
        },
      },
      emmet_ls = {
        filetypes = { 'antlers.php', 'antlers.html', 'antlers', 'blade.html.php', 'blade', 'html', 'sass', 'scss', 'html', 'css', 'svelte' },
      },
      eslint = {},
      tsserver = {
        filetypes = { 'javascript', 'typescript' },
        root_dir = function(fname)
          return util.root_pattern '.git'(fname) or util.root_pattern 'tsconfig.json'(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
        end,
        commands = {
          OrganizeImports = {
            organize_imports_ts,
            description = 'Organize Imports',
          },
        },
      },
      html = {
        filetypes = { 'antlers.php', 'antlers.html', 'antlers', 'blade.html.php', 'blade', 'html', 'svelte' },
      },
      intelephense = {
        commands = {
          OrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
          },
        },
      },
      tailwindcss = {},
      lua_ls = {
        settings = {
          Lua = {
            telemetry = { enable = false },
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              -- Tells lua_ls where to find all the Lua files that you have loaded
              -- for your neovim configuration.
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
              -- If lua_ls is really slow on your computer, you can try this instead:
              -- library = { vim.env.VIMRUNTIME },
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'blade-formatter', -- Used to format blade Files
      'prettierd', -- Used to format javascript and typescript files
      'php-cs-fixer', -- Used to format php files
      'stylua', -- Used to format lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          require('lspconfig')[server_name].setup {
            cmd = server.cmd,
            settings = server.settings,
            root_dir = server.root_dir,
            filetypes = server.filetypes,
            commands = server.commands,
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
          }
        end,
      },
    }

    -- Setup neovim lua configuration
    require('neodev').setup()
  end,
}
