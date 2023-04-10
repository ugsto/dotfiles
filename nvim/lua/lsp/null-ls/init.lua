local logger = require("loaders.logger")

local function load_sources(null_ls)
	local sourcesFile = io.open(vim.fn.stdpath("config") .. "/lua/lsp/null-ls/sources.txt", "r")
	local sources = {}
	for source in sourcesFile:lines() do
		local source_type, source_name = source:match("([^ ]+) ([^ ]+)")
		local source_ref = null_ls.builtins[source_type][source_name]

		local has_source_custom_config, source_custom_config = pcall(require, "lsp.null-ls." .. source)

		if has_source_custom_config then
			logger.debug("source_custom_config: " .. vim.inspect(source_custom_config))
			source_ref = source_ref.with(source_custom_config)
		end
		logger.debug("loading source: " .. source)

		table.insert(sources, source_ref)
	end

	return sources
end

local function setup()
	local is_null_ls_loaded, null_ls = pcall(require, "null-ls")

	if not is_null_ls_loaded then
		logger.error("null-ls is not loaded")
		return
	end

	null_ls.setup({
		sources = load_sources(null_ls),
	})
end

local function main()
	setup()
end

main()
