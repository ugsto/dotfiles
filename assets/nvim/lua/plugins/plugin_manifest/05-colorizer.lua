local M = {}

table.insert(M, {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup()
	end,
})

return M
