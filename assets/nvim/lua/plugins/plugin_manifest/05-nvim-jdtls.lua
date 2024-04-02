local M = {}

table.insert(M, {
  "mfussenegger/nvim-jdtls",
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "jdtls" },
    },
  },
})

return M
