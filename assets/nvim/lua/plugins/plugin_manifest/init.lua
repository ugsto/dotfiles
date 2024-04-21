local M = {}

local modules = {
  require("plugins.plugin_manifest.00-colorscheme"),
  require("plugins.plugin_manifest.01-lspconfig"),
  require("plugins.plugin_manifest.02-mason"),
  require("plugins.plugin_manifest.03-none-ls"),
  require("plugins.plugin_manifest.04-nvim-dap"),
  require("plugins.plugin_manifest.05-barbar"),
  require("plugins.plugin_manifest.05-codeium"),
  require("plugins.plugin_manifest.05-lazygit"),
  require("plugins.plugin_manifest.05-lualine"),
  require("plugins.plugin_manifest.05-markdown-preview"),
  require("plugins.plugin_manifest.05-nvim-autopairs"),
  require("plugins.plugin_manifest.05-nvim-cmp"),
  require("plugins.plugin_manifest.05-nvim-jdtls"),
  require("plugins.plugin_manifest.05-nvim-notify"),
  require("plugins.plugin_manifest.05-rust-tools"),
  require("plugins.plugin_manifest.05-telescope"),
  require("plugins.plugin_manifest.05-tfm"),
  require("plugins.plugin_manifest.05-treesitter"),
  require("plugins.plugin_manifest.05-trouble"),
  require("plugins.plugin_manifest.05-which-key"),
  require("plugins.plugin_manifest.05-wilder"),
}

for _, module in ipairs(modules) do
  table.insert(M, module)
end

return M
