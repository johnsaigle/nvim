return {
  'johnsaigle/github-permalink.nvim',
  config = function()
    require('github-permalink').setup({})
    -- Using <C-u> clears the highlight after generating the link.
    vim.keymap.set("x", "<leader>gl", ":<C-u>GitHubPermalink<CR>", { desc = "[G]itHub Perma[L]ink" })
  end
}
