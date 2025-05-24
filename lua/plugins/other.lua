return {
    {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    {
	'nvim-treesitter/nvim-treesitter',
	opts = {
	    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
	    ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust", "python", "js", "html"},

	    -- Install parsers synchronously (only applied to `ensure_installed`)
	    sync_install = false,

	    -- Automatically install missing parsers when entering buffer
	    auto_install = true,
	    highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	    },
	}
    },
    {
	"neovim/nvim-lspconfig"
    },
    {
      "ariel-frischer/bmessages.nvim",
      event = "CmdlineEnter",
      opts = {}
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
	--    {
	-- "gbprod/nord.nvim",
	-- lazy = false,
	-- priority = 1000,
	-- config = function()
	--     require("nord").setup({})
	--     vim.cmd.colorscheme("nord")
	-- end,
	--    },
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
       }
}
