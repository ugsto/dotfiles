local logger = require("loaders.logger")

local function load_module(module)
	logger.debug("Loading module: " .. module)
	local start_time = os.clock()
	require(module)
	local end_time = os.clock()
	logger.debug("Finished loading module: " .. module .. " in " .. end_time - start_time .. " seconds")
end

load_module("plugin")
load_module("opts")
load_module("lsp")
load_module("keymap")
load_module("colorscheme")
load_module("artificial-inteligence")
load_module("file-tree")
load_module("autocmd")
