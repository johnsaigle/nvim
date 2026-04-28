return {
  'stevearc/oil.nvim',
  cmd = { 'Oil' },
  keys = {
    { '<leader>oi', '<cmd>Oil<cr>', desc = 'Open Oil file explorer' },
  },
  ---@module 'oil'
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function ()

    local oil = require('oil')
    oil.setup({})

  end
}
