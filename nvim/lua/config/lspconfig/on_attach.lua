local try_require = require("utils.try-require")

local function on_attach(_, bufnr)
    local keymap = try_require("config.keymap.lsp") or os.exit(1)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    for _, argument in ipairs(keymap) do
        local mode, key, callback = table.unpack(argument)
        vim.keymap.set(mode, key, callback, bufopts)
    end
end

return on_attach
