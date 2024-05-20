local M = {}

M.map = function(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	vim.keymap.set(mode, lhs, rhs, options)
end

M.safe_require = function(module)
	local status, lib = pcall(require, module)
	if not status then
		vim.notify("Error requiring module '" .. module .. "': " .. lib, vim.log.levels.ERROR)
		return nil
	end

	return lib
end

return M
