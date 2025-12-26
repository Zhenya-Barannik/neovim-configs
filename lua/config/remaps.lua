-- "Yank", "Paste", "Cut in visual mode" always use system clipboard
vim.keymap.set({'n', 'x'}, 'y', '"+y')
vim.keymap.set({'n', 'x'}, 'Y', '"+Y')
vim.keymap.set({'n', 'x'}, 'p', '"+p')
vim.keymap.set({'n', 'x'}, 'P', '"+P')

-- Cutting one char from normal mode will not send char to the system clipboard
vim.keymap.set({'x'}, 'x', '"+x')

-- Emacs-style <C-a>, <C-e> keybindings already do work in insert mode inside terminal, but not in other modes.
-- n <C-a> is mapped to increment number default
-- v <C-a> exits from visual mode by default
-- i <C-a> is mapped to insert previously inserted by default
vim.keymap.set({'n', 'v', 'i', 'c'}, '<C-a>', '<Home>', { noremap = true, silent = true})

-- n <C-e> is mapped to scroll down by one line by default
-- v <C-e> is mapped to scroll down by one line by default
-- i <C-e> is mapped to insert the text from the line below by default
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
vim.keymap.set({'n', 'v', 'i'}, '<C-e>', '<End>', { noremap = true, silent = true }) -- Like in NvChad, but also for 'n' and 'v'

-- n <C-s> is mapped to signature help in insert mode (we use C-k instead)
-- Save file (from LazyVim, NvChad)
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })

-- n <C-k> is not mapped by default
-- v <C-k> is not mapped by default
-- i <C-k> is mapped to enter digraph by default
-- https://www.lazyvim.org/keymaps
vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end) -- from lazyvim

-- n <C-c> does nothing by default 
-- v <C-c> exists visual selection by default
-- i <C-c> exist insert mode by default
-- Smart Ctrl-C: Terminal interrupt if terminal exists, otherwise normal Ctrl-C
vim.keymap.set({"n", "v", "i"}, "<C-c>", Interrupt_terminal_and_stop_insert, { desc = 'Smart Ctrl-C' })

 -- Modified gx that will reveal file in finder instead of opening it 
vim.keymap.set('n', 'gx', Reveal_file_or_open_URL, { desc = "Reveal file or open URL", noremap = true })

-- Modified gd that will save current position.
-- (it can be restored after the quickfix window is closed)
vim.keymap.set("n", "gd", function()
    save_current_context()
    vim.lsp.buf.definition()
end, { desc = "Go to definition (saving position)" })

