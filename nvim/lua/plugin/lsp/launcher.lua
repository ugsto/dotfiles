local M = {}

require("nvim-lsp-installer").setup {}

local lspconfig = require('lspconfig')
local on_attach = require('plugin.lsp.handlers').on_attach
local on_init = require('plugin.lsp.handlers').on_init
local on_exit = require('plugin.lsp.handlers').on_exit
local capabilities = require('plugin.lsp.handlers').capabilities

local function buf_try_add(server_name, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  lspconfig[server_name].manager.try_add_wrapper(bufnr)
end

local function resolve_config(server_name)
  local defaults = {
    on_attach = on_attach,
    on_init = on_init,
    on_exit = on_exit,
    capabilities = capabilities
  }

  local has_custom_provider, custom_config = pcall(require, "plugin.lsp.providers." .. server_name)
  if has_custom_provider then
    defaults = vim.tbl_deep_extend("force", defaults, custom_config)
  end

  defaults = vim.tbl_deep_extend("force", defaults, {})

  return defaults
end

local function launch_server(server_name, config)
  pcall(function()
    lspconfig[server_name].setup(config)
    buf_try_add(server_name)
  end)
end

M.setup = function(servers)
  for _, server in ipairs(servers) do
    launch_server(server, resolve_config(server))
  end
end

return M
