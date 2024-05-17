local wk = require("which-key")

vim.g.mapleader = " "

wk.register({
  e = {
    function()
      require("tfm").open()
    end,
    "Open TFM",
  },
}, { prefix = "<leader>" })

wk.register({
  q = { "<CMD>q<CR>", "Quit" },
  w = { "<CMD>w<CR>", "Save" },
}, { prefix = "<leader>" })

wk.register({
  f = {
    name = "File",
    f = { "<CMD>Telescope find_files<CR>", "Find File" },
    g = { "<CMD>Telescope live_grep<CR>", "Grep" },
    b = { "<CMD>Telescope buffers<CR>", "Buffers" },
    h = { "<CMD>Telescope help_tags<CR>", "Help" },
  },
}, { prefix = "<leader>" })

wk.register({
  lg = { "<CMD>LazyGit<CR>", "Open LazyGit" },
}, { prefix = "<leader>" })

wk.register({
  ["[d"] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
  ["]d"] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
})

wk.register({
  ["<A-.>"] = { "<CMD>BufferNext<CR>", "Go to next buffer" },
  ["<A-,>"] = { "<CMD>BufferPrevious<CR>", "Go to previous buffer" },

  ["<A-<>"] = { "<CMD>BufferMovePrevious<CR>", "Move buffer to previous position" },
  ["<A->>"] = { "<CMD>BufferMoveNext<CR>", "Move buffer to next position" },

  ["<A-[>"] = { "<CMD>BufferFirst<CR>", "Go to first buffer" },
  ["<A-]>"] = { "<CMD>BufferLast<CR>", "Go to last buffer" },

  ["<A-q>"] = { "<CMD>BufferClose<CR>", "Close buffer" },
})
