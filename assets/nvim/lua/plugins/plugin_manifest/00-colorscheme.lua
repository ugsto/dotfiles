local M = {}

table.insert(M, {
  "olimorris/onedarkpro.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd [[colorscheme onedark]]
  end,
})

return M
