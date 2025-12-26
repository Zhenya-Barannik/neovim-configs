local map = vim.keymap.set

-- From LazyVim and LspZero defaults
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" })

-- From LazyVim
map("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Go to Type Definition" })

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

-- Leader keybindings
-- <leader>fc from LazyVim https://www.lazyvim.org/keymaps
map("n", "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", { desc = "Config Files" })

-- <leader>fb from LazyVim https://www.lazyvim.org/keymaps
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

-- <leader>fr from LazyVim https://www.lazyvim.org/keymaps
map("n", "<leader>fr", function()
    require('telescope.builtin').oldfiles({ only_cwd = false })
end, { desc = "Recent Files"})

-- <leader>fg from LazyVim https://www.lazyvim.org/keymaps
-- but changed to <leader>ff
map("n", "<leader>ff", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_files({ cwd = git_root })
end, { desc = "Git Files" })

-- Telescope default suggestion
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- https://github.com/nvim-telescope/telescope.nvim
vim.keymap.set('n', '<leader>fg', function()
    require('telescope.builtin').live_grep({
	-- fnamemodify(..., ":~") shortens /Users/name to ~
	prompt_title = 'Live Grep in ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~"),
    })
end, { desc = 'Grep in CWD' })

-- Improved version of map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
-- (Keybind as in LazyVim)
map("n", "<leader>gc", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_commits({
	-- fnamemodify(..., ":~") shortens /Users/name to ~
	prompt_title = 'Commits in ' .. vim.fn.fnamemodify(git_root, ":~"),
	cwd = git_root,
    })
end, { desc = "Git Commits" })

-- Improved version of map("n", "<leader>gf", "<cmd>Telescope git_bcommits<cr>", { desc = "File History" })
-- (Keybind as in LazyVim)
map("n", "<leader>gf", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_bcommits({
	-- fnamemodify(..., ":~") shortens /Users/name to ~
	prompt_title = 'History for ' .. vim.fn.expand("%:t"),
	cwd = git_root,
    })
end, { desc = "Git File History" })


map("n", "<leader>gg", function()
    local git_root = Get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').live_grep({
	-- fnamemodify(..., ":~") shortens /Users/name to ~
	prompt_title = 'Live Grep in ' .. vim.fn.fnamemodify(git_root, ":~"),
	cwd = git_root,
    })
end, { desc = "Grep in Git Repo" })

vim.keymap.set("n", '<leader>h', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0})
end,
{ desc = "Toggle inlay hints" })

vim.keymap.set("n", '<leader>l', function()
    Toggle_keyboard_layout()
end,
{ desc = "Toggle keyboard layout" })

-- Move Lines (from LazyVim)
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
map("n", "<M-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line Down" })
map("n", "<M-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line Up" })
map("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line Down" })
map("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line Up" })
map("v", "<M-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selected lines Down" })
map("v", "<M-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move selected lines Up" })

-- Scroll the next window (down)
vim.keymap.set({'n', 'i', 't'}, '<M-d>', function()
  Send_key_to_other_window("<C-d>")
end, { desc = "Scroll other window down" })

-- Scroll the next window (up)
vim.keymap.set({'n', 'i', 't'}, '<M-u>', function()
  Send_key_to_other_window("<C-u>")
end, { desc = "Scroll other window up" })

function navigate_quickfix(command)
    pcall(vim.cmd, command)
    vim.cmd("norm! zz")
    vim.cmd("copen")
end

vim.keymap.set({"n", "v", "i"}, "<M-Down>", function() navigate_quickfix("cnext") end)
vim.keymap.set({"n", "v", "i"}, "<M-Up>", function() navigate_quickfix("cprev") end)

vim.keymap.set({'i'}, '<C-r><C-r>', '<C-r>*', {
    noremap = true,
    desc = "Paste from system clipboard"
})
