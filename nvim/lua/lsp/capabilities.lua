local logger = require("loaders.logger")

local has_cmp_nvim_lsp_loaded, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not has_cmp_nvim_lsp_loaded then
	logger.error("Failed to load cmp_nvim_lsp")
	return
end

local M = cmp_nvim_lsp.default_capabilities()

return M
