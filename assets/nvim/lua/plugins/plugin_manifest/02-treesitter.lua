local M = {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			lazy = true,
		},
	},
	build = ":TSUpdate",
	opts = {
		ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
		auto_install = true,
		highlight = {
			enable = true,
		},
	},
}

return M
