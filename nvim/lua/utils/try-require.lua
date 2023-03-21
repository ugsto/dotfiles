-- @param module_name: string - the name of the module to load
-- @return any - the loaded module implementation, or nil if the module could not be loaded
local function require(module_name)
    local success, module_impl = pcall(require, module_name)

    if not success then
        local answear
        repeat
            io.stderr:write("could not load " .. module_name)
            io.stderr:flush()
            answear=vim.fn.input("cancel? (y/n) ")
        until answear == "y" or answear == "n"
        if answear == "y" then
            return nil
        end
        return true
    end

    return module_impl
end

return require
