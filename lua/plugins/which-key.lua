-- Whichkey is used for showing all available keybinds starting in n, x, i modes
-- Mini.clue is used for the rest
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
	preset = "modern",
	win = {
	    no_overlap = false,
	},
    },
    keys = {},
}

