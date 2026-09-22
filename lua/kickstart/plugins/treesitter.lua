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
      indent = { enable = true, disable = { 'ruby', 'typescript', 'tsx', 'svelte' } },
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
        ['.*%.coln'] = 'coln',
      },
    }

    -- Workaround for Neovim 0.12: the markdown injection directive can receive
    -- an invalid node and crash with "attempt to call method 'range'".
    -- Override it to gracefully skip injection when the node is unusable.
    local non_filetype_match_injection_language_aliases = {
      ex = 'elixir',
      pl = 'perl',
      sh = 'bash',
      uxn = 'uxntal',
      ts = 'typescript',
    }
    local function get_parser_from_markdown_info_string(injection_alias)
      local match = vim.filetype.match { filename = 'a.' .. injection_alias }
      return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
    end
    require('vim.treesitter.query').add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
      local capture_id = pred[2]
      local node = match[capture_id]
      if not node then
        return
      end
      local ok, injection_alias = pcall(function()
        return vim.treesitter.get_node_text(node, bufnr):lower()
      end)
      if not ok or not injection_alias then
        return
      end
      metadata['injection.language'] = get_parser_from_markdown_info_string(injection_alias)
    end, { force = true, all = false })
  end,
}
