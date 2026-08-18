{
  pkgs,
  lib,
  config,
  ...
}:
let
  browser = "${pkgs.librewolf}/bin/librewolf";
  terminal = "${config.programs.alacritty.package}/bin/alacritty";
  menu = "${pkgs.wofi}/bin/wofi --show drun --insensitive --allow-images --no-actions";
  clipboard = "${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi --dmenu --prompt Clipboard | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
  print = "${pkgs.wayfreeze}/bin/wayfreeze --after-freeze-cmd '${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy; pkill wayfreeze'";
  increase-backlight = "${pkgs.brightnessctl}/bin/brightnessctl set +5%";
  decrease-backlight = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

  modifier = "Mod4";
in
{
  imports = [
    ./noctalia.nix
  ];

  catppuccin.sway.enable = false;
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = true;
    config = {
      inherit modifier;
      inherit terminal;
      inherit menu;

      input = {
        "*" = {
          xkb_layout = "br";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
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
          "${modifier}+c" = "exec ${clipboard}";
          "${modifier}+q" = "kill";
          "${modifier}+m" =
            "exec ${config.programs.noctalia.package}/bin/noctalia msg panel-toggle control-center";
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

      startup = [ ];

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
    thunar
  ];
}
