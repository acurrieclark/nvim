-- LSP Configuration & Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Provide JSON schemas for LSPs
      'b0o/schemastore.nvim',

      -- Allows extra capabilities provided by nvim-cmp
      'saghen/blink.cmp',
    },
    config = function()
      local log = require 'vlog'
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
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

          map('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Lesser used LSP functionality
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>lR', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<c-cr>', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

          map('<leader>lr', ':LspRestart<CR>', 'Restart LSP Server')

          map('<leader>lf', function()
            vim.lsp.buf.format()
          end, 'Format current buffer with LSP')

          -- The following autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = ev.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>Th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- HACK: to make Svelte files work with LSP when updates are made to project ts files
          if client and client.name == 'svelte' then
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
              group = vim.api.nvim_create_augroup('svelte_ondidchangetsorjsfile', { clear = true }),
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

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
        vim.lsp.buf.code_action {
          context = { only = { 'source.organizeImports' } },
          apply = true,
          filter = function(action)
            log.debug(action.kind)
            return action.title == 'Organize Imports'
          end,
        }
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
        ruff = {
          on_attach = function(client)
            if client.name == 'ruff' then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end,
        },
        gopls = {},
        pyright = {
          settings = {
            pyright = {
              autoImportCompletion = true,
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
              },
            },
          },
        },
        ts_ls = {
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
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
            },
          },
        },
        html = {
          filetypes = { 'antlers.php', 'antlers.html', 'antlers', 'blade.html.php', 'blade', 'html', 'svelte' },
        },
        nil_ls = {},
        rust_analyzer = {},
        intelephense = {
          commands = {
            IntelephenseIndex = {
              function()
                vim.lsp.buf.execute_command { command = 'intelephense.index.workspace' }
              end,
            },
          },
        },
        tailwindcss = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
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
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
