{
  pkgs,
  lib,
  config,
  theme,
  ...
}:
let
  browser = "${pkgs.librewolf}/bin/librewolf";
  terminal = "${config.programs.alacritty.package}/bin/alacritty";
  menu = "${pkgs.wofi}/bin/wofi --show drun,run --insensitive --allow-images";
  print = "${pkgs.grimblast}/bin/grimblast save area \"$HOME/Imagens/Capturas de tela/Captura de tela de $(date '+%Y-%m-%d %H-%M-%S').png\"";
  increase-backlight = "${pkgs.light}/bin/light -A 5";
  decrease-backlight = "${pkgs.light}/bin/light -U 5";

  idle-script = pkgs.writeShellScript "sway-idle" ''
    #!/usr/bin/env bash

    light -O
    light -S 10

    sleep 10

    if grep -q 1 /sys/class/power_supply/AC/online; then
        swaymsg "output * power off"
    else
        systemctl suspend
    fi
  '';

  modifier = "Mod4";
in
{
  catppuccin.sway.enable = false;
  catppuccin.swaylock.enable = false;
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = {
      modifier = modifier;
      terminal = terminal;
      menu = menu;

      input = {
        "*" = {
          xkb_layout = "br";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };

      output = {
        "eDP-1" = {
          mode = "1920x1080@60.010Hz";
          pos = "1366 0";
          bg = "${./wallpapers/columbina-hand.png} fill";
        };
        "HDMI-A-1" = {
          mode = "1366x768@60Hz";
          pos = "0 0";
          bg = "${./wallpapers/columbina-moon.png} fill";
        };
      };

      gaps = {
        inner = 5;
        outer = 10;
      };

      window = {
        border = 2;
        titlebar = false;
        commands = [
          {
            command = "floating enable, border none, move position center";
            criteria = {
              title = "^Tab Selection$";
            };
          }
        ];
      };

      keybindings =
        lib.mkOptionDefault {
          "${modifier}+Shift+f" = "exec ${browser}";
          "${modifier}+Shift+Return" = "exec ${terminal}";
          "${modifier}+r" = "exec ${menu}";
          "${modifier}+q" = "kill";
          "${modifier}+m" = "exit";
          "${modifier}+v" = "floating toggle";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+p" = "move right";
          "${modifier}+g" = "exec swaylock";
          "Print" = "exec ${print}";
        }
        // (builtins.listToAttrs (
          builtins.genList (
            i:
            let
              ws = toString (i + 1);
            in
            {
              name = "${modifier}+${ws}";
              value = "workspace number \"  ${ws}  \"";
            }
          ) 9
        ))
        // (builtins.listToAttrs (
          builtins.genList (
            i:
            let
              ws = toString (i + 1);
            in
            {
              name = "${modifier}+Shift+${ws}";
              value = "move container to workspace number \"  ${ws}  \"";
            }
          ) 9
        ));

      bars = [
        {
          fonts = {
            names = [ "NotoSans Nerd Font" ];
            size = 12.0;
          };
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-main.toml";
          extraConfig = ''
            height 24
            workspace_buttons yes
            strip_workspace_numbers yes
          '';
          colors = {
            background = theme.colors.base;
            statusline = theme.colors.text;
            separator = theme.colors.surface0;
            focusedWorkspace = {
              border = theme.colors.blue;
              background = theme.colors.blue;
              text = theme.colors.crust;
            };
            activeWorkspace = {
              border = theme.colors.surface1;
              background = theme.colors.surface1;
              text = theme.colors.text;
            };
            inactiveWorkspace = {
              border = theme.colors.base;
              background = theme.colors.base;
              text = theme.colors.overlay0;
            };
            urgentWorkspace = {
              border = theme.colors.red;
              background = theme.colors.red;
              text = theme.colors.crust;
            };
            bindingMode = {
              border = theme.colors.lavender;
              background = theme.colors.lavender;
              text = theme.colors.crust;
            };
          };
        }
      ];
    };

    extraConfig = ''
      bindsym XF86MonBrightnessUp exec ${increase-backlight}
      bindsym XF86MonBrightnessDown exec ${decrease-backlight}
    '';
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = theme.colors.base;
      text-color = theme.colors.text;
      border-color = theme.colors.blue;
      border-radius = 10;
      border-size = 2;
      default-timeout = 5000;
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      main = {
        blocks = [
          {
            block = "cpu";
            format = " $icon  $utilization.eng(w:2) ";
            theme_overrides = {
              idle_bg = theme.colors.blue;
              idle_fg = theme.colors.crust;
            };
          }
          {
            block = "memory";
            format = " $icon  $mem_used_percents.eng(w:2) ";
            theme_overrides = {
              idle_bg = theme.colors.teal;
              idle_fg = theme.colors.crust;
            };
          }
          {
            block = "net";
            device = "enp2s0";
            format = " $icon  eth ";
            missing_format = "";
            theme_overrides = {
              idle_bg = theme.colors.green;
              idle_fg = theme.colors.crust;
            };
          }
          {
            block = "net";
            device = "wlp3s0";
            format = " $icon  $ssid $signal_strength ";
            missing_format = "";
            theme_overrides = {
              idle_bg = theme.colors.yellow;
              idle_fg = theme.colors.crust;
            };
          }
          {
            block = "battery";
            format = " $icon ";
            theme_overrides = {
              idle_bg = theme.colors.peach;
              idle_fg = theme.colors.crust;
            };
          }
          {
            block = "time";
            format = " $icon  $timestamp.datetime(f:'%a %d/%m %R') ";
            theme_overrides = {
              idle_bg = theme.colors.mauve;
              idle_fg = theme.colors.crust;
            };
          }
        ];
        settings = {
          theme = {
            theme = "ctp-mocha";
            overrides = {
              separator = "";
            };
          };
          icons = {
            icons = "material-nf";
          };
        };
      };
    };
  };

  services.swayidle = {
    enable = true;
    extraArgs = [ "idlehaskinhibitor" ];
    timeouts = [
      {
        timeout = 300;
        command = "${idle-script}";
        resumeCommand = "light -I && swaymsg \"output * power on\"";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      color = theme.colors.base;
      ring-color = theme.colors.surface2;
      line-color = theme.colors.surface0;
      inside-color = theme.colors.base;
      key-hl-color = theme.colors.blue;
      separator-color = theme.colors.surface0;

      font-size = 2;
      indicator-idle-visible = true;
      indicator-radius = 100;
    };
  };

  home.packages = with pkgs; [
    swaylock-effects
    swayidle
    mako
    wl-clip-persist
    nerd-fonts.noto
  ];
}
