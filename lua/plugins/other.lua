return {
    {
	-- https://github.com/nvim-telescope/telescope.nvim
	'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
	dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    {
	-- https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	branch = 'main',
	build = ':TSUpdate',
	-- opts = {
	    --     -- A list of parser names, or "all" (the listed parsers MUST always be installed)
	--     ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust", "python", "js", "html", "julia"},
	--
	--     -- Install parsers synchronously (only applied to `ensure_installed`)
	--     sync_install = false,
	--
	--     -- Automatically install missing parsers when entering buffer
	--     auto_install = true,
	--     highlight = {
	-- 	enable = true,
	-- 	additional_vim_regex_highlighting = false,
	--     },
	-- },
	init = function()
	    require('nvim-treesitter').install({ 'rust', 'c', 'python', 'julia', 'lua' }):wait(300000) -- wait max. 5 minutes
	end,
    },
    {
	"neovim/nvim-lspconfig"
    },
    {
	"rrethy/vim-illuminate"
    },
    {
	--Setup for mini.icons to overwrite nvim-web-devicons
	"echasnovski/mini.icons",
	opts = {},
	lazy = true,
	specs = {
	    { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
	},
	init = function()
	    package.preload["nvim-web-devicons"] = function()
		require("mini.icons").mock_nvim_web_devicons()
		return package.loaded["nvim-web-devicons"]
	    end
	end,
    },
    {
	"zenbones-theme/zenbones.nvim",
	-- Optionally install Lush. Allows for more configuration or extending the colorscheme
	-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
	-- In Vim, compat mode is turned on as Lush only works in Neovim.
	dependencies = "rktjmp/lush.nvim",
	lazy = false,
	priority = 1000,
	-- you can set set configuration options here
	config = function()
	    vim.g.zenbones = { darkness = 'stark' };
	    vim.cmd('colorscheme zenbones');
	end;
    },
    {
	-- https://github.com/rmagatti/auto-session
	"rmagatti/auto-session",
	lazy = false,
	keys = {
	    -- Will use Telescope if installed or a vim.ui.select picker otherwise
	    -- { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
	    { "<leader>fs", "<cmd>AutoSession search<CR>", desc = "Session" },
	    { "<leader>p", "<cmd>AutoSession save<CR>", desc = "Session save" },
	},

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
	    suppressed_dirs = { "~/", "/"},
	    auto_save = false, -- Enables/disables auto saving session on exit
	},
    }
}
