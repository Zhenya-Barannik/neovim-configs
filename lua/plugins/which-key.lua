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
    init = function()
	-- Setup groups
	local wk = require("which-key")
	wk.add({
	    { "<leader>g", group = "Git" },
	    { "<leader>f", group = "Find" },
	    { "g", desc = "goto" },
	})
    end
}

