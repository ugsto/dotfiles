local M = {}

local wk = require("which-key")

M.setup = function(opts)
	local prefixedOpts = { prefix = "<leader>" }
	vim.tbl_deep_extend("force", prefixedOpts, opts)

	wk.register({
		g = {
			name = "Go",
			d = { vim.lsp.buf.definition, "Go to definition" },
			i = { vim.lsp.buf.implementation, "Go to implementation" },
			r = { vim.lsp.buf.references, "Go to references" },
		},
		K = { vim.lsp.buf.hover, "Show hover" },
		["<C-k>"] = { vim.lsp.buf.signature_help, "Show signature help" },
	}, opts)

	wk.register({
		["wa"] = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
		["wr"] = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
		["wl"] = {
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			"List workspace folders",
		},
		["D"] = { vim.lsp.buf.type_definition, "Type definition" },
		["rn"] = { vim.lsp.buf.rename, "Rename" },
		["ca"] = { vim.lsp.buf.code_action, "Code action" },
		["F"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"Format",
		},
	}, prefixedOpts)
end

return M
