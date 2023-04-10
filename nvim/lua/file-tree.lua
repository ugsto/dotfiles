local logger = require("loaders.logger")

local function setup()
	local has_nvim_tree_loaded, nvim_tree = pcall(require, "nvim-tree")

	if not has_nvim_tree_loaded then
		logger.error("Failed to load nvim-tree")
		return
	end

	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	nvim_tree.setup({
		sort_by = "case_sensitive",
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = true,
		},
	})
end

local function main()
	setup()
end

main()
