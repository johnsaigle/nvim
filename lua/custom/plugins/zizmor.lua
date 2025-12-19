return {
  'johnsaigle/zizmor.nvim',
  dependencies = { 'nvimtools/none-ls.nvim' },
  ft = { 'yaml' },
  config = function()
    local zizmor = require('zizmor')
    zizmor.setup({
      enabled = true,
      severity_map = {
        High = vim.diagnostic.severity.ERROR,
        Medium = vim.diagnostic.severity.WARN,
        Low = vim.diagnostic.severity.INFO,
        Informational = vim.diagnostic.severity.HINT,
      },
      default_severity = vim.diagnostic.severity.WARN,
      extra_args = {},
      filetypes = { "yaml", "yml" },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "yaml", "yml" },
      callback = function()
        vim.keymap.set("n", "<leader>zt", zizmor.toggle, { desc = "[Z]izmor: [T]oggle diagnostics" })
        vim.keymap.set("n", "<leader>zc", zizmor.clear_diagnostics, { desc = "[Z]izmor: [C]lear diagnostics" })
      end
    })
  end
}
