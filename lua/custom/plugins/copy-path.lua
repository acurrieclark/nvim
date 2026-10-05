return {
  'hong4rc/copy-path.nvim',
  event = 'VeryLazy',
  opts = {
    -- Show vim.notify() after each copy (default: true)
    notify = true,

    -- which-key group label, or false to disable (default: "copy path")
    which_key_group = 'Yank',

    -- Prefix for :CopyPath* commands, or false to disable (default: "CopyPath")
    command_prefix = 'CopyPath',

    -- Picker backend: "auto", "snacks", "telescope", "fzf_lua", or false
    -- "auto" detects in order: snacks → telescope → fzf_lua → vim.ui.select
    picker = 'auto',

    -- Keymap to open the picker, or false to disable (default: "<leader>fP")
    picker_keymap = '<leader>yP',

    -- Keymap bindings per kind. Set to false to disable a keymap.
    keymaps = {
      relative = '<leader>yy', -- src/foo/Bar.tsx
      full = '<leader>yY', -- /home/user/project/src/foo/Bar.tsx
      filename = '<leader>yf', -- Bar.tsx
      line = '<leader>yl', -- src/foo/Bar.tsx:42
      line_full = '<leader>yL',
      github_line = '<leader>yg', -- https://github.com/.../Bar.tsx#L42
      github = '<leader>yG',
    },
  },
}
