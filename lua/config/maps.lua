local map = vim.keymap.set

-- Function to get git directory root, if we are in a git directory 
local function get_git_root()
    local filepath = vim.fn.expand('%:p:h')
    local git_dir = vim.fn.finddir('.git', filepath .. ';')
    if git_dir == '' then
	return nil
    end
    return vim.fn.fnamemodify(git_dir, ':h')
end

-- Function to get first terminal buffer if there are any
local function find_terminal_buffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	if vim.bo[buf].buftype == 'terminal' then
	    return buf
	end
    end
    return nil
end

-- Function to toggle terminal
function Toggle_terminal()
    local t_buffer = find_terminal_buffer()
    if t_buffer ~= nil then
	-- If there is at least one terminal buffer
	local win_ids = vim.fn.win_findbuf(t_buffer)
	if #win_ids > 0 then
	    for _, win_id in ipairs(win_ids) do
		-- Check if the window is the last one
		if #vim.api.nvim_list_wins() > 1 then
		    vim.api.nvim_win_close(win_id, true)
		else
		    -- Print a message instead of closing the last window
		    print("Cannot close the last window!")
		end
	    end
	else
	    -- If there are no open windows for the first terminal buffer - open window in a split below
	    local total_height = vim.api.nvim_win_get_height(0)
	    local term_height = math.floor(total_height * 0.15)  -- percentage of the total height
	    vim.cmd("belowright split | resize " .. term_height .. " | buffer " .. t_buffer)
	    vim.cmd("wincmd p") -- Move cursor back to the previous window

	    vim.api.nvim_buf_call(t_buffer, function()
		vim.cmd("normal! G") -- Go to terminal bottom
	    end)
	end
    else
	-- If there is no terminal buffer - create new terminal buffer in a split below
	-- Current folder will be used as a terminal path 
	vim.cmd("belowright split term://%:p:h//zsh")
	vim.cmd("wincmd p") -- Move cursor back to the previous window
	-- vim.cmd("startinsert")
    end
end

-- Function to find or create a terminal buffer and run the command
local function run_in_terminal(cmd, file_dir)
    -- Look for an existing terminal buffer
    local term_buf = nil
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal" then
            term_buf = buf
            break
        end
    end

    -- Change to the file's directory before running the cmd
    local full_cmd = 'cd "' .. file_dir .. '" && ' .. cmd .. '\n'

    if term_buf then
        -- Get the terminal job ID
        local term_job_id = vim.b[term_buf].terminal_job_id
	-- Scroll to bottom in the terminal buffer
        vim.api.nvim_buf_call(term_buf, function()
            vim.cmd("normal! G")
        end)
        -- Send the command to the existing terminal
        vim.fn.chansend(term_job_id, full_cmd)
    else
        vim.cmd("belowright split | terminal")
        -- Get the job ID of the new terminal
        local new_term_buf = vim.api.nvim_get_current_buf()
        local new_term_job_id = vim.b[new_term_buf].terminal_job_id
        -- Send the command to the new terminal
        vim.fn.chansend(new_term_job_id, full_cmd)
    end
end

-- Function to save the file *.x and run *.sh if conditions are met
function Save_and_build()
    vim.cmd("w")
    vim.cmd("stopinsert")

    local file_pathname = vim.fn.expand('%:p')
    local file_dir = vim.fn.expand("%:p:h")
    local file_name = vim.fn.expand("%:t:r") -- Get name without extension

    -- Example: for data.py script will try to find data.sh
    local script_to_run = string.format("%s/%s.sh", file_dir, file_name)

    if vim.fn.filereadable(script_to_run) == 1 then
	local command = string.format("zsh -c 'source ~/.zshrc && \"%s\"'", script_to_run)
        run_in_terminal(command, file_dir)
	print(string.format("FOUND: %s", script_to_run))
        print(string.format("RUNNING: %s", command))
        return
    else
	print(string.format("NOT FOUND: %s", script_to_run))
	local filetype = vim.bo.filetype
	if filetype == "python" then
	    local command = string.format("zsh -c 'source ~/.zshrc && python \"%s\"'", file_pathname)
	    run_in_terminal(command, file_dir)
	    print(string.format("RUNNING: %s", command))
	elseif filetype == "html" then
	    local command = string.format("open -g %s", file_pathname)
	    run_in_terminal(command, file_dir)
	    print(string.format("RUNNING: %s", command))
	elseif filetype == "lua" then
	    vim.cmd("so")
	    print(string.format("NVIM RUNNING: so %s", file_pathname))
	end
    end
