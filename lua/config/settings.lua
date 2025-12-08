-- Leader setup
vim.g.mapleader = " "

-- "i" <C-w> will not stop at insert point
vim.cmd[[set backspace+=nostop]]

-- Use 4 spaces to indent
vim.cmd[[set shiftwidth=4]]

-- Show linenumbers
vim.api.nvim_command('set number')

-- Disable linewrap
vim.api.nvim_command('set wrap!')

-- Set fixed width for signcolumn to prevent text jumping on LSP error/warning detection
vim.wo.signcolumn = "yes:1"

-- Disable auto-selection in omni-completion
vim.opt.completeopt:append('noselect')

-- Disable auto comment on the next line for all files
vim.cmd([[autocmd filetype * set formatoptions-=ro]])

require('vim._extui').enable({
 enable = true, -- Whether to enable or disable the UI.
 msg = { -- Options related to the message module.
   ---@type 'cmd'|'msg' Where to place regular messages, either in the
   ---cmdline or in a separate ephemeral message window.
   target = 'cmd',
   timeout = 4000, -- Time a message is visible in the message window.
 },
})

-- vim.api.nvim_command('set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz')
-- This russian language mapping is not used now, since we can use Toggle_keyboard_layout function
