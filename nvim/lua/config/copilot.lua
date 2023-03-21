local function config_filetypes()
    vim.g.copilot_filetypes = {
        ["*"] = false,
        ["javascript"] = true,
        ["typescript"] = true,
        ["lua"] = true,
        ["c"] = true,
        ["c#"] = true,
        ["c++"] = true,
        ["go"] = true,
        ["python"] = true,
        ["ruby"] = true,
        ["rust"] = true,
        ["markdown"] = true,
        ["yaml"] = true,
        ["sh"] = true,
    }
end

return config_filetypes
