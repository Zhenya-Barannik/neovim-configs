local function trigger_slime_and_scroll(command)
    local keys = vim.api.nvim_replace_termcodes(command, true, false, true)
    vim.api.nvim_feedkeys(keys, 'm', false)
    vim.schedule(Scroll_terminal_to_bottom)
end

return {
    "jpalardy/vim-slime",
    -- Slime setup
    init = function()
    vim.g.slime_target = "neovim" -- "tmux" can also be used here
    vim.g.slime_bracketed_paste = 1
    vim.g.slime_no_mappings = 1
    vim.g.slime_cell_delimiter = [[^\s*$]] -- Newline(s)

    -- Normal Mode (Send Single Line)
    vim.keymap.set("n", "<M-x>", function()
	trigger_slime_and_scroll("<Plug>SlimeLineSend")
    end, { desc = "Slime Send Line (and Scroll)" })

    -- Normal Mode (Send Cell)
    vim.keymap.set("n", "<M-c>", function()
	trigger_slime_and_scroll("<Plug>SlimeSendCell")
    end, { desc = "Slime Send Cell (and Scroll)" })

    -- Insert Mode (Send Single Line) and restore cursor position
    vim.keymap.set("i", "<M-x>", function()
	local win = vim.api.nvim_get_current_win()
	local original_pos = vim.api.nvim_win_get_cursor(win)
	vim.cmd("stopinsert")
	trigger_slime_and_scroll("<Plug>SlimeLineSend")
	vim.api.nvim_win_set_cursor(win, original_pos)
	vim.api.nvim_feedkeys("a", "n", true)
    end, { desc = "Slime Send Line (and Scroll)" })

    -- Insert Mode (Send Cell) and restore cursor position
    vim.keymap.set("i", "<M-c>", function()
	local win = vim.api.nvim_get_current_win()
	local original_pos = vim.api.nvim_win_get_cursor(win)
	vim.cmd("stopinsert")
	trigger_slime_and_scroll("<Plug>SlimeSendCell")
	vim.api.nvim_win_set_cursor(win, original_pos)
	vim.api.nvim_feedkeys("a", "n", true)
    end, { desc = "Slime Send Cell (and Scroll)" })


    -- Visual Mode (Send Selection/Region)
    vim.keymap.set("v", "<M-c>", function()
	local filetype = vim.bo.filetype

	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)
	if filetype == "julia" then
	    vim.cmd("normal! gv") -- Re-select the visual region
	    trigger_slime_and_scroll("<Plug>SlimeRegionSend")
	elseif filetype == "lua" then
	    local success, err = pcall(function()
		vim.cmd("'<,'>source")
	    end)

	    if not success then
		vim.notify("Error sourcing Lua: " .. err, vim.log.levels.ERROR)
	    end
	else
	    print("Logic is not yet implemented for this filetype.")
	end
    end, { desc = "Slime Send Selection (and Scroll)" })


    -- Use :SlimeConfig
    -- vim.keymap.set("n", "<leader>sk", "<Plug>SlimeConfig", { remap = true, desc = "Slime Config" })
    -- vim.keymap.set("n", "< >", "<Plug>SlimeParagraphSend", { remap = true, desc = "Slime Send Par" })
    -- vim.keymap.set("n", "< >", "<Plug>SlimeLineSend", { remap = true, desc = "Slime Send Line" })

    -- Rebind Ctrl-Q (in normal and visual mode) which does the same as Ctrl-v - enters Visual Block Mode
    -- vim.keymap.set("i", "<C-q>", "<C-o><Plug>SlimeSendCell", { desc = "Slime Send Cell" })
    -- vim.keymap.set("n", "<C-q>", "<Plug>SlimeSendCell", { remap = true, desc = "Slime Send Cell" })
    -- vim.keymap.set("v", "<C-q>", "<Plug>SlimeRegionSend", { remap = true, desc = "Slime Send Selection" })
end
}
