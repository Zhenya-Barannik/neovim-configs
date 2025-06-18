-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
	vim.api.nvim_echo({
	    { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
	    { out, "WarningMsg" },
	    { "\nPress any key to exit..." },
	}, true, {})
	vim.fn.getchar()
	os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
require("config.autocmd")
require('config.settings')

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
	-- import your plugins
	{ import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = {  },
    -- automatically check for plugin updates
    checker = { enabled = false, notify = false},
    change_detection = { notify = false },
})

require("config.maps")
require("config.remaps")

require('vim._extui').enable({
 enable = true, -- Whether to enable or disable the UI.
 msg = { -- Options related to the message module.
   ---@type 'cmd'|'msg' Where to place regular messages, either in the
   ---cmdline or in a separate ephemeral message window.
   target = 'cmd',
   timeout = 4000, -- Time a message is visible in the message window.
 },
})
