return {
  'johnsaigle/cargo-expand.nvim',
  dependencies = { 'nvimtools/none-ls.nvim' },

  config = function()
    require('cargo-expand').setup({})
    local cargo_expand = require('cargo-expand.expand')

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        vim.keymap.set("n", "<leader>ce", cargo_expand.expand, { desc = "[C]argo [E]xpand" })
      end
    })
  end
}
