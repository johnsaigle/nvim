-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
--  NOTE: The keymap is added in order to allow <space> to be <leader> while in Visual mode
-- https://neovim.discourse.group/t/how-do-i-use-space-as-the-leader-in-visual-mode/916-- Set <space> as the leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Paste filepath to clipboard
local function insertFullPath()
  local filepath = vim.fn.getcwd() .. '/' .. vim.fn.expand('%')
  vim.fn.setreg('+', '') -- clear existing contents so that it doesn't get written twice
  vim.fn.setreg('+', filepath) -- write to clipboard
end

vim.keymap.set('n', '<leader>pc', insertFullPath, { desc = '[pc] Yank filename to system clipboard ', noremap = true, silent = true })
-- Go to the nvim file explorer with a new key command
vim.keymap.set('n', '<leader>pv',vim.cmd.Ex, { desc = "open nvim file explorer" })

-- Swap lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- J but without moving the cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Ctrl d and Ctrl u but center the cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search but center the cursor
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim: ts=2 sts=2 sw=2 et
