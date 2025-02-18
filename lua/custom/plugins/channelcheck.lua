return {
  {
    -- dir = vim.fn.expand('~/coding/channelcheck.nvim'),
    'johnsaigle/channelcheck.nvim',
    dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
    config = function()
      require('channelcheck').setup({})
    end
  }
}
