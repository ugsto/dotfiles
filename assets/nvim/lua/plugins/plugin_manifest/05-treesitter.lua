local M = {}

table.insert(M, {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			lazy = true,
		},
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
			auto_install = true,
			highlight = {
				enable = true,
			},
		})
	end,
})

return M
