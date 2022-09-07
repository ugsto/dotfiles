local M = {}

local keymap = require('keymap').lsp_handler_on_attach
M.on_attach = function(_, bufnr)
  keymap(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if status_ok then
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

M.capabilities = capabilities

return M
