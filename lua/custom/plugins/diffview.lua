return {
  'sindrets/diffview.nvim',
  config = function()
    local diffview = require('diffview')
    diffview.setup({})

    vim.keymap.set('n', '<leader>dvt', '<cmd>DiffviewToggleFiles<cr>', { desc = '[D]iff[V]iew [T]oggle Files' })
    vim.keymap.set('n', '<leader>dvc', '<cmd>DiffviewClose<cr>', { desc = '[D]iff[V]iew [C]lose' })

    -- Customize highlight colours for diffview
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Added lines - bold forest green
        vim.api.nvim_set_hl(0, "DiffAdd", {
          bg = "#2d5d4f", -- High saturation green
          nocombine = true,
        })

        -- Deleted lines - rich rose/red
        vim.api.nvim_set_hl(0, "DiffDelete", {
          bg = "#703e5c", -- Deep, saturated purple-red
          nocombine = true,
        })

        -- Changed lines - strong blue
        vim.api.nvim_set_hl(0, "DiffChange", {
          bg = "#3a5e89", -- Rich navy blue
          nocombine = true,
        })

        -- Specific changes within lines
        vim.api.nvim_set_hl(0, "DiffText", {
          bg = "#4b6a96", -- Very distinct highlight
          nocombine = true,
        })
      end
    })
  end
}
