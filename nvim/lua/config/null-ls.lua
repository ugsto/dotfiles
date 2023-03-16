local M = {}

local function get_sources(builtins)
    local formatting = builtins.formatting
    local diagnostics = builtins.diagnostics
    local code_actions = builtins.code_actions

    return {
        formatting.stylua,
        formatting.dprint,
        formatting.rustfmt,
        diagnostics.eslint,
        formatting.eslint,
        formatting.prettier,
        code_actions.eslint,
    }
end

M = {
    get_sources = get_sources,
}

return M
