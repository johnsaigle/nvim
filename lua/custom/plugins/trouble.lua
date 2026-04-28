return {
  "folke/trouble.nvim",
  cmd = { 'Trouble' },
  keys = {
    { '<leader>xt', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Toggle trouble diagnostics' },
    {
      '<leader>xn',
      function()
        require('trouble').next({ skip_groups = false, jump = true })
      end,
      desc = 'Next trouble item',
    },
    {
      '<leader>xN',
      function()
        require('trouble').next({ skip_groups = true, jump = true })
      end,
      desc = 'Next trouble item by group',
    },
    {
      '<leader>xp',
      function()
        require('trouble').prev({ skip_groups = false, jump = true })
      end,
      desc = 'Previous trouble item',
    },
    {
      '<leader>xP',
      function()
        require('trouble').prev({ skip_groups = true, jump = true })
      end,
      desc = 'Previous trouble item by group',
    },
  },
  opts = {
    win = {
      wo = {
        wrap = true,
      },
    },
  },
  config = function()
    require('trouble').setup({})
  end
}
