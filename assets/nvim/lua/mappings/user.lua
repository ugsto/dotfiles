local wk = require("which-key")

vim.g.mapleader = " "

wk.register({
	e = {
		function()
			require("tfm").open()
		end,
		"Open TFM",
	},
}, { prefix = "<leader>" })

wk.register({
	q = { "<CMD>q<CR>", "Quit" },
	w = { "<CMD>w<CR>", "Save" },
}, { prefix = "<leader>" })

wk.register({
	f = {
		name = "File",
		f = { "<CMD>Telescope find_files<CR>", "Find File" },
		g = { "<CMD>Telescope live_grep<CR>", "Grep" },
		b = { "<CMD>Telescope buffers<CR>", "Buffers" },
		h = { "<CMD>Telescope help_tags<CR>", "Help" },
	},
}, { prefix = "<leader>" })

wk.register({
	d = {
		name = "Debugger",
		t = { "<CMD>DapToggleBreakpoint<CR>", "Toggle breakpoint" },
		b = { "<CMD>DapToggleRepl<CR>", "Toggle repl" },
		c = { "<CMD>DapContinue<CR>", "Continue" },
		n = { "<CMD>DapStepOver<CR>", "Step over" },
		i = { "<CMD>DapStepInto<CR>", "Step into" },
		o = { "<CMD>DapStepOut<CR>", "Step out" },
	},
}, { prefix = "<leader>" })

wk.register({
	lg = { "<CMD>LazyGit<CR>", "Open LazyGit" },
}, { prefix = "<leader>" })

wk.register({
	["[d"] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
	["]d"] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
})

wk.register({
	["<A-.>"] = { "<CMD>BufferNext<CR>", "Go to next buffer" },
	["<A-,>"] = { "<CMD>BufferPrevious<CR>", "Go to previous buffer" },

	["<A-<>"] = { "<CMD>BufferMovePrevious<CR>", "Move buffer to previous position" },
	["<A->>"] = { "<CMD>BufferMoveNext<CR>", "Move buffer to next position" },

	["<A-[>"] = { "<CMD>BufferFirst<CR>", "Go to first buffer" },
	["<A-]>"] = { "<CMD>BufferLast<CR>", "Go to last buffer" },

	["<A-q>"] = { "<CMD>BufferClose<CR>", "Close buffer" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local opts = { buffer = ev.buf }
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
	end,
})
