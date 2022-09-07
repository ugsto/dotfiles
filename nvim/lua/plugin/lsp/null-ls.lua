local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return
end

local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local hover = null_ls.builtins.hover

null_ls.setup({
  sources = {
    diagnostics.flake8,
    diagnostics.pydocstyle,
    diagnostics.vulture,
    formatting.black.with({
      extra_args = { '--line-length', '79' }
    }),
    formatting.isort,
    diagnostics.markdownlint.with({
      extra_args = { '--disable=MD030', '--disable=MD007' }
    }),
    diagnostics.alex,
    formatting.remark,
    hover.dictionary,
    formatting.rustfmt,
    diagnostics.jsonlint,
    diagnostics.yamllint,
    diagnostics.shellcheck,
    formatting.beautysh,
    formatting.protolint,
    diagnostics.protolint,
  },
})
