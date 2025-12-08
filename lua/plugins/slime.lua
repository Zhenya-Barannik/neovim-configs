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
    vim.g.slime_bracketed_paste = 1 -- indentation handling for Julia code
    vim.g.slime_no_mappings = 1
    vim.g.slime_cell_delimiter = "##"

    -- Normal Mode (Send Cell)
    vim.keymap.set("n", "<C-q>", function()
	trigger_slime_and_scroll("<Plug>SlimeSendCell")
    end, { desc = "Slime Send Cell (Scroll)" })

    -- Insert Mode (Send Cell) - Restores Cursor Position
    vim.keymap.set("i", "<C-q>", function()
	local win = vim.api.nvim_get_current_win()
	local original_pos = vim.api.nvim_win_get_cursor(win)
	vim.cmd("stopinsert")
	trigger_slime_and_scroll("<Plug>SlimeSendCell")
	vim.api.nvim_win_set_cursor(win, original_pos)
	vim.api.nvim_feedkeys("a", "n", true)
    end, { desc = "Slime Send Cell (Scroll)" })

    -- Visual Mode (Send Selection/Region)
    vim.keymap.set("v", "<C-q>", function()
	vim.cmd("normal! gv") -- Re-select the visual region
	trigger_slime_and_scroll("<Plug>SlimeRegionSend")
    end, { desc = "Slime Send Selection (Scroll)" })

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
