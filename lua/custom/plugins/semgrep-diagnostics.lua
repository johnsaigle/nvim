return {
  'johnsaigle/semgrep-diagnostics.nvim',
  dependencies = { 'nvimtools/none-ls.nvim' },
  config = function()
    -- require('semgrep-diagnostics').setup({
    --   enabled = true,
    --   filetypes = { "sh", "bash", "lua", "rust", "go", "solidity" },
    --   semgrep_config = {
    --     "p/trailofbits",
    --     "p/smart-contracts",
    --     "~/coding/semgrep-rules",
    --     "~/coding/semgrep-scary-strings",
    --   },
   -- })
  end
}
