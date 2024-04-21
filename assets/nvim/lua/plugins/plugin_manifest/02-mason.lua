local M = {}

local lsp_handlers = require("lsp").handlers

table.insert(M, {
  "williamboman/mason.nvim",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_uninstalled = "✗",
        package_pending = "⟳",
      },
    },
  },
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  build = ":MasonUpdate",
  config = function()
    require("mason").setup()
  end,
})
table.insert(M, {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers(lsp_handlers)
  end,
})
table.insert(M, {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("mason-null-ls").setup({
      ensure_installed = {},
      automatic_installation = false,
      handlers = {},
    })
  end,
})
table.insert(M, {
  "jay-babu/mason-nvim-dap.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("mason-nvim-dap").setup()
  end,
})

return M
