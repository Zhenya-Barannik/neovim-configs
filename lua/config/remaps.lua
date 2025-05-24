local map = vim.keymap.set

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

-- Rebinds "Ctrl-S - Signature help in insert mode"
-- Save file (from LazyVim, NvChad)
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua#L45
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })

-- n <C-K> is not mapped 
-- v <C-K> is not mapped
-- i <C-K> is mapped to enter digraph
-- https://www.lazyvim.org/keymaps
map("i", "<C-k>", function() vim.lsp.buf.signature_help() end) -- from LazyVim

-- Show keymaps for all modes
map({"n", "v", "i", "t"}, "<C-h>", function()
    local mode = vim.api.nvim_get_mode().mode
    require("which-key").show("", { mode = mode })
end, { desc = "Show Keymaps for Current Mode" })

-- n <C-b> is mapped to scroll screen by default
-- v <C-b> is mapped to scroll screen by default
-- i <C-b> attemts to insert character by default
map({ "i", "x", "n", "s" }, "<C-b>", Save_and_build, { desc = "Save and Build" })

-- n <C-c> does nothing by default 
-- v <C-c> exists visual selection by default
-- i <C-c> exist insert mode by default
-- Smart Ctrl-C: Terminal interrupt if terminal exists, otherwise normal Ctrl-C
map({"n", "v", "i"}, "<C-c>", Interrupt_Terminal, { desc = 'Smart Ctrl-C' })

-- n <C-H> is mapped to move cursor left by default
-- v <C-H> is mapped to move cursor left by default
-- i <C-H> is mapped to backspace by default
-- Map Alt+h to toggle terminal (from NvChad)
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
map({ "n", "t" }, "<M-h>", Toggle_terminal, { desc = "Toggle Terminal" })
map('t', '<Esc>', [[<C-\><C-n>]], { desc = "Terminal to Normal Mode" })
