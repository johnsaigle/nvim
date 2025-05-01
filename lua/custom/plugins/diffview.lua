return {
  'sindrets/diffview.nvim',
  config = function()
    local diffview = require('diffview')
    diffview.setup({
      enhanced_diff_hl = true,
      view = {
        default = {
          winbar_info = true,
        },
      },
    })

    -- Keymaps
    vim.keymap.set('n', '<leader>dvt', '<cmd>DiffviewToggleFiles<cr>', { desc = '[D]iff[V]iew [T]oggle Files' })
    vim.keymap.set('n', '<leader>dvc', '<cmd>DiffviewClose<cr>', { desc = '[D]iff[V]iew [C]lose' })

    -- Set up an autocmd to ensure highlights are reapplied after colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Regular diff highlights
        vim.api.nvim_set_hl(0, "DiffAdd", {
          bg = "#2d524a", -- saturated green
        })
        vim.api.nvim_set_hl(0, "DiffDelete", {
          -- bg = "#703e5c", -- Deep, saturated purple-red
          bg = "#db4b4b",
        })
        vim.api.nvim_set_hl(0, "DiffChange", {
          bg = "#3a5e89", -- Rich navy blue
        })
        -- vim.api.nvim_set_hl(0, "DiffText", {
        --   bg = "#58b5e3", -- Bright blue for changed text
        -- })
        vim.api.nvim_set_hl(0, "DiffText", {
          bg = "#00354a", -- Rose Pine Moon overlay blue
        })
      end,
    })
  end
}

