return {
  'johnsaigle/solana-radar.nvim',
  dependencies = { 'nvimtools/none-ls.nvim' },

  config = function()
    local radar = require('solana-radar')
    radar.setup({ enabled = false })

    -- TODO: properly expose radar.scan
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        vim.keymap.set("n", "<leader>rr", radar.scan, { desc = "[R]un [R]adar" })
      end
    })
  end

}
