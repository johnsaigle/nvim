-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Set relative numbers
vim.o.relativenumber = true

-- Highlight the selected line
vim.o.cursorline = true

-- Make line numbers default
vim.wo.number = true

-- Change colors for current line
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = "pink" })
vim.api.nvim_set_hl(0, 'LineNr', { fg = "gray" })

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Draw column at this offset
vim.wo.colorcolumn = '120'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- TODO: should make sureyour terminal supports this
vim.o.termguicolors = true

-- Enable spelling
vim.o.spell = true

-- Autoindent
-- vim.o.autoindent = true
vim.o.smartindent = true

-- Tabs and spaces
-- https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces#1878983
vim.tabstop = 8
vim.softtabstop = 0
vim.expandtab = true
vim.shiftwidth = 4
vim.smarttab = true

-- Whitespace representations
vim.opt.listchars = {
    space = '·',
    tab = '>-',
    eol = '$'
}

-- Change cursor style
vim.opt.guicursor = table.concat({
    "n-v-c:underline-Cursor",  -- normal, visual, command modes: underline
    "i-ci:ver100-iCursor",     -- insert mode: vertical bar
    "r:hor100-rCursor",        -- replace mode: horizontal bar
}, ",")
