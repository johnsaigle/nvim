return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
  config = function()
    local signs = require('gitsigns')
    signs.setup({
      current_line_blame = true,
    })
    vim.keymap.set('n', '<leader>bl', ':Gitsigns blame<CR>', { desc = '[G]itsigns [B][L]ame' })
    vim.keymap.set('n', '<leader>bn', ':Gitsigns blame_line<CR>', { desc = '[G]itsigns [B]lame Li[N]e' })
  end
}
