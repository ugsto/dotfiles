local logger = require("loaders.logger")
local deep_merge = require("utils.deep-merge")

local function load_server(source)
	local is_lspconfig_loaded, lspconfig = pcall(require, "lspconfig")
	local has_source_custom_config, source_custom_config = pcall(require, "lsp.mason." .. source)
	local default_config = require("lsp.capabilities")

	if not is_lspconfig_loaded then
		logger.error("lspconfig is not loaded")
		return
	end

	if has_source_custom_config then
		logger.debug("source_custom_config: " .. vim.inspect(source_custom_config))
		lspconfig[source].setup(deep_merge(default_config, source_custom_config))
	else
		lspconfig[source].setup(default_config)
	end
end

local function setup()
	local is_mason_loaded, mason = pcall(require, "mason")
	local is_mason_lspconfig_loaded, mason_lspconfig = pcall(require, "mason-lspconfig")

	if not is_mason_loaded then
		logger.error("mason is not loaded")
		return
	end

	if not is_mason_lspconfig_loaded then
		logger.error("mason-lspconfig is not loaded")
		return
	end

	mason.setup()
	mason_lspconfig.setup()
	mason_lspconfig.setup_handlers({
		function(server_name)
			logger.debug("loading source: " .. server_name)
			load_server(server_name)
		end,
	})
end

local function main()
	setup()
end

main()
