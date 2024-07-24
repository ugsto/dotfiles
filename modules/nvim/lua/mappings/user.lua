local safe_require = require("utils").safe_require

local M = {}

local tfm = safe_require("tfm")
local telescope_builtin = safe_require("telescope.builtin")
local dap = safe_require("dap")
local neotest = safe_require("neotest")

M.setup = function(wk)
	wk.add({
		{
			"<leader>e",
			tfm and tfm.open,
			desc = "Open TFM",
		},
		{
			"<leader>q",
			"<CMD>q<CR>",
			desc = "Quit",
		},
		{
			"<leader>w",
			"<CMD>w<CR>",
			desc = "Save",
		},
		{
			"<leader>f",
			nil,
			name = "Telescope",
		},
		{
			"<leader>ff",
			telescope_builtin and telescope_builtin.find_files,
			desc = "Find File",
		},
		{
			"<leader>fg",
			telescope_builtin and telescope_builtin.live_grep,
			desc = "Grep",
		},
		{
			"<leader>fb",
			telescope_builtin and telescope_builtin.buffers,
			desc = "Buffers",
		},
		{
			"<leader>fh",
			telescope_builtin and telescope_builtin.help_tags,
			desc = "Help",
		},
		{
			"<leader>fc",
			telescope_builtin and telescope_builtin.colorscheme,
			desc = "Colorscheme",
		},
		{
			"<leader>d",
			nil,
			name = "Debugger",
		},
		{
			"<leader>dt",
			dap and dap.toggle_breakpoint,
			desc = "Toggle breakpoint",
		},
		{
			"<leader>db",
			dap and dap.toggle_repl,
			desc = "Toggle repl",
		},
		{
			"<leader>dc",
			dap and dap.continue,
			desc = "Continue",
		},
		{
			"<leader>dn",
			dap and dap.step_over,
			desc = "Step over",
		},
		{
			"<leader>di",
			dap and dap.step_into,
			desc = "Step into",
		},
		{
			"<leader>do",
			dap and dap.step_out,
			desc = "Step out",
		},
		{
			"<leader>t",
			nil,
			name = "Test",
		},
		{
			"<leader>tr",
			neotest and neotest.run.run,
			desc = "Run",
		},
		{
			"<leader>td",
			neotest and function()
				neotest.run.run({ strategy = "dap" })
			end,
			desc = "Run in debug mode",
		},
		{
			"<leader>ts",
			neotest and neotest.run.stop,
			desc = "Stop",
		},
		{
			"<leader>ta",
			neotest and neotest.run.attach,
			desc = "Attach",
		},
		{
			"<leader>lg",
			"<CMD>LazyGit<CR>",
			desc = "Open LazyGit",
		},
		{
			"<C-h>",
			"<CMD>wincmd h<CR>",
		},
		{
			"<C-j>",
			"<CMD>wincmd j<CR>",
		},
		{
			"<C-k>",
			"<CMD>wincmd k<CR>",
		},
		{
			"<C-l>",
			"<CMD>wincmd l<CR>",
		},
		{
			"<A-h>",
			"<CMD>BufferPrevious<CR>",
			desc = "Go to previous buffer",
		},
		{
			"<A-l>",
			"<CMD>BufferNext<CR>",
			desc = "Go to next buffer",
		},
		{
			"<A-S-H>",
			"<CMD>BufferMovePrevious<CR>",
			desc = "Move buffer to previous position",
		},
		{
			"<A-S-L>",
			"<CMD>BufferMoveNext<CR>",
			desc = "Move buffer to next position",
		},
		{
			"<A-[>",
			"<CMD>BufferFirst<CR>",
			desc = "Go to first buffer",
		},
		{
			"<A-]>",
			"<CMD>BufferLast<CR>",
			desc = "Go to last buffer",
		},
		{
			"<A-q>",
			"<CMD>BufferClose<CR>",
			desc = "Close buffer",
		},
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

			local opts = { buffer = ev.buf }
			local prefixedOpts = { prefix = "<leader>" }
			vim.tbl_deep_extend("force", prefixedOpts, opts)

			wk.add({
				{ "g", name = "Go" },
				{ "gd", vim.lsp.buf.definition, desc = "Go to definition" },
				{ "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
				{ "gr", vim.lsp.buf.references, desc = "Go to references" },
				{ "K", vim.lsp.buf.hover, desc = "Show hover" },
				{ "<C-S-k>", vim.lsp.buf.signature_help, desc = "Show signature help" },
			}, opts)

			wk.add({
				{ "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
				{ "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
				{
					"<leader>wl",
					function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end,
					desc = "List workspace folders",
				},
				{ "<leader>D", vim.lsp.buf.type_definition, desc = "Type definition" },
				{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
				{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
				{
					"<leader>F",
					function()
						vim.lsp.buf.format({ async = true })
					end,
					desc = "Format",
				},
			}, prefixedOpts)
		end,
	})
end

return M
