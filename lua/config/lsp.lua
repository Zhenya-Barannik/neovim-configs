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

vim.lsp.config('basedpyright', {
    settings = {
	basedpyright = {
	    analysis = {
		autoImportCompletions = true,
		autoSearchPath = true,
		inlayHints = {
		    variableTypes = true,
		},
	    },
	}
    }
})

vim.lsp.enable('basedpyright') -- Works because of "neovim/nvim-lspconfig"
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},  -- Recognize 'vim' as a global variable
        -- globals = {'vim', 'require'}
      },
      workspace = {
	  -- Make the server aware of Neovim runtime files
	  -- With this, "g d" on vim.fn.expand will work
	  library = vim.api.nvim_get_runtime_file("", true),
      },
  }
  }
})
vim.lsp.enable('lua_ls')

vim.lsp.enable('rust_analyzer') -- Works because of "neovim/nvim-lspconfig"

vim.lsp.config('bashls', {
    cmd = {
	'/usr/local/Cellar/node/23.7.0/lib/node_modules/bash-language-server/out/cli.js', -- Path to executable
	'start'
    },
})
vim.lsp.enable('bashls') -- Works because of "neovim/nvim-lspconfig"

vim.lsp.enable('julials')
