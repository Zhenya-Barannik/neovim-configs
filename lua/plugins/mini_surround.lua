return {
    'echasnovski/mini.surround',
    config = function()
	vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
	require('mini.surround').setup()
    end,
    version = false
}
