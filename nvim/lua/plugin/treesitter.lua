require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "lua", "rust", "yaml", "typescript", "python", "hcl", "sql" },

  sync_install = false,
  ignore_install = { "javascript" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
