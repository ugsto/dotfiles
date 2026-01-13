{ theme, ... }:
{
  catppuccin.alacritty.enable = false;
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = theme.colors.base;
          foreground = theme.colors.text;
          dim_foreground = theme.colors.subtext1;
          bright_foreground = theme.colors.text;
        };
        cursor = {
          text = theme.colors.base;
          cursor = theme.colors.rosewater;
        };
        vi_mode_cursor = {
          text = theme.colors.base;
          cursor = theme.colors.lavender;
        };
        search = {
          matches = {
            foreground = theme.colors.base;
            background = theme.colors.subtext0;
          };
          focused_match = {
            foreground = theme.colors.base;
            background = theme.colors.green;
          };
        };
        footer_bar = {
          foreground = theme.colors.base;
          background = theme.colors.subtext0;
        };
        hints = {
          start = {
            foreground = theme.colors.base;
            background = theme.colors.yellow;
          };
          end = {
            foreground = theme.colors.base;
            background = theme.colors.subtext0;
          };
        };
        selection = {
          text = theme.colors.base;
          background = theme.colors.rosewater;
        };
        normal = {
          black = theme.colors.surface1;
          red = theme.colors.red;
          green = theme.colors.green;
          yellow = theme.colors.yellow;
          blue = theme.colors.blue;
          magenta = theme.colors.pink;
          cyan = theme.colors.teal;
          white = theme.colors.subtext1;
        };
        bright = {
          black = theme.colors.surface2;
          red = theme.colors.red;
          green = theme.colors.green;
          yellow = theme.colors.yellow;
          blue = theme.colors.blue;
          magenta = theme.colors.pink;
          cyan = theme.colors.teal;
          white = theme.colors.subtext0;
        };
        dim = {
          black = theme.colors.surface1;
          red = theme.colors.red;
          green = theme.colors.green;
          yellow = theme.colors.yellow;
          blue = theme.colors.blue;
          magenta = theme.colors.pink;
          cyan = theme.colors.teal;
          white = theme.colors.subtext1;
        };
      };
      env = {
        TERM = "xterm-256color";
      };
      font = {
        size = 12;
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "regular";
        };
      };
      scrolling = {
        history = 0;
      };
      window = {
        padding = {
          x = 8;
          y = 8;
        };
      };
    };
  };
}
