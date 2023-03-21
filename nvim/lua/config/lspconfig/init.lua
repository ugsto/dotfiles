local M = {}

local config = {
    capabilities = require("config.lspconfig.capabilities"),
    flags = require("config.lspconfig.flags"),
    on_attach = require("config.lspconfig.on_attach"),
}

local lsp = require("config.lspconfig.lsp")

M.config = config
M.lsp = lsp

return M
