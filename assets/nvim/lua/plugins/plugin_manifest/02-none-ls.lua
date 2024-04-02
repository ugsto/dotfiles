local M = {}

table.insert(M, {
  "nvimtools/none-ls.nvim",
  config = function()
    require("null-ls").setup()
  end,
})

return M
