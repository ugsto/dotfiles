local safe_require = require("utils").safe_require

local M = {}

local tfm = safe_require("tfm")
local telescope_builtin = safe_require("telescope.builtin")
local dap = safe_require("dap")
local neotest = safe_require("neotest")

M.setup = function(wk)
	wk.register({
		e = {
			tfm and tfm.open,
			"Open TFM",
		},
	}, { prefix = "<leader>" })

	wk.register({
		q = { "<CMD>q<CR>", "Quit" },
		w = { "<CMD>w<CR>", "Save" },
	}, { prefix = "<leader>" })

	wk.register({
		f = {
			name = "Telescope",
			f = {
				telescope_builtin and telescope_builtin.find_files,
				"Find File",
			},
			g = {
				telescope_builtin and telescope_builtin.live_grep,
				"Grep",
			},
			b = {
				telescope_builtin and telescope_builtin.buffers,
				"Buffers",
			},
			h = {
				telescope_builtin and telescope_builtin.help_tags,
				"Help",
			},
			c = {
				telescope_builtin and telescope_builtin.colorscheme,
				"Colorscheme",
			},
		},
	}, { prefix = "<leader>" })

	wk.register({
		d = {
			name = "Debugger",
			t = { dap and dap.toggle_breakpoint, "Toggle breakpoint" },
			b = { dap and dap.toggle_repl, "Toggle repl" },
			c = { dap and dap.continue, "Continue" },
			n = { dap and dap.step_over, "Step over" },
			i = { dap and dap.step_into, "Step into" },
			o = { dap and dap.step_out, "Step out" },
		},
	}, { prefix = "<leader>" })

	wk.register({
		t = {
			name = "Test",
			r = { neotest and neotest.run.run, "Run" },
			d = { neotest and function()
				neotest.run.run({ strategy = "dap" })
			end, "Run in debug mode" },
			s = { neotest and neotest.run.stop, "Stop" },
			a = { neotest and neotest.run.attach, "Attach" },
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
		["<C-h>"] = { "<CMD>wincmd h<CR>" },
		["<C-j>"] = { "<CMD>wincmd j<CR>" },
		["<C-k>"] = { "<CMD>wincmd k<CR>" },
		["<C-l>"] = { "<CMD>wincmd l<CR>" },
	})

	wk.register({
		["<A-h>"] = { "<CMD>BufferPrevious<CR>", "Go to previous buffer" },
		["<A-l>"] = { "<CMD>BufferNext<CR>", "Go to next buffer" },

		["<A-S-H>"] = { "<CMD>BufferMovePrevious<CR>", "Move buffer to previous position" },
		["<A-S-L>"] = { "<CMD>BufferMoveNext<CR>", "Move buffer to next position" },

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
				["<C-S-k>"] = { vim.lsp.buf.signature_help, "Show signature help" },
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
end

return M
