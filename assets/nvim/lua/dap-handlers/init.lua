local mason_nvim_dap = require("mason-nvim-dap")
local M = {
	function(config)
		mason_nvim_dap.default_setup(config)
	end,
}

return M
