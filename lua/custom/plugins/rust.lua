-- Previous rust-analyzer manual config for init.lua
-- Disabled because rustaceannvim takes care of this automatically and warns against manually
-- calling setup. Leaving it here in case I want to disable rustaceannvim later for some reason
-- require'lspconfig'.rust_analyzer.setup{
--   settings = {
--     ['rust-analyzer'] = {
--       diagnostics = {
--         enable = true;
--       }
--     }
--   }
-- }

return {
  "mrcjkb/rustaceanvim",
  version = "4.24.0",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    {
      "lvimuser/lsp-inlayhints.nvim",
      opts = {}
    },
  },
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      inlay_hints = {
        highlight = "NonText",
      },
      -- tools = {
      --   hover_actions = {
      --     auto_focus = true,
      --   },
      -- },
      server = {
        on_attach = function(client, bufnr)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end
      }
    }
  end
}
