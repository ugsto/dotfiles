local M = {}

table.insert(M, {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		local wk = require("which-key")
		require("mappings.user").setup(wk)
	end,
})

return M
