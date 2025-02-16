return {
  'johnsaigle/clippy.nvim',
  dependencies = { 'jose-elias-alvarez/null-ls.nvim' },

  config = function()
    local clippy = require('clippy')
    clippy.setup({})

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        vim.keymap.set("n", "<leader>ll", clippy.clippy, { desc = "Run C[L]ippy [L]ints" })
      end
    })
  end
}
