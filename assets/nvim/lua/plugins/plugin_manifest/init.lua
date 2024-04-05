local M = {}

local merge_tables = require("utils").merge_tables
local modules = {
  require("plugins.plugin_manifest.00-colorscheme"),
  require("plugins.plugin_manifest.01-lspconfig"),
  require("plugins.plugin_manifest.02-none-ls"),
  require("plugins.plugin_manifest.03-mason"),
  require("plugins.plugin_manifest.04-nvim-dap"),
  require("plugins.plugin_manifest.05-codeium"),
  require("plugins.plugin_manifest.05-lualine"),
  require("plugins.plugin_manifest.05-markdown-preview"),
  require("plugins.plugin_manifest.05-neo-tree"),
  require("plugins.plugin_manifest.05-nvim-autopairs"),
  require("plugins.plugin_manifest.05-nvim-cmp"),
  require("plugins.plugin_manifest.05-nvim-jdtls"),
  require("plugins.plugin_manifest.05-nvim-notify"),
  require("plugins.plugin_manifest.05-rust-tools"),
  require("plugins.plugin_manifest.05-telescope"),
  require("plugins.plugin_manifest.05-treesitter"),
  require("plugins.plugin_manifest.05-trouble"),
  require("plugins.plugin_manifest.05-which-key"),
}

for _, module in ipairs(modules) do
  M = merge_tables(M, module)
end

return M
