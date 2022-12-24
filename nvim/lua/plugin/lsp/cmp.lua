local status_ok, cmp = pcall(require, 'cmp')
if not status_ok then
  return
end

local snippet = {
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body)
  end
}

local mapping = require('keymap').lsp_cmp

local sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' },
  { name = 'cmp-clippy',
    option = {
      model = "EleutherAI/gpt-neo-2.7B",
      key = "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"
    }
  }
})

cmp.setup {
  snippet = snippet,
  mapping = mapping,
  sources = sources
}
