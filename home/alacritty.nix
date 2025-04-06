{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "#24273a";
          foreground = "#cad3f5";
          dim_foreground = "#8087a2";
          bright_foreground = "#cad3f5";
        };
        cursor = {
          text = "#24273a";
          cursor = "#f4dbd6";
        };
        vi_mode_cursor = {
          text = "#24273a";
          cursor = "#b7bdf8";
        };
        search = {
          matches = {
            foreground = "#24273a";
            background = "#a5adcb";
          };
          focused_match = {
            foreground = "#24273a";
            background = "#a6da95";
          };
        };
        footer_bar = {
          foreground = "#24273a";
          background = "#a5adcb";
        };
        hints = {
          start = {
            foreground = "#24273a";
            background = "#eed49f";
          };
          end = {
            foreground = "#24273a";
            background = "#a5adcb";
          };
        };
        selection = {
          text = "#24273a";
          background = "#f4dbd6";
        };
        normal = {
          black = "#494d64";
          red = "#ed8796";
          green = "#a6da95";
          yellow = "#eed49f";
          blue = "#8aadf4";
          magenta = "#f5bde6";
          cyan = "#8bd5ca";
          white = "#b8c0e0";
        };
        bright = {
          black = "#5b6078";
          red = "#ed8796";
          green = "#a6da95";
          yellow = "#eed49f";
          blue = "#8aadf4";
          magenta = "#f5bde6";
          cyan = "#8bd5ca";
          white = "#a5adcb";
        };
        dim = {
          black = "#494d64";
          red = "#ed8796";
          green = "#a6da95";
          yellow = "#eed49f";
          blue = "#8aadf4";
          magenta = "#f5bde6";
          cyan = "#8bd5ca";
          white = "#b8c0e0";
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
