local M = {}

table.insert(M, {
  "TobinPalmer/rayso.nvim",
  cmd = { "Rayso" },
  config = function()
    require("rayso").setup {}
  end
})

return M
