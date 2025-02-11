return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
		{ "<leader>q", "<CMD>q<CR>", desc = "quit" },
		{ "<C-s>", "<CMD>w<CR>", desc = "Write" },
		{ "<C-w>h", "<CMD>bprevious<CR>", desc = "Previous tab" },
		{ "<C-w>l", "<CMD>bnext<CR>", desc = "Next tab" },
		{ "<A-w>", "<CMD>bdelete<CR>", desc = "Delete tab" },
	},
}
