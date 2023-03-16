local on_attach = {
    {"n", "gD", vim.lsp.buf.declaration},
    {"n", "gd", vim.lsp.buf.definition},
    {"n", "K", vim.lsp.buf.hover},
    {"n", "gi", vim.lsp.buf.implementation},
    {"n", "<C-k>", vim.lsp.buf.signature_help},
    {"n", "<space>wa", vim.lsp.buf.add_workspace_folder},
    {"n", "<space>wr", vim.lsp.buf.remove_workspace_folder},
    {
        "n",
        "<space>wl",
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end
    },
    {"n", "<space>D", vim.lsp.buf.type_definition},
    {"n", "<space>rn", vim.lsp.buf.rename},
    {"n", "<space>ca", vim.lsp.buf.code_action},
    {"n", "gr", vim.lsp.buf.references},
    {
        "n",
        "<space>f",
        function()
            vim.lsp.buf.format {async = true}
        end
    }
}

return on_attach
