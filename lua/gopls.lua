-- Gopls configurations
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
require('lspconfig').gopls.setup({
  settings = {
    gopls = {
      version = "1.21.9", -- change depending on project (?)
      -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
      analyses = {
        shadow = true,
        defers = true,
        unusedparams = true,
        unusedvariable = true,
      },
      completeUnimported = true,
      errcheck = true,
      gocritic = true,
      gosimple = true,
      staticcheck = true,
      -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
      hints = {
        assignVariableTypes = true,
        rangeVariableTypes = true,
      },
      mnd = true,
      nilerr = true,
      nilnil = true,
      usestdlibvars = true,
    }
  }
})
