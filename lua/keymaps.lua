-- [ Generic keymaps ]

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
  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':p')
  vim.fn.setreg('+', '')       -- clear existing contents so that it doesn't get written twice
  vim.fn.setreg('+', filepath) -- write to clipboard
  vim.notify("Copied: " .. filepath, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>pc', insertFullPath,
  { desc = '[pc] Yank filename to system [C]lipboard ', noremap = true, silent = true })
-- Go to the nvim file explorer with a new key command
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "open nvim file explorer" })

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

-- Insert bullet point
vim.keymap.set("n", "<leader>bb", function()
  -- Save current cursor position
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)

  -- Insert bullet at start of line
  vim.cmd("normal! I- ")

  -- Restore cursor position (adjusting for the added characters)
  cursor[2] = cursor[2] + 2 -- adjust for "- " (2 characters)
  vim.api.nvim_win_set_cursor(win, cursor)
end)

-- Toggles most recent buffers
vim.keymap.set('n', '<leader>;', '<C-^>', { desc = "Toggle most recent buffers" })

-- Toggle invlist
vim.keymap.set('n', '<leader>,', ':set invlist<CR>')

-- Sort highlighted lines
vim.keymap.set('v', '<leader>ss', ':%!sort<CR>', { desc = "[S]ort highlighted lines" })
vim.keymap.set('v', '<leader>sn', ':%!sort -n<CR>', { desc = "[S]ort highlighted lines ([N]umeric)" })

-- Toggle list (whitespace visibility)
vim.keymap.set('n', '<leader>ll', ':set list!<CR>', { desc = "Toggle [L]ist (visible whitespace)" })

-- Shortcut to `:Format` (LSP)
vim.keymap.set('n', '<leader>fm', ':Format<CR>', { desc = "[F]or[M]at" })


-- Normal-mode keymap. Uses current buffer to configure keymaps only for certain filetypes.
local nmap = function(bufnr, keys, func, desc)
  vim.notify(string.format("Setting keymap for buffer %d", bufnr))
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

-- [ Lua keymaps ]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(args)
    -- Insert `vim.notify(...)` and move cursor to the first argument.
    nmap(args.buf, '<leader>vn', 'ovim.notify("", vim.log.levels.WARN)<Esc>2F"ci"', 'Insert vim.notify')
  end,
})

-- [ Go keymaps ]
-- [ Go keymaps ]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(args)
    -- do err == nil check and change contents within braces
    nmap(args.buf, '<leader>ee', 'oif err != nil {<CR>}<Esc>Oreturn err<Esc>', "Insert err != nil check")
    -- Format a byte string
    nmap(args.buf, '<leader>fb', 'ifmt.Sprintf("%x", byteStr)<Esc>Fb', "Format byte string")
    -- comma ok pattern
    nmap(args.buf, '<leader>eo', 'oif item, ok := collection[key]; !ok {<CR>}<Esc>O<Esc>', "Insert comma ok pattern")
    -- create new error and change contents in quotes
    nmap(args.buf, '<leader>en', 'ierrors.New("")<Esc>2F"ci"', "Insert errors.New")
  end,
})


-- vim: ts=2 sts=2 sw=2 et
