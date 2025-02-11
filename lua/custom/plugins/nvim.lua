return {
  -- [[ Macros for writing Neovim plugins (lua) ]]
  -- Insert `vim.notify(...)` and move cursor to the first argument.
  vim.keymap.set('n', '<leader>vn', 'ovim.notify("", vim.log.levels.WARN)<Esc>2F"ci"'),
}
