local M = {}

M.safe_require = function(module)
	local status, lib = pcall(require, module)
	if not status then
		vim.notify("Error requiring module '" .. module .. "'")
		return nil
	end

	return lib
end

return M
