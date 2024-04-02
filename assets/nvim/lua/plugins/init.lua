local function bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local function load_plugin_manifest()
  return require("plugins.plugin_manifest")
end

local function initialize(plugin_manifest)
  require("lazy").setup(plugin_manifest)
end

bootstrap()
initialize(load_plugin_manifest())
