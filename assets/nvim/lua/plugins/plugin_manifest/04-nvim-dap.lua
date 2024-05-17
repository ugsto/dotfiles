local M = {}

table.insert(M, "mfussenegger/nvim-dap")
table.insert(M, {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"nvim-neotest/nvim-nio",
	},
})

return M
