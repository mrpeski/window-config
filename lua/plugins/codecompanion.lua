return {
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
              api_key = "OPENAPI_KEY",
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "GEMINI_KEY",
            },
          })
        end,
        llama = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://127.0.0.1:2276", -- replace with your llama.cpp instance
              api_key = "localp",
              chat_url = "/v1/chat/completions",
              -- model= "qwen3-coder-480b-cloud"
              -- model="gpt-oss:120b-cloud"
            },
            -- handlers = {
            --   parse_message_meta = function(self, data)
            --     local extra = data.extra
            --     if extra and extra.reasoning_content then
            --       data.output.reasoning = { content = extra.reasoning_content }
            --       if data.output.content == "" then
            --         data.output.content = nil
            --       end
            --     end
            --     return data
            --   end,
            -- },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://127.0.0.1:11434",
              -- chat_url = "/api/chat"
            },
            -- headers = {
            --   ["Content-Type"] = "application/json",
            --   ["Authorization"] = "Bearer ${api_key}",
            -- },
            -- parameters = {
            --   sync = true,
            -- },
          })
        end,
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
        adapter = "llama",
      },
      inline = {
        adapter = "llama",
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
        adapter = "llama",
      },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
  },
}
