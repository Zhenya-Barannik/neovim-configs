local map = vim.keymap.set

-- From LazyVim and LspZero defaults
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" })

-- From LazyVim
map("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Go to Type Definition" })

-- Move Lines (from LazyVim)
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selected lines Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move selected lines Up" })

-- Close floating windows, or send q in normal if none
-- Can be useful to close documentation (K in normal mode), diagnostic (Ctrl-W d in normal mode)
map("n", "q", function()
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    -- If no floating window found, send q 
    vim.api.nvim_feedkeys("q", "n", true)
end, { desc = "Close floating window or send q" })

map("n", "\\", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- https://github.com/nvim-telescope/telescope.nvim but for all modes
map({"n", "v", "i", "t"}, "<C-/>", Show_keymaps_for_current_mode, { desc = "Show keymaps for current mode" })

-- Maps to Cmd+Space
map({ "i", "x", "n", "s" }, "<C-Space>", Save_and_build, { desc = "Save and Build" })

-- n_<Alt+h> seems to be not mapped by default
-- Maps it to toggle terminal (from NvChad)
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
map({ "n", "t" }, "<M-h>", Toggle_terminal, { desc = "Toggle Terminal" })

-- Esc will exit insert mode in terminal
map('t', '<Esc>', [[<C-\><C-n>]], { desc = "Terminal to Normal Mode" })

-- Leader keybinds

-- <leader>fc (from LazyVim)
map("n", "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", { desc = "Find Config File" })

-- <leader>fg (from Telescope)
-- https://github.com/nvim-telescope/telescope.nvim
-- Improved version of map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fg", function()
    local cwd = vim.fn.getcwd()
    vim.cmd("Telescope live_grep cwd=" .. cwd)
    vim.notify(string.format("SEARCHING IN: %s", cwd), vim.log.levels.INFO)
end, { desc = "Grep in cwd" })

map("n", "<leader>gg", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    vim.cmd("Telescope live_grep cwd=" .. git_root)
    vim.notify(string.format("SEARCHING IN: %s", git_root), vim.log.levels.INFO)
end, { desc = "Grep in git repo" })

-- <leader>fb is from LazyVim
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })

-- <leader>fr is from LazyVim
map("n", "<leader>fr", function()
    require('telescope.builtin').oldfiles({ only_cwd = false })
end, { desc = "Recent Files" })

-- Improved version of map("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Git Files" }) or
-- (Changed from LazyVim)
map("n", "<leader>ff", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_files({ cwd = git_root })
end, { desc = "Git Files" })

-- -- Improved version of map("n", "<leader>gf", "<cmd>Telescope git_bcommits<cr>", { desc = "File History" })
-- (Keybind as in LazyVim)
map("n", "<leader>gf", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_bcommits({ cwd = git_root })
end, { desc = "Git File History" })
--
-- -- Improved version of map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
-- -- (Keybind as in LazyVim)
map("n", "<leader>gc", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_commits({ cwd = git_root })
end, { desc = "Git Commits" })

vim.keymap.set("n", '<leader>h', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0})
end,
{ desc = "Toggle inlay hints" })

