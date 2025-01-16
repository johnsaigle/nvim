-- Gopls configurations
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
require('lspconfig').gopls.setup({
  settings = {
    gopls = {
      -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
      analyses = {
        -- Configure analyses that aren't already enabled by default
        defers = true,
        shadow = true,
        unusedparams = true,
        unusedvariable = true,
      },
      staticcheck = true,
      -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
      hints = {
        assignVariableTypes = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    }
  }
})
