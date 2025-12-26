-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("BufEnter", {
  -- The pattern targets buffers with a name that looks like an Overseer task output.
  -- Overseer task buffers often start with 'overseer://...' or similar.
  -- The most robust pattern, however, is to check for the buftype and then a specific variable.
  -- A simple, robust pattern is often to target non-file buffers.
  pattern = "*",
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Check if the buffer's name is in the format used by Overseer task output:
    -- E.g., 'overseer://task/123/output' or similar.
    -- We can specifically look for the `buftype` and the name pattern.
    if vim.bo.buftype == "terminal" then
      -- Set the filetype to 'log'
      vim.bo.filetype = "log"
    end
  end,
  -- Execute this for the current buffer immediately upon opening a new buffer or window
  group = vim.api.nvim_create_augroup("OverseerLogFiletype", { clear = true }),
})

vim.g.python_host_prog = "/Users/olayinka/.pyenv/versions/neovim2/bin/python"
vim.g.python3_host_prog = "/Users/olayinka/.pyenv/versions/neovim3/bin/python"

require("log-highlight").setup({
  ---@type string|string[]: File extensions. Default: 'log'
  extension = "log",

  ---@type string|string[]: File names or full file paths. Default: {}
  filename = {
    "syslog",
  },

  ---@type string|string[]: File name/path glob patterns. Default: {}
  pattern = {
    -- Use `%` to escape special characters and match them literally.
    "%/var%/log%/.*",
    "console%-ramoops.*",
    "log.*%.txt",
    "logcat.*",
  },

  ---@type table<string, string|string[]>: Custom keywords to highlight.
  ---This allows you to define custom keywords to be highlighted based on
  ---the group.
  ---
  ---The following highlight groups are supported:
  ---    'error', 'warning', 'info', 'debug' and 'pass'.
  ---
  ---The value for each group can be a string or a list of strings.
  ---All groups are empty by default. Keywords are case-sensitive.
  keyword = {
    error = "ERROR_MSG",
    warning = { "WARN_X", "WARN_Y" },
    info = { "INFORMATION" },
    debug = {},
    pass = {},
  },
})

require("maple").setup({
  -- Appearance
  width = 0.6, -- Width of the popup (ratio of the editor width)
  height = 0.6, -- Height of the popup (ratio of the editor height)
  border = "rounded", -- Border style ('none', 'single', 'double', 'rounded', etc.)
  title = " maple ",
  title_pos = "center",
  winblend = 10, -- Window transparency (0-100)
  show_legend = false, -- Whether to show keybind legend in the UI

  -- Storage
  storage_path = vim.fn.stdpath("data") .. "/maple",

  -- Notes management
  notes_mode = "project", -- "global" or "project"
  use_project_specific_notes = true, -- Store notes by project

  -- Keymaps (set to nil to disable)
  keymaps = {
    toggle = "<leader>m", -- Key to toggle Maple
    close = "q", -- Key to close the window
    switch_mode = "m", -- Key to switch between global and project view
  },
})

-- Global variable to track request status
_G.codecompanion_status = ""

-- Helper function to check if a model is a thinking/reasoning model
local function is_thinking_model(model_name)
  if not model_name then
    return false
  end
  local lower_name = model_name:lower()
  return lower_name:match("thinking")
    or lower_name:match("reason")
    or lower_name:match("^o1")
    or lower_name:match("^o3")
end

-- Create autocommand group for statusline updates
local group = vim.api.nvim_create_augroup("CodeCompanionStatusline", {})

-- Track when a request starts
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionRequestStarted",
  group = group,
  callback = function(args)
    _G.codecompanion_status = "󰚩 Sending..." -- AI icon
    vim.cmd("redrawstatus")
  end,
})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionRequestStreaming",
  group = group,
  callback = function(args)
    -- Check if the model is a thinking model
    local model = args.data and args.data.adapter and args.data.adapter.model or ""

    if is_thinking_model(model) then
      -- Use a thinking animation for reasoning models
      local frames = { "󰔟 ", "󰔟.", "󰔟..", "󰔟..." }
      local frame = 1

      local timer = vim.loop.new_timer()
      _G.codecompanion_streaming_timer = timer

      timer:start(
        0,
        500,
        vim.schedule_wrap(function()
          _G.codecompanion_status = frames[frame] .. "Thinking"
          frame = (frame % #frames) + 1
          vim.cmd("redrawstatus")
        end)
      )
    else
      -- Regular streaming animation
      local frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
      local frame = 1

      local timer = vim.loop.new_timer()
      _G.codecompanion_streaming_timer = timer

      timer:start(
        0,
        80,
        vim.schedule_wrap(function()
          _G.codecompanion_status = frames[frame] .. " Streaming..."
          frame = (frame % #frames) + 1
          vim.cmd("redrawstatus")
        end)
      )
    end
  end,
})

-- Update the finished handler to stop the timer
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionRequestFinished",
  group = group,
  callback = function(args)
    -- Stop streaming timer if it exists
    if _G.codecompanion_streaming_timer then
      _G.codecompanion_streaming_timer:stop()
      _G.codecompanion_streaming_timer:close()
      _G.codecompanion_streaming_timer = nil
    end

    _G.codecompanion_status = " Completed"
    vim.defer_fn(function()
      _G.codecompanion_status = ""
      vim.cmd("redrawstatus")
    end, 2000)
  end,
})
