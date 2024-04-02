local M = {}

table.insert(M, {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = true
    }
  },
  build = ":TSUpdate"
})

return M
