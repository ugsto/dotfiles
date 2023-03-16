local config = {
    {
        {
            "BufWritePre",
        },
        {
            "*",
        },
        "lua vim.lsp.buf.format()",
    },
}

return config
