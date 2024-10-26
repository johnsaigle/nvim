return {
	-- [[Go macros]]
	-- do err == nil check and change contents within braces
	vim.keymap.set('n', '<leader>ee', 'oif err != nil {<CR>}<Esc>Oreturn err<Esc>'),
	-- Format a byte string
	vim.keymap.set('n', '<leader>fb', 'ifmt.Sprintf("%x", byteStr)<Esc>Fb'),
	-- comma ok pattern
	vim.keymap.set('n', '<leader>eo', 'oif item, ok := collection[key]; !ok {<CR>}<Esc>O<Esc>'),
	-- create new error and change contents in quotes
	vim.keymap.set('n', '<leader>en', 'ierrors.New("")<Esc>2F"ci"'),
}
