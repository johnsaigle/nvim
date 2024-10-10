return {
  -- Harpoon
  {
    "ThePrimeagen/rfceez",
    config = function ()
      local rfc = require('rfceez')
        rfc.setup()
        vim.keymap.set("n", "<leader>ra", function() rfc.add() end, {desc = "Add note"})
        vim.keymap.set("n", "<leader>rd", function() rfc.rm() end, {desc = "Remove note"} )
        vim.keymap.set("n", "<leader>rs", function() rfc.show_notes() end, {desc = "Show notes"} )
        vim.keymap.set("n", "[r", function() rfc.show_next() end , {desc = "Show next note"})
        vim.keymap.set("n", "[[r", function() rfc.nav_next() end , {desc = "Nav next note"})
    end
  },

}
