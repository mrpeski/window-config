-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end
return {
  {"neovim/nvim-lspconfig"},
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  {
    "andrewferrier/debugprint.nvim",
    lazy = false, 
    version = "*"
  },
{
  "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
}, {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    view= "cmdline"
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    "rcarriga/nvim-notify",
    }
}, {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    { "kevinhwang91/promise-async" },
  },
    opts = function ()
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)


      -- Option 2: nvim lsp as LSP client
      -- Tell the server the capability of foldingRange,
      -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
      }
      local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
          require('lspconfig')[ls].setup({
              capabilities = capabilities
              -- you can add other fields for setting up lsp server in this table
          })
      end
      -- require('ufo').setup()
    end
},
  {
    'fei6409/log-highlight.nvim',
    opts = {},
},
  {
  'forest-nvim/maple.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
      -- Your configuration options here
    }
}
}
