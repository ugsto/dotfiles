local M = {}

table.insert(M, {
  "Exafunction/codeium.vim",
  config = function()
    local mapping_setup = require("mappings.codeium")
    vim.g.codeium_disable_bindings = 1

    mapping_setup.setup()
  end,
  event = "BufEnter",
})

return M
