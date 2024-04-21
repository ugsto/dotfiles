local M = {}

table.insert(M, {
  "olimorris/onedarkpro.nvim",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme onedark")
  end,
})

return M