end

vim.keymap.set('n', 'gx', function()
    local word = vim.fn.expand("<cWORD>")
    local url = word:match('https?://[^,%s]+') or word:match('www%.[^,%s]+')
    if url then
        vim.cmd('!open -g ' .. vim.fn.shellescape(url, 1))
    else
        vim.cmd('!open -R ' .. vim.fn.shellescape(vim.fn.expand("<cfile>"), 1))
    end
end, { noremap = true })
--
-- Line moving (from LazyVim)
map("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move line Down" })
map("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move line Up" })
map("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line Down" })
map("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line Up" })
map("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move selected lines Down" })
map("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move selected lines Up" })

function Interrupt_Terminal()
    local t_buffer = find_terminal_buffer()
    if t_buffer ~= nil then
	vim.api.nvim_chan_send(vim.b[t_buffer].terminal_job_id, '\x03')
    else
    print("No open terminal Buffer, so nothing to cancel")
	vim.api.nvim_input('<C-c>')
    end
    return nil
end

-- <leader>fc is from LazyVim
map("n", "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", { desc = "Find Config File" })

-- <leader>fw is from NVChad
-- -- Improved version of map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find Word (live grep)" })
map("n", "<leader>fg", function()
    local git_root = get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    -- require('telescope.builtin.live_grep').git_files({ cwd = git_root })
    vim.cmd("Telescope live_grep cwd=" .. git_root)
end, { desc = "Find Word in git repo (live grep)" })

--
-- <leader>fb is from LazyVim
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })

-- <leader>fr is from LazyVim
map("n", "<leader>fr", function()
    require('telescope.builtin').oldfiles({ only_cwd = false })
end, { desc = "Recent Files" })

-- Improved version of map("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Git Files" }) or
-- (Changed from LazyVim)
map("n", "<leader>ff", function()
    local git_root = get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_files({ cwd = git_root })
end, { desc = "Git Files" })

-- -- Improved version of map("n", "<leader>gf", "<cmd>Telescope git_bcommits<cr>", { desc = "File History" })
-- (Keybind as in LazyVim)
map("n", "<leader>gf", function()
    local git_root = get_git_root()
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
    local git_root = get_git_root()
    if not git_root then
	print("Not inside a Git repository")
	return
    end
    require('telescope.builtin').git_commits({ cwd = git_root })
end, { desc = "Git Commits" })

-- Close floating windows with q, or send q in normal if none
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

-- Show all normal mode keymaps under <leader>? (from LazyVim)
map("n", "<leader>?", function() require("which-key").show("", { mode = "n" }) end, { desc = "Show Normal Mode Keymaps" })
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" }) -- (LazyVim and LspZero defaults)
map("n", "grt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Type Definition" }) -- (LazyVim)

-- -- Window commands in Hydra mode under <C-w><space> (from LazyVim)
-- map({'n', 'x'}, '<leader><C-w>', function()
--     require("which-key").show({keys = "<c-w>", loop = true})
-- end, { desc = "Window Hydra Mode" })

-- vim.keymap.set("v", "<leader>r", function()
--     local selected_text = table.concat(vim.fn.getline("'<", "'>"), "\n")
--     vim.cmd("lua " .. selected_text)
-- end, { desc = "Run selected Lua code" })
