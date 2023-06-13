local function setup()
	local map = require("utils.map")

	map("n", "<C-m>p", vim.diagnostic.open_float)
	map("n", "[d", vim.diagnostic.goto_prev)
	map("n", "]d", vim.diagnostic.goto_next)
	map("n", "<leader>k", vim.lsp.buf.hover)
	map("n", "<leader>gd", vim.lsp.buf.definition)
end

local function main()
	setup()
end

main()
