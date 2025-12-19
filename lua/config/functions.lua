-- Function to get first terminal buffer if there are any
function Find_terminal_buffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	if vim.bo[buf].buftype == 'terminal' then
	    return buf
	end
    end
    return nil
end

-- Function to interrupt terminal (if there is a terminal) and exit from insert mode
-- Acts as default Ctrl-C if there is no terminal
function Interrupt_terminal_and_stop_insert()
    local t_buffer = Find_terminal_buffer()
    if t_buffer ~= nil then
        local job_id = vim.b[t_buffer].terminal_job_id
        if job_id then
            vim.api.nvim_chan_send(job_id, '\x03') -- Send interrupt (Ctrl-C)
        end
    end
    vim.cmd('stopinsert') -- Exit from insert mode
end

-- Function to get git project root, if we are in a git project subdirectory 
function Get_git_root()
    local filepath = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fs.dirname(filepath)

    if current_dir == '' then
	return nil
    end

    local home_dir = vim.loop.os_homedir()
    local git_root = vim.fs.find('.git', {
	upward = true, -- Explicitly says: "search upwards"
	path = current_dir,
	limit = 1,
	stop = home_dir,
    })[1] -- [1] since function return a table (with 1 value at most)

    if git_root then
	return vim.fs.dirname(git_root)
    end
end

-- Function to toggle terminal
function Toggle_terminal()
    local t_buffer = Find_terminal_buffer() -- attemps to find terminal buffer, will pick the first found
    if t_buffer ~= nil then
	-- If there is at least one terminal buffer
	local t_window_ids = vim.fn.win_findbuf(t_buffer) -- find windows for found terminal buffer
	if #t_window_ids > 0 then
	    for _, win_id in ipairs(t_window_ids) do
		-- Check if the window is the last one
		if #vim.api.nvim_list_wins() > 1 then
		    vim.api.nvim_win_close(win_id, true)
		else
		    -- Print a message instead of closing the last window
		    print("Cannot close the last window!")
		end
	    end
	else
	    -- If there are no open windows for the found terminal buffer - open window in a split below
	    local total_height = vim.api.nvim_win_get_height(0)
	    local term_height = math.floor(total_height * 0.15)  -- fraction of total height
	    vim.cmd("belowright split | resize " .. term_height .. " | buffer " .. t_buffer)
	    vim.cmd("wincmd p") -- Move cursor back to the previous window

	    vim.api.nvim_buf_call(t_buffer, function()
		vim.cmd("normal! G") -- Go to terminal bottom
	    end)
	end
    else
	-- If there are no terminal buffers - create a terminal buffer in a split below
	-- Current folder will be used for terminal path 
	local total_height = vim.api.nvim_win_get_height(0)
	local term_height = math.floor(total_height * 0.15)  -- fraction of total height
	vim.cmd("belowright split term://%:p:h//zsh")
	vim.cmd("resize " .. term_height)
	vim.cmd("wincmd p") -- Move cursor back to the previous window
    end
end

-- Function to find or create a terminal buffer and run the command
function Run_in_terminal(cmd)
    local t_buffer = Find_terminal_buffer()

    if t_buffer then
        local term_job_id = vim.b[t_buffer].terminal_job_id
	-- Scroll to bottom in the terminal buffer
        vim.api.nvim_buf_call(t_buffer, function()
            vim.cmd("normal! G")
        end)
        -- Send the command
        vim.fn.chansend(term_job_id, cmd .. '\n')
    else
        vim.cmd("belowright split | terminal")
        -- Get the job ID of the new terminal
        local new_t_buffer = vim.api.nvim_get_current_buf()
        local term_job_id = vim.b[new_t_buffer].terminal_job_id
        -- Send the command
        vim.fn.chansend(term_job_id, cmd .. '\n')
    end
end

