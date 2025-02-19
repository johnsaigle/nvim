return {
  "folke/trouble.nvim",
  opts = {
    win = {
      wo = {
        wrap = true,
      },
    },
  },
  config = function()
    require('trouble').setup({})

    local trouble = require('trouble')

    vim.keymap.set('n', '<leader>xt', "<cmd>Trouble diagnostics toggle<cr>")

    vim.keymap.set('n', '<leader>xn', function()
      trouble.next({ skip_groups = false, jump = true })
    end)

    vim.keymap.set('n', '<leader>xN', function()
      trouble.next({ skip_groups = true, jump = true })
    end)

    vim.keymap.set('n', '<leader>xp', function()
      trouble.prev({ skip_groups = false, jump = true })
    end)

    vim.keymap.set('n', '<leader>xP', function()
      trouble.prev({ skip_groups = true, jump = true })
    end)


  end
}
