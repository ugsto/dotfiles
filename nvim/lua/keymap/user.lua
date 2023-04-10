local function setup()
	local map = require("utils.map")

	local opts = {}

	map("n", "<leader>q", function()
		vim.cmd("quit")
	end, opts)
	map("n", "<leader>w", function()
		vim.cmd("write")
	end, opts)
	map("n", "<leader>W", function()
		vim.cmd("write!")
	end, opts)
	map("n", "<leader>Q", function()
		vim.cmd("quit!")
	end, opts)

	map("n", "<leader>ff", function()
		require("telescope.builtin").find_files()
	end, opts)
	map("n", "<leader>fg", function()
		require("telescope.builtin").live_grep()
	end, opts)
	map("n", "<leader>fb", function()
		require("telescope.builtin").buffers()
	end, opts)
	map("n", "<leader>fh", function()
		require("telescope.builtin").help_tags()
	end, opts)

	map("n", "<leader>ft", function()
		vim.lsp.buf.format({ timeout = 1000 })
	end, opts)

	map("n", "<leader>cg", function()
		vim.cmd("ChatGPT")
	end, opts)
	map("n", "<leader>ce", function()
		vim.cmd("ChatGPTEditWithInstructions")
	end, opts)
end

local function main()
	setup()
end

main()
