return {
  "johnsaigle/scary.nvim",
  dependencies = {
    "johnsaigle/sast-nvim",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    require("scary-diagnostics").setup({
      comments_only = true,
      show_reason = true,
      minimum_severity = vim.diagnostic.severity.INFO,
    })
  end,
}
