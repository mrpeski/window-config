-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

local neotest = require("neotest")

-- Small wrapper to keep the mapping call tidy
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

-- Run nearest test
map("n", "<leader>tr", function()
  neotest.run.run()
end, "Neotest: run nearest")

-- Run current file
map("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, "Neotest: run file")

-- Run whole suite (project root)
map("n", "<leader>tS", function()
  neotest.run.run(vim.fn.getcwd())
end, "Neotest: run suite")

-- Toggle output panel
map("n", "<leader>to", function()
  neotest.output_panel.toggle()
end, "Neotest: toggle output panel")

-- Toggle summary window
map("n", "<leader>ts", function()
  neotest.summary.toggle()
end, "Neotest: toggle summary")

-- Watch (re‑run on file changes)
map("n", "<leader>tw", function()
  neotest.watch.watch()
end, "Neotest: watch")

-- Jump to the next failed test
map("n", "<leader>tn", function()
  neotest.jump.next({ status = "failed" })
end, "Neotest: jump to test")

-- Jump to the prev failed test
map("n", "<leader>tp", function()
  neotest.jump.prev({ status = "failed" })
end, "Neotest: jump to test")
