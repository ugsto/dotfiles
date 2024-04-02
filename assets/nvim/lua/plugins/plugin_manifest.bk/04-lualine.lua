local M = {}

table.insert(M, {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup()
  end
})

return M
