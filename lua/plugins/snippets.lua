return {
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      -- Load custom vscode-style snippets from the path we created
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
    end,
  },
}
