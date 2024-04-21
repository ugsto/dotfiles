local M = {}

table.insert(M, {
  "rolv-apneseth/tfm.nvim",
  config = function()
    vim.api.nvim_set_keymap("n", "<leader>e", "", {
      noremap = true,
      callback = require("tfm").open,
    })
  end,
})

return M
