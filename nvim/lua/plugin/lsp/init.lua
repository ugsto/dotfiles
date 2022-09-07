local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then
  return
end

require('plugin.lsp.launcher').setup({
  'pyright',
  'rust_analyzer',
  'sumneko_lua',
  'html',
  'jsonls',
  'tsserver',
  'eslint',
  'clangd',
  'bashls',
  'yamlls',
  'sqlls',
  'sqls'
})
require('plugin.lsp.cmp')
require('plugin.lsp.null-ls')
