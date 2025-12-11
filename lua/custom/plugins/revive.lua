return {
  "johnsaigle/revive.nvim",
  dependencies = {
    "johnsaigle/sast-nvim",
    "nvimtools/none-ls.nvim",
  },
  -- Use local fork
  dir = "~/coding/revive.nvim",
  config = function()
    -- TODO: Rename module
    require("revive-diagnostics").setup({
      -- Optional: customize configuration
      enabled = true,
      filetypes = { "go" },
      run_mode = "save", -- "save" or "change"
    })
  end,
}
