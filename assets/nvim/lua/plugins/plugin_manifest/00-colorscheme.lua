local M = {}

table.insert(M, {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup()
    vim.cmd[[colorscheme tokyonight]]
  end,
})

return M
