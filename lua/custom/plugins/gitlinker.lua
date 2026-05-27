return {
  'ruifm/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>gl', mode = { 'n', 'v' } },
  },
  config = function()
    require('gitlinker').setup {
      opts = {
        remote = nil,
      },
      mappings = '<leader>gl',
    }
  end,
}
