# Agent Guidelines for Neovim Configuration

## Build/Lint/Test Commands
- **Lint Lua code**: `stylua --check .` (format: `stylua .`)
- **No test framework** - this is a Neovim configuration, not a testable codebase
- **Check config**: Start nvim and run `:checkhealth` to verify configuration

## Code Style Guidelines
- **Language**: Lua only
- **Formatting**: Use StyLua with 2-space indentation, 160 column width, single quotes preferred
- **Structure**: Follow kickstart.nvim patterns - bootstrap/ for core config, custom/plugins/ for additions
- **Plugin format**: Return table with plugin spec, use `opts = {}` for simple configs, `init`/`config` functions for complex setup
- **Imports**: Use `require 'module'` (no parentheses), relative paths from lua/ directory
- **Variables**: Use snake_case, prefix vim options with `vim.o.` or `vim.opt.`
- **Comments**: Use `--` for single line, `--[[]]` for blocks, include help references like `:help option`
- **Error handling**: Use `vim.notify()` for user messages, `error()` for critical failures
- **Naming**: Plugin files match plugin name, use descriptive function names
- **Type annotations**: Use `---@type` annotations where helpful (e.g., `---@type vim.Option`)

## File Organization
- `init.lua`: Main entry point, plugin manager setup
- `lua/bootstrap/`: Core Neovim configuration (options, keymaps, autocommands)
- `lua/kickstart/plugins/`: Base plugins from kickstart.nvim
- `lua/custom/plugins/`: User-added plugins and customizations
- `after/ftplugin/`: Filetype-specific configurations