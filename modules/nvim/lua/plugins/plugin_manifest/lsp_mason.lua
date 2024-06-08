return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_uninstalled = "✗",
					package_pending = "⟳",
				},
			},
		},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				"checkmake",
				"debugpy",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"harper-ls",
				"lua-language-server",
				"prettierd",
				"stylua",
				"taplo",
				"yaml-language-server",
			})
			require("mason-lspconfig").setup_handlers(require("lsp-handlers"))
		end,
	},
}
