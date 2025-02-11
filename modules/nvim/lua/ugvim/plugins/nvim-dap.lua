return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		{ "nvim-treesitter/nvim-treesitter", dependencies = {
			"theHamsta/nvim-dap-virtual-text",
		} },
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		require("nvim-dap-virtual-text").setup()
		require("dap-go").setup()
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

		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "CatppuccinRed", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "", texthl = "CatppuccinMaroon", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "", texthl = "CatppuccinBlue", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "→", texthl = "CatppuccinRed", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "CatppuccinRed", linehl = "", numhl = "" })
	end,
	keys = {
		{ "<leader>d", group = "debugger" },
		{ "<leader>db", "<cmd>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint", mode = "n" },
		{ "<leader>dc", "<cmd>DapContinue<CR>", desc = "Continue", mode = "n" },
		{ "<leader>di", "<cmd>DapStepInto<CR>", desc = "Step Into", mode = "n" },
		{ "<leader>do", "<cmd>DapStepOut<CR>", desc = "Step Out", mode = "n" },
		{ "<leader>dn", "<cmd>DapStepOver<CR>", desc = "Step Over", mode = "n" },
		{ "<leader>dr", "<cmd>DapRestart<CR>", desc = "Restart", mode = "n" },
		{ "<leader>dq", "<cmd>DapTerminate<CR>", desc = "Quit/Terminate", mode = "n" },
		{ "<leader>dl", "<cmd>DapListBreakpoints<CR>", desc = "List Breakpoints", mode = "n" },
		{
			"<leader>dut",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle UI",
			mode = "n",
		},
		{
			"<leader>dus",
			function()
				require("dapui").setup()
			end,
			desc = "Update UI",
			mode = "n",
		},
	},
}
