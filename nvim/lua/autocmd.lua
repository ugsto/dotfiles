local function setup()
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		pattern = { "*" },
		callback = function()
			vim.lsp.buf.format({ timeout = 1000 })
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { "*.j2" },
		callback = function()
			vim.bo.filetype = "jinja2"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { ".dockerignore" },
		callback = function()
			vim.bo.filetype = "dockerignore"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { ".gitignore" },
		callback = function()
			vim.bo.filetype = "gitignore"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { "hosts" },
		callback = function()
			vim.bo.filetype = "hosts"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { "*.conf" },
		callback = function()
			vim.bo.filetype = "conf"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { "*.ne" },
		callback = function()
			vim.bo.filetype = "nearley"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
		callback = function()
			vim.opt.shiftwidth = 2
			vim.opt.tabstop = 2
			vim.opt.softtabstop = 2
		end,
	})
end

local function main()
	setup()
end

main()
