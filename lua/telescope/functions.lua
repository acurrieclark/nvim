local M = {}

function M.buffers(opts)
  opts = opts or {
    cwd_only = true,
    follow = true,
    sort_mru = true,
    ignore_current_buffer = true,
  }
  require('telescope.builtin').buffers(opts)
end

function M.resume(opts)
  opts = opts or {}
  require('telescope.builtin').resume(opts)
end

function M.all_old_files(opts)
  opts = opts or {}
  require('telescope.builtin').oldfiles(opts)
end

function M.old_files(opts)
  opts = opts or {
    cwd_only = true,
    follow = true,
  }
  opts.cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 and vim.lsp.get_clients()[1] then
    -- if not git then active lsp client root
    -- will get the configured root directory of the first attached lsp. You will have problems if you are using multiple lsps
    opts.cwd = vim.lsp.get_clients()[1].config.root_dir
  end
  require('telescope.builtin').oldfiles(opts)
end

function M.document_symbols()
  require('telescope.builtin').lsp_document_symbols {
    bufnr = 0,
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.6,
      height = 0.5,
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    ignore_filename = false,
  }
end

return M
