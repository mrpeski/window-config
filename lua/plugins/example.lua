-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end
return {
  {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
    http = {
      openai_responses = function()
        return require("codecompanion.adapters").extend("openai_responses", {
          env = {
            api_key = "SOURCE_ONE",
          },
        })
      end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "SOURCE_TWO",
          },
        })

        end
    },
  },
    display = {
      diff = {
        enabled = true,
        close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
        layout = "vertical", -- vertical|horizontal split for default provider
        opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
        provider = "mini_diff", -- default|mini_diff
      },
    },
    strategies = {
      chat = {
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
        keymaps = {
          accept_change = {
            modes = { n = "ga" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gr" },
            description = "Reject the suggested change",
          },
        },
      },
      cmd = {
        adapter = "gemini",
      },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
  },
  },
  {"neovim/nvim-lspconfig"},
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  {
    "andrewferrier/debugprint.nvim",
    lazy = false, 
    version = "*"
  }

}
