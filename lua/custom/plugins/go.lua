return {
	-- [[Go macros]]
	-- do err == nil check and change contents within braces
	vim.keymap.set('n', '<leader>ee', 'oif err != nil {<CR>}<Esc>Oreturn err<Esc>'),
	-- Format a byte string
	vim.keymap.set('n', '<leader>fb', 'ifmt.Sprintf("%x", byteStr)<Esc>Fb'),
}
