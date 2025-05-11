{
  opts = {
    number = true;
    relativenumber = true;

    expandtab = true;
    softtabstop = 2;
    shiftwidth = 2;
    tabstop = 2;

    termguicolors = true;
    completeopt = [
      "menuone"
      "noselect"
      "noinsert"
    ];
    signcolumn = "yes";

    ignorecase = true;
    smartcase = true;

    splitright = true;
    splitbelow = true;

    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    encoding = "utf-8";
    fileencoding = "utf-8";

    undofile = true;
    swapfile = true;
    backup = false;
    autoread = true;

    ruler = true;
    gdefault = true;
    scrolloff = 5;
  };

  clipboard = {
    providers = {
      wl-copy.enable = true;
      xsel.enable = true;
    };
    register = "unnamedplus";
  };

  globals.mapleader = " ";
}
