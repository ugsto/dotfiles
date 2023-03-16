local try_require = require("utils.try-require")

local M = {}

local config = {
    capabilities = try_require("config.lspconfig.capabilities") or os.exit(1),
    flags = try_require("config.lspconfig.flags") or os.exit(1),
    on_attach = try_require("config.lspconfig.on_attach") or os.exit(1)
}

local lsp = try_require("config.lspconfig.lsp") or os.exit(1)

M.config = config
M.lsp = lsp

return M
