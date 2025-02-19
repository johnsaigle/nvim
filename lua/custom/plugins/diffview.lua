return {
  'sindrets/diffview.nvim',
  config = function()
    local diffview = require('diffview')
    diffview.setup({})

    vim.keymap.set('n', '<leader>dvt', '<cmd>DiffviewToggleFiles<cr>', { desc = '[D]iff[V]iew [T]oggle Files' })
    vim.keymap.set('n', '<leader>dvc', '<cmd>DiffviewClose<cr>', { desc = '[D]iff[V]iew [C]lose' })
  end
}
