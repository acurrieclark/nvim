return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'master',
    },
    'windwp/nvim-ts-autotag',
  },
  branch = 'master',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'c',
        'cpp',
        'diff',
        'go',
        'lua',
        'luadoc',
        'python',
        'rust',
        'tsx',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'bash',
        'svelte',
        'html',
        'regex',
        'markdown_inline',
        'markdown',
        'query',
        'blade',
        'php',
        'json',
        'php_only',
      },

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = true,
      autotag = {
        enable = true,
      },
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }

    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config['blade'] = {
      install_info = {
        url = 'https://github.com/EmranMR/tree-sitter-blade',
        files = { 'src/parser.c' },
        branch = 'main',
      },
      filetype = 'blade',
    }
    vim.filetype.add {
      pattern = {
        ['.*%.antlers%.php'] = 'antlers.php',
        ['.*%.antlers%.html'] = 'antlers.html',
        ['.*%.blade%.php'] = 'blade',
      },
    }

    -- Workaround for Neovim 0.12: disable treesitter in markdown floating windows
    -- (LSP hover, signature help) to avoid "attempt to call method 'range'" crash.
    -- Normal markdown files (README.md, etc.) keep full treesitter highlighting.
    vim.api.nvim_create_autocmd('BufWinEnter', {
      callback = function(args)
        if vim.bo[args.buf].filetype == 'markdown' then
          local win = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative ~= '' then
            vim.treesitter.stop(args.buf)
          end
        end
      end,
    })
  end,
}
