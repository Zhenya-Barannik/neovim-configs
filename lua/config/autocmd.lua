-- Enable treesitter based highlighting for selected filetypes
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'c', 'sh', 'julia', 'rust', 'python'},
    callback = function()
	vim.treesitter.start()
    end,
})

-- Set multline comments in C to use //
vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    command = "setlocal commentstring=//\\ %s"
})

-- Briefly highlight on yanking (from LazyVim)
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
	vim.highlight.on_yank()
    end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
	local current_tab = vim.fn.tabpagenr()
	vim.cmd("tabdo wincmd =")
	vim.cmd("tabnext " .. current_tab)
    end,
})

-- Close buffers with <q>
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
	"help",
	"lspinfo",
	"qf",
	"checkhealth",
    },
    callback = function(event)
	vim.bo[event.buf].buflisted = false
	if event.match == "qf" then
	    close_cmd = close_and_restore
	else
	    close_cmd = "<cmd>close<cr>"
	end
	vim.keymap.set("n", "q", close_cmd, {
	    buffer = event.buf,
	    silent = true,
	    desc = "Quit buffer",
	})
    end,
})

