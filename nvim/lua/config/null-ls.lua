local M = {}

local function get_sources(builtins)
    local formatting = builtins.formatting
    local diagnostics = builtins.diagnostics

    return {
        formatting.stylua,
        formatting.rustfmt,
        formatting.prettier,
        diagnostics.flake8,
        diagnostics.pylama,
        formatting.black,
        formatting.isort,
        formatting.yapf,
        diagnostics.vulture,
        formatting.sql_formatter,
        formatting.sqlfluff,
    }
end

M = {
    get_sources = get_sources,
}

return M