-- Function to save the code file and execute it if conditions are met
function Save_and_build()
    vim.cmd("silent! w") -- Suppresses info like this: "main.py" 52L, 1427B written 
    local file_pathname = vim.fn.expand('%:p')
    local file_dir = vim.fn.expand("%:p:h")
    local file_name = vim.fn.expand("%:t:r") -- Get the filename without extension

    -- Example: for data.py we will try to find data.sh
    local script_name = string.format("%s/%s.sh", file_dir, file_name)
    if vim.fn.filereadable(script_name) == 1 then
	-- Crafts a composite command that will 
	-- (1) source .zshrc,
	-- (2) change path to the file's directory
	-- (3) run the rest of the command 
	local full_cmd = string.format(
	    "zsh -c 'source ~/.zshrc && cd \"%s\" && \"%s\"'",
	    file_dir,
	    script_name
	)
	print(string.format("RUNNING: \"%s\"", script_name))
        Run_in_terminal(full_cmd)
	return
    else
	local filetype = vim.bo.filetype

	-- Julia
	if filetype == "julia" then
	    print(string.format("Sending to REPL: \"%s\"", file_name .. ".jl"))
	    local julia_cmd = string.format('include("%s")\n', file_pathname)
	    vim.fn["slime#send"](julia_cmd)
	    vim.schedule(Scroll_terminal_to_bottom)
	    return

	-- Python
	elseif filetype == "python" then
	    local full_cmd = string.format(
		"zsh -c 'source ~/.zshrc && python \"%s\"'",
		file_pathname
	    )
	    print(string.format("RUNNING: python \"%s\"", file_pathname))
	    Run_in_terminal(full_cmd)
	    return

	-- Lua
	elseif filetype == "lua" then
	    print(string.format("NVIM RUNNING: so \"%s\"", file_pathname))
	    vim.cmd("so")
	    return

	-- HTML
	elseif filetype == "html" or filetype == "xhtml" then
	    local full_cmd = string.format("open -g \"%s\"", file_pathname)
	    print(string.format("RUNNING: \"%s\"", full_cmd))
	    vim.fn.system(full_cmd)
	    return
	end
    end
end

-- Toggle between Russian and QWERTY layouts
function Toggle_keyboard_layout()
    if vim.bo.keymap == "" then
        vim.api.nvim_command('set keymap=russian-jcuken')
    else
        vim.api.nvim_command('set keymap=')
    end
end

-- https://github.com/nvim-telescope/telescope.nvim but for all modes
function Show_keymaps_for_current_mode()
    local mode = vim.api.nvim_get_mode().mode
    require("which-key").show("", { mode = mode })
end

function Reveal_file_or_open_URL()
    local word = vim.fn.expand("<cWORD>")
    local url = word:match('https?://[^,%s]+') or word:match('www%.[^,%s]+')
    if url then
        vim.cmd('!open ' .. vim.fn.shellescape(url, true)) -- Open link in browser (-g opens in background)
	-- vim.cmd('!open -g ' .. vim.fn.shellescape(url, 1))
    else
        vim.cmd('!open -R ' .. vim.fn.shellescape(vim.fn.expand("<cfile>"), true)) -- Reveal file in Finder
    end
end

function Scroll_terminal_to_bottom()
    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
        if buftype == 'terminal' then
            vim.api.nvim_set_current_win(win)
            -- 'G' scrolls to the end of buffer
            vim.cmd("normal! G")
            vim.api.nvim_set_current_win(current_win)
            return
        end
    end
end

function Send_key_to_other_window(key)
  local current_win = vim.api.nvim_get_current_win()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local target_win = nil
  for _, win in ipairs(windows) do
    if win ~= current_win then
      target_win = win
      break
    end
  end

  if target_win and vim.api.nvim_win_is_valid(target_win) then
    local scroll_cmd = vim.api.nvim_replace_termcodes(key, true, false, true)
    vim.api.nvim_win_call(target_win, function()
      vim.cmd("normal! " .. scroll_cmd)
    end)
  end
end
