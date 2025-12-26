return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "sainnhe/sonokai" },
  { "wadackel/vim-dogrun" },
  { "jacoborus/tender.vim" },
  { "dikiaap/minimalist" },
  { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },
  { "Mofiqul/vscode.nvim", name = "vscode" },
  { "Mofiqul/dracula.nvim", name = "dracula" },
  { "whatyouhide/vim-gotham" },
  { "projekt0n/github-nvim-theme", name = "github-theme" },
  { "EdenEast/nightfox.nvim" },
  { "shaunsingh/nord.nvim", name = "nord" },
  {
    "rjshkhr/shadow.nvim",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("shadow")
    end,
  },
  { "dgox16/oldworld.nvim", name = "oldworld" },
  { "mellow-theme/mellow.nvim", name = "mellow" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "shadow",
    },
  },
}
