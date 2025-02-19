return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function ()

    local oil = require('oil')
    oil.setup({})

    -- Alias for `:Oil`
    vim.keymap.set('n', '<leader>oi', '<cmd>Oil<cr>', {desc = 'Open Oil file explorer'})
  end
}
