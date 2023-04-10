local function setup()
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		pattern = { "*" },
		callback = function()
			vim.lsp.buf.format({ timeout = 1000 })
		end,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile" }, {
		pattern = { "*.j2" },
		callback = function()
			vim.bo.filetype = "jinja2"
		end,
	})
end

local function main()
	setup()
end

main()
