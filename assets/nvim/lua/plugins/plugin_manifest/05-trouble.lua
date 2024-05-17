local M = {}

table.insert(M, {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    auto_open = true,
    auto_close = true,
  },
})

return M
