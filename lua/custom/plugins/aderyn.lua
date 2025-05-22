
return {
  'johnsaigle/aderyn.nvim',
  dependencies = { 'nvimtools/none-ls.nvim' },
  config = function()
    local aderyn = require('aderyn-diagnostics')
    aderyn.setup({})

  end
}
