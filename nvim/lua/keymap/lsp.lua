local function setup()
	local map = require("utils.map")

	map("n", "<C-e>", vim.diagnostic.open_float)
	map("n", "[d", vim.diagnostic.goto_prev)
	map("n", "]d", vim.diagnostic.goto_next)
	map("n", "<C-q>", vim.diagnostic.setloclist)
end

local function main()
	setup()
end

main()
