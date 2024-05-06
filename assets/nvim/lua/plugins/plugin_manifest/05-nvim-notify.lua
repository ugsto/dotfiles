local M = {}

table.insert(M, {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify").setup({
      level = 3,
    })
  end,
})

return M
