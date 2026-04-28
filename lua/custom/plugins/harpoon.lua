return {
  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        '<leader>f',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Harpoon file',
      },
      {
        '<C-f>',
        function()
          local harpoon = require('harpoon')
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon menu',
      },
      {
        '<C-j>',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Harpoon file 1',
      },
      {
        '<C-k>',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Harpoon file 2',
      },
      {
        '<C-l>',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Harpoon file 3',
      },
      {
        '<C-S-P>',
        function()
          require('harpoon'):list():prev()
        end,
        desc = 'Harpoon previous',
      },
      {
        '<C-S-N>',
        function()
          require('harpoon'):list():next()
        end,
        desc = 'Harpoon next',
      },
    },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({})

      if package.loaded['telescope'] then
        pcall(require('telescope').load_extension, 'harpoon')
      end
    end,
  },
}
