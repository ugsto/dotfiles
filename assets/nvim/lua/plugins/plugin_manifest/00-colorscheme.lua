local M = {}

table.insert(M, {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('onedark').load()
  end,
})

return M
