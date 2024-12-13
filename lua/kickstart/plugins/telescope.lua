-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`

    local colors = require('catppuccin.palettes').get_palette()
    local TelescopeColor = {
      TelescopeMatching = { fg = colors.flamingo },
      TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
      TelescopeSelectionCaret = { fg = colors.text, bg = colors.surface0, bold = true },
      TelescopePromptPrefix = { fg = colors.pink },
      TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
      TelescopeResultsTitle = { fg = colors.mantle, bg = colors.teal },
      TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
    }

    for hl, col in pairs(TelescopeColor) do
      vim.api.nvim_set_hl(0, hl, col)
    end

    require('telescope').setup {
      extensions = {
        smart_open = {
          match_algorithm = 'fzf',
          result_limit = 100,
        },
        ['ui-select'] = {
          layout_strategy = 'center',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
            width = function(_, max_columns, _)
              return math.min(max_columns, 80)
            end,

            height = function(_, _, max_lines)
              return math.min(max_lines, 15)
            end,
            anchor = 'CENTER',
          },
          border = true,
          borderchars = {
            prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
            results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
            preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          },
        },
        fzf = {},
      },
      defaults = {
        path_display = { 'smart' },
        layout_strategy = 'vertical',
        layout_config = {
          anchor = 'N',
          mirror = true,
          width = 140,
          prompt_position = 'bottom',
          preview_cutoff = 1,
        },
        mappings = {
          i = {
            ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
            ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
            ['<Esc>'] = require('telescope.actions').close, -- close telescope
          },
        },
        prompt_prefix = '󱁴 ',

        selection_caret = ' ',
      },
      pickers = {
        lsp_references = {
          path_display = { 'smart' },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension 'smart_open')

    local telescope_functions = require 'telescope.functions'
    local builtin = require 'telescope.builtin'

    -- Telescope live_grep in git root
    -- Function to find the git root directory based on the current buffer's path
    local function find_git_root()
      -- Use the current buffer's path as the starting point for the git search
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir
      local cwd = vim.fn.getcwd()
      -- If the buffer is not associated with a file, return nil
      if current_file == '' then
        current_dir = cwd
      else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      -- Find the Git root directory from the current file's path
      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end
      return git_root
    end

    -- Custom live_grep function to search in git root
    local function live_grep_git_root()
      local git_root = find_git_root()
      if git_root then
        builtin.live_grep {
          path_display = { 'smart' },
          search_dirs = { git_root },
        }
      end
    end

    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>fr', telescope_functions.old_files, { desc = 'Recent Files' })
    vim.keymap.set('n', '<leader>fR', telescope_functions.all_old_files, { desc = 'All Recent Files' })
    vim.keymap.set('n', '<leader>fb', telescope_functions.buffers, { desc = 'Existing Buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    local function telescope_live_grep_open_files()
      builtin.live_grep {
        defaults = {
          path_display = { 'smart' },
        },
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end
    vim.keymap.set('n', '<leader>f/', telescope_live_grep_open_files, { desc = 'Grep [/] in Open Files' })
    vim.keymap.set('n', '<leader>fT', builtin.builtin, { desc = 'Find Telescope Methods' })
    vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Git Files' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'All Files' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find Current Word' })
    vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Grep' })
    vim.keymap.set('n', '<leader>fS', ':LiveGrepGitRoot<cr>', { desc = 'Grep on Git Root' })
    vim.keymap.set('n', '<leader>fp', builtin.resume, { desc = 'Resume Search' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>wd', builtin.diagnostics, { desc = 'Workplace Diagnostics' })
    vim.keymap.set('n', '<leader>dd', function()
      builtin.diagnostics {
        bufnr = 0,
      }
    end, { desc = 'Document Diagnostics' })
    vim.keymap.set('n', '<leader>ft', function()
      require('telescope._extensions.todo-comments').exports.todo {
        keywords = 'TODO',
      }
    end, { desc = 'Todo List' })
    vim.keymap.set('n', '<leader>ds', telescope_functions.document_symbols, { desc = 'Document Symbols' })
  end,
}
