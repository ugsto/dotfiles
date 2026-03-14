{
  keymaps = [
    {
      action = "<cmd>w<cr>";
      key = "<C-s>";
    }
    {
      action = "<cmd>q<cr>";
      key = "<C-q>";
    }
    {
      action = "<cmd>bnext<cr>";
      key = "<tab>";
    }
    {
      action = "<cmd>bprevious<cr>";
      key = "<S-tab>";
    }
    {
      action = "<cmd>bdelete<cr>";
      key = "<leader>bd";
    }
    # Clear search with <esc>
    {
      mode = "n";
      key = "<esc>";
      action = "<cmd>noh<cr>";
    }
    # Better indenting
    {
      mode = "v";
      key = "<";
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
    }
    # Move to windows using <ctrl> hjkl
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
    }
  ];
}
