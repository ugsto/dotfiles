local function load_vim_source(file_name)
	local path = string.format("%s/%s/%s", vim.fn.stdpath("config"), "vim", file_name)
	local source_cmd = "source " .. path
	vim.cmd(source_cmd)
end

local function load_lua_module(module_name)
	package.loaded[module_name] = nil
	require(module_name)
end

load_vim_source("options.vim")

load_lua_module("plugins")
load_lua_module("mappings.user")
load_lua_module("autocommands")
