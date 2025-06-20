return {
  "supermaven-inc/supermaven-nvim",

  config = function()
    -- Hide setup behind a function in order to have the plugin disabled by default.
    local function setup()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        -- ignore_filetypes = { cpp = true }, -- or { "cpp", }
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        log_level = "info",                -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false,           -- disables built in keymaps for more manual control
        condition = function()
          return false
        end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
      })

      -- Use free tier for now
      vim.cmd('SupermavenUseFree')
      vim.notify("Supermaven is now enabled")

    end

    -- Enable the plugin
    vim.keymap.set("n", "<leader>sm", setup, { desc = "[S]uper[M]aven" })
  end
}
