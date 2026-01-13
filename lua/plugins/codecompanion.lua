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
          local adapter_utils = require("codecompanion.utils.adapters")

          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "llama",
            formatted_name = "llama",
            env = {
              url = "http://127.0.0.1:2276",
              api_key = "localp",
              chat_url = "/v1/chat/completions",
            },
            handlers = {
              parse_message_meta = function(self, data)
                local extra = data.extra
                if extra and extra.reasoning_content then
                  data.output.reasoning = { content = extra.reasoning_content }
                  if data.output.content == "" then
                    data.output.content = nil
                  end
                end
                return data
              end,
              ---Set the format of the role and content for the messages from the chat buffer
              ---@param self CodeCompanion.HTTPAdapter
              ---@param messages table Format is: { { role = "user", content = "Your prompt here" } }
              ---@return table
              form_messages = function(self, messages)
                messages = adapter_utils.merge_messages(messages)
                messages = adapter_utils.merge_system_messages(messages)

                messages = vim
                  .iter(messages)
                  :map(function(msg)
                    -- Ensure that all messages have a content field
                    local content = msg.content
                    if content and type(content) == "table" then
                      msg.content = table.concat(content, "\n")
                    elseif not content then
                      msg.content = ""
                    end

                    -- Process tools
                    if msg.tools then
                      if msg.tools.calls then
                        msg.tool_calls = msg.tools.calls
                      end
                      if msg.tools.call_id then
                        msg.tool_call_id = msg.tools.call_id
                      end
                      msg.tools = nil
                    end

                    return msg
                  end)
                  :totable()

                return { messages = messages }
              end,
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://127.0.0.1:11434",
              -- chat_url = "/api/chat"
              -- model= "qwen3-coder-480b-cloud"
            },
            -- model = "gpt-oss:120b-cloud",
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
        adapter = "ollama",
      },
      inline = {
        adapter = "ollama",
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
        adapter = "ollama",
      },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
  },
}
