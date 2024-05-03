-- Gopls configurations
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
require('lspconfig').gopls.setup({
  settings = {
    gopls = {
      version = "1.21.9", -- change depending on project (?)
      -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
      analyses = {
        shadow = true,
        unusedvariable = true
      },
      completeUnimported = true,
      staticcheck = true,
      errcheck = true,
      gosimple = true,
      -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
      hints = {
        assignVariableTypes = true,
        rangeVariableTypes = true,
      }
    }
  }
})
