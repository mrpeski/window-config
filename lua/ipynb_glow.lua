local M = {}

-- Helper: get the JSON lines of the current cell
local function get_cell_range()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local start_line, end_line
  for i = vim.api.nvim_win_get_cursor(0)[1], 1, -1 do
    if lines[i] and lines[i]:match('"cell_type"%s*:%s*"markdown"') then
      start_line = i
      break
    end
  end
  if not start_line then
    return nil
  end

  for i = start_line, #lines do
    if lines[i]:match("^%s*}%s*,?%s*$") then -- end of this cell object
      end_line = i
      break
    end
  end
  return start_line, end_line
end

-- Extract the markdown source from the cell JSON and return a string
local function extract_markdown()
  local s, e = get_cell_range()
  if not s then
    return nil, "Not inside a markdown cell"
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, s - 1, e, false)

  -- Find the "source": [...] array
  local src_start, src_end
  for idx, line in ipairs(lines) do
    if line:match('"source"%s*:%s*%[') then
      src_start = idx
    end
    if src_start and line:match("%]") then
      src_end = idx
      break
    end
  end
  if not src_start then
    return nil, "No source array found"
  end

  local src_lines = {}
  for i = src_start + 1, src_end - 1 do
    -- Strip the surrounding quotes and optional trailing comma
    local l = lines[i]:gsub('^%s*"', ""):gsub('",?%s*$', "")
    table.insert(src_lines, l)
  end
  return table.concat(src_lines, "")
end

-- Public command: open a temporary markdown buffer + glow preview
function M.preview_current_md_cell()
  local md, err = extract_markdown()
  if not md then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  -- Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true) -- listed = false, scratch = true
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_name(buf, "[IPYNB‑MD‑preview]")

  -- Put the markdown text inside
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(md, "\n"))

  -- Open it in a floating window (same size as Glow’s default)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.5),
    row = math.floor((vim.o.lines - math.floor(vim.o.lines * 0.7)) / 2),
    col = math.floor((vim.o.columns - math.floor(vim.o.columns * 0.5)) / 2),
    style = "minimal",
    border = "rounded",
  })

  -- Finally call Glow on that buffer
  require("glow").toggle(buf)
end

return M
