local M = {}

local adapters = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
}

local configurations = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            return vim.fn.exepath("python")
        end,
    },
}

M = {
    adapters = adapters,
    configurations = configurations,
}

return M
