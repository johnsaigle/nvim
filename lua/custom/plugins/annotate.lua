return {
  -- Annotate.nvim - Security audit notes
  {
    "johnsaigle/annotate.nvim",          -- Update to your actual repo path
    -- dir = "~/coding/annotate.nvim", -- Point to local directory
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local annotate = require('annotate')
      annotate.setup()

      -- Add note
      vim.keymap.set("n", "<leader>ra", function() annotate.add() end, { desc = "Add annotation" })

      -- Remove notes
      vim.keymap.set("n", "<leader>rd", function() annotate.rm() end, { desc = "Remove annotation" })
      vim.keymap.set("n", "<leader>rD", function() annotate.rm_all() end, { desc = "Remove all annotations in file" })

      -- Show notes
      vim.keymap.set("n", "<leader>rs", function() annotate.show_notes() end, { desc = "Show annotation" })

      -- Navigate
      vim.keymap.set("n", "[r", function() annotate.show_next() end, { desc = "Show next annotation" })
      vim.keymap.set("n", "[[r", function() annotate.nav_next() end, { desc = "Nav next annotation" })

      -- New commands
      vim.keymap.set("n", "<leader>re", function() annotate.export() end, { desc = "Export audit report" })
      vim.keymap.set("n", "<leader>rS", function() annotate.stats() end, { desc = "Show audit statistics" })
    end
  },
}
