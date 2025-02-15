return {
	"williamboman/mason.nvim",
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = {
				"neovim/nvim-lspconfig",
			},
		},
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = {
				"mfussenegger/nvim-dap",
				"rcarriga/nvim-dap-ui",
				"nvim-neotest/nvim-nio",
				"nvim-treesitter/nvim-treesitter",
				"theHamsta/nvim-dap-virtual-text",
				"leoluz/nvim-dap-go",
			},
		},
		{
			"jay-babu/mason-null-ls.nvim",
			dependencies = {
				{
					"nvimtools/none-ls.nvim",
					dependencies = {
						"nvim-lua/plenary.nvim",
					},
				},
			},
		},
		{ "mrcjkb/rustaceanvim", version = "^5", lazy = false },
	},
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonLog",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonUpdate",
	},
	build = ":MasonUpdate",
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_uninstalled = "✗",
					package_pending = "⟳ ",
				},
			},
		})
		require("mason-lspconfig").setup({ ensure_installed = { "lua_ls" } })
		require("mason-lspconfig").setup_handlers(require("ugvim.lsp-handlers"))
		require("mason-null-ls").setup({ handlers = {} })
		require("mason-nvim-dap").setup({ handlers = {} })
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		require("nvim-dap-virtual-text").setup()
		require("dap-go").setup()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<C-S-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>F", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})
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
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Continue",
		},
		{
			"<F9>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<C-<F11>>",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<leader><F5>",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle dap-ui",
		},
		{
			"<leader><F17>",
			function()
				require("dapui").setup()
			end,
			desc = "Update dap-ui",
		},
	},
}
