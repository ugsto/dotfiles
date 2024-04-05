local M = {}

table.insert(M, {
  "nvimtools/none-ls.nvim",
  config = function()
    require("null-ls").setup({
      sources = {}
    })
  end,
})

return M
