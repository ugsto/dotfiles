return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "_color_red" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "_color_peach" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "_color_maroon" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "_color_blue" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "_color_yellow" })
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "python", "delve" },
				handlers = require("dap-handlers"),
			})
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
}
