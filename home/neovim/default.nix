{ config, pkgs, ... }:

{
  programs.neovim =
  let
    luaFromStr = str: "lua << EOF\n${str}\nEOF\n";
    luaFromFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # Colorscheme
      {
        plugin = catppuccin-nvim;
        config = luaFromFile ./plugin/catppuccin.lua;
      }

      # Mini
      {
      	plugin = mini-pairs;
	config = luaFromStr "require(\"mini.pairs\").setup()";
      }
      {
      	plugin = mini-statusline;
	config = luaFromStr "require(\"mini.statusline\").setup()";
      }
      {
      	plugin = mini-tabline;
	config = luaFromStr "require(\"mini.tabline\").setup()";
      }

      # Snacks
      {
        plugin = snacks-nvim;
	config = luaFromFile ./plugin/snacks.lua;
      }
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
    '';
  };
}
