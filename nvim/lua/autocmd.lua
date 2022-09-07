vim.cmd [[
  autocmd BufWritePre * :lua vim.lsp.buf.format()
  autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
  autocmd BufNewFile,BufRead *.py :set colorcolumn=79
  autocmd BufNewFile,BufRead *.md :set colorcolumn=80
  autocmd BufNewFile,BufRead *.rs :set colorcolumn=99
  autocmd BufEnter *.css :ColorHighlight
]]
