local M = {}

local merge_tables = require("utils").merge_tables
local modules = {
  require("plugins.plugin_manifest.00-colorscheme"),
  require("plugins.plugin_manifest.01-lspconfig"),
  require("plugins.plugin_manifest.02-mason"),
  require("plugins.plugin_manifest.03-nvim-dap"),
  require("plugins.plugin_manifest.04-codeium"),
  require("plugins.plugin_manifest.04-lualine"),
  require("plugins.plugin_manifest.04-markdown-preview"),
  require("plugins.plugin_manifest.04-neo-tree"),
  require("plugins.plugin_manifest.04-nvim-autopairs"),
  require("plugins.plugin_manifest.04-nvim-cmp"),
  require("plugins.plugin_manifest.04-nvim-jdtls"),
  require("plugins.plugin_manifest.04-rust-tools"),
  require("plugins.plugin_manifest.04-telescope"),
  require("plugins.plugin_manifest.04-treesitter"),
  require("plugins.plugin_manifest.04-trouble"),
  require("plugins.plugin_manifest.04-which-key")
}

for _, module in ipairs(modules) do
  M = merge_tables(M, module)
end

return M
