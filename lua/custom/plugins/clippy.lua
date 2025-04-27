return {
  'johnsaigle/clippy.nvim',
  dependencies = { 'nvimtools/none-ls.nvim' },
  config = function()
    local clippy = require('clippy')
    clippy.setup({})

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        vim.keymap.set("n", "<leader>ll", clippy.clippy, { desc = "c[L]ippy: Run [L]ints" })
        vim.keymap.set("n", "<leader>lc", clippy.clear_diagnostics, { desc = "c[L]ippy: [C]lear diagnostics"})
      end
    })
  end
}
