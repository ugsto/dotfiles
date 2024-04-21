local M = {}

M.map = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  vim.keymap.set(mode, lhs, rhs, options)

  local wk = require("which-key")
  wk.register({ [lhs] = { name = lhs } }, { mode = mode, silent = true })
end

return M
