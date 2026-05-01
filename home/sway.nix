{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  browser = "${pkgs.librewolf}/bin/librewolf";
  terminal = "${config.programs.alacritty.package}/bin/alacritty";
  menu = "${pkgs.wofi}/bin/wofi --show run --insensitive --allow-images";
  print = "${pkgs.wayfreeze}/bin/wayfreeze --after-freeze-cmd '${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy; pkill wayfreeze'";
  increase-backlight = "${pkgs.light}/bin/light -A 5";
  decrease-backlight = "${pkgs.light}/bin/light -U 5";

  modifier = "Mod4";
in
{
  imports = [
    ./noctalia.nix
  ];

  catppuccin.sway.enable = false;
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
        };
        "HDMI-A-1" = {
          mode = "1366x768@60Hz";
          pos = "0 0";
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

      startup = [
        {
          command = "${
            inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
          }/bin/noctalia-shell";
          always = true;
        }
      ];

      bars = [ ];
    };

    extraConfig = ''
      bindsym XF86MonBrightnessUp exec ${increase-backlight}
      bindsym XF86MonBrightnessDown exec ${decrease-backlight}
    '';
  };

  home.packages = with pkgs; [
    wl-clip-persist
    nerd-fonts.noto
    wayfreeze
    grim
    slurp
    wl-clipboard
    xfce.thunar
  ];
}
