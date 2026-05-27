return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = '[G]it Status (Neo[g]it)' },
  },
  opts = {
    integrations = {
      diffview = true,
    },
  },
}
