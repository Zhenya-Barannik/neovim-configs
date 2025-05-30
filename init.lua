-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")

-- LSPs setup --
-- https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- https://lsp-zero.netlify.app/blog/lsp-config-overview.html

-- Configure LSP diagnostics to show only errors for Python
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.diagnostic.config({
            virtual_text = {
                severity = { min = vim.diagnostic.severity.ERROR }
            },
            signs = {
                severity = { min = vim.diagnostic.severity.ERROR }
            },
            underline = {
                severity = { min = vim.diagnostic.severity.ERROR }
            },
            float = {
                severity = { min = vim.diagnostic.severity.ERROR }
            }
        })
    end,
})

vim.lsp.enable('lua_ls') -- Works because of "neovim/nvim-lspconfig"
vim.lsp.enable('rust_analyzer') -- Works because of "neovim/nvim-lspconfig"

vim.lsp.config('bashls', {
    cmd = {
	'/usr/local/Cellar/node/23.7.0/lib/node_modules/bash-language-server/out/cli.js', -- Path to executable
	'start'
    },
})
vim.lsp.enable('bashls') -- Works because of "neovim/nvim-lspconfig"

vim.lsp.config('basedpyright', {
    root_markers = { 'main.py', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
})
vim.lsp.enable('basedpyright') -- Works because of "neovim/nvim-lspconfig"

require("oil").setup({
  columns = {
    "icon",
    "size",
    "mtime",
    "birthtime",
  },
  watch_for_changes = false,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    -- ["g?"] = { "actions.show_help", mode = "n" },
    ["<C-s>"] = "<cmd>w<cr><esc>", -- Save file (override default oil action)
    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<CR>"] = "actions.select",
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    -- ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      local m = name:match("^%.")
      return m ~= nil
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
    -- Sort file names with numbers in a more intuitive order for humans.
    -- Can be "fast", true, or false. "fast" will turn it off for large directories.
    natural_order = "fast",
    -- Sort file and directory names case insensitive
    case_insensitive = false,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
    -- Customize the highlight group for the file name
    highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
      return nil
    end,
  },
  -- Configuration for the floating action confirmation window
})

print("NVIM LOADED: init.lua")
