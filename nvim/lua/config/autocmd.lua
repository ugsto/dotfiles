local config = {
	{
		{
			"BufWritePre",
		},
		{
			"*",
		},
		"lua vim.lsp.buf.format({ timeout_ms = 5000 })",
	},
	{
		{
			"BufRead",
		},
		{
			"*.ts",
			"*.tsx",
			"*.js",
			"*.jsx",
		},
		"setlocal expandtab",
	},
}

return config
