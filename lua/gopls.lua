-- Gopls configurations
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
require('lspconfig').gopls.setup({
  settings = {
    gopls = {
      -- version = "1.23.1", -- change depending on project (?)
      -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
      analyses = {
        shadow = true,
        defers = true,
        unusedparams = true,
        unusedvariable = true,
      },
      staticcheck = true,
      -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
      hints = {
        assignVariableTypes = true,
        rangeVariableTypes = true,
      },
    }
  }
})
