-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.fn.has("win32") then
  vim.o.shell = [["C:/Program Files/Git/bin/bash.exe"]]
  vim.o.shellcmdflag = "-c"
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end

require("overseer").setup({
  -- ... other configurations ...
  strategy = { "toggleterm" },
})
