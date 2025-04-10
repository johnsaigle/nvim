return {
  'johnsaigle/semgrep-diagnostics.nvim',
  dependencies = { 'nvimtools/none-ls.nvim' },
  config = function()
    require('semgrep-diagnostics').setup({
      enabled = false,
      filetypes = { "sh", "bash", "lua", "rust", "go", "solidity" },
      semgrep_config = {
        "p/trailofbits",
        "~/coding/semgrep-rules",
        "~/coding/semgrep-scary-strings",
      },
      default_severity = vim.diagnostic.severity.INFO,
    })

    -- TODO: add keymaps
  end
}
