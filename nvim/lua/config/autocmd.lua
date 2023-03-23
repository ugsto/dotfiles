local config = {
    {
        {
            "BufWritePre",
        },
        {
            "*",
        },
        "lua vim.lsp.buf.format({async = true})",
    },
}

return config
