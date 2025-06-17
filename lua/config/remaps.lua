local map = vim.keymap.set

function Interrupt_Terminal_or_Default()
    local t_buffer = find_terminal_buffer()
    if t_buffer ~= nil then
	vim.api.nvim_chan_send(vim.b[t_buffer].terminal_job_id, '\x03')
    else
    print("No open terminal Buffer, so nothing to interrupt.")
	vim.api.nvim_input('<C-c>')
    end
    return nil
end

-- "Yank", "Paste", "Cut in visual mode" always use system clipboard
map({'n', 'x'}, 'y', '"+y')
map({'n', 'x'}, 'Y', '"+Y')
map({'n', 'x'}, 'p', '"+p')
map({'n', 'x'}, 'P', '"+P')
map({'x'}, 'x', '"+x') -- Cutting one char from normal mode will not send char to the system clipboard

-- Emacs-style <C-a>, <C-e> keybindings already work in insert mode inside terminal, but not in other modes.
-- n <C-a> is not mapped by default
-- v <C-a> exits from visual mode by default
-- i <C-a> is mapped to insert previously inserted 
-- n <C-e> is mapped to scroll down by one line by default
-- v <C-e> is mapped to scroll down by one line by default
-- i <C-e> is mapped to insert the text from the line below by default
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
map({'n', 'v', 'i'}, '<C-e>', '<End>', { noremap = true, silent = true }) -- Like in NvChad, but also for 'n' and 'v'
map({'n', 'v', 'i'}, '<C-a>', '<Home>', { noremap = true, silent = true})
vim.cmd('cnoremap <C-a> <Home>')

-- n <C-K> is not mapped 
-- v <C-K> is not mapped
-- i <C-K> is mapped to enter digraph
-- https://www.lazyvim.org/keymaps
map("i", "<C-k>", function() vim.lsp.buf.signature_help() end) -- from LazyVim

-- Remaps "Ctrl-S - Signature help in insert mode"
-- Save file (from LazyVim, NvChad)
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua#L45
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })

-- n <C-b> is mapped to scroll screen by default
-- v <C-b> is mapped to scroll screen by default
-- i <C-b> attemts to insert character by default
map({ "i", "x", "n", "s" }, "<C-b>", Save_and_build, { desc = "Save and Build" })

-- n <C-c> does nothing by default 
-- v <C-c> exists visual selection by default
-- i <C-c> exist insert mode by default
-- Smart Ctrl-C: Terminal interrupt if terminal exists, otherwise normal Ctrl-C
map({"n", "v", "i"}, "<C-c>", Interrupt_Terminal_or_Default, { desc = 'Smart Ctrl-C' })

-- n_<Alt+h> seems to be not mapped by default
-- Maps it to toggle terminal (from NvChad)
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
map({ "n", "t" }, "<M-h>", Toggle_terminal, { desc = "Toggle Terminal" })
map('t', '<Esc>', [[<C-\><C-n>]], { desc = "Terminal to Normal Mode" })

-- Telescope suggests use of <C-h> to show mappings
-- https://github.com/nvim-telescope/telescope.nvim
-- n_<C-h> seems to be not mapped (h moves cursor left) by default
-- v_<C-h> seems to be not mapped (h moves cursor left) by default
-- i_<C-h> seems to be mapped to backspace by default
-- Show keymaps for all modes
map({"n", "v", "i", "t"}, "<C-h>", function()
    local mode = vim.api.nvim_get_mode().mode
    require("which-key").show("", { mode = mode })
end, { desc = "Show Keymaps for Current Mode" })
