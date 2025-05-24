-- Leader setup
vim.g.mapleader = " "

-- "i" <C-w> will not stop at insert point
vim.cmd[[set backspace+=nostop]]

-- Use 4 spaces to indent
vim.cmd[[set shiftwidth=4]]

-- Set russian language mapping
vim.api.nvim_command('set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz')

-- Show linenumbers
vim.api.nvim_command('set number')

-- Disable linewrap
vim.api.nvim_command('set wrap!')

-- Set fixed width for signcolumn to prevent text jumping on LSP error/warning detection
vim.wo.signcolumn = "yes:1"

-- Disable auto-selection in omni-completion
vim.opt.completeopt:append('noselect')
