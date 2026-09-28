{
  pkgs,
  lib,
  config,
  ...
}:
let
  browser = "${pkgs.librewolf}/bin/librewolf";
  terminal = "${config.programs.alacritty.package}/bin/alacritty";
  noctalia = "${config.programs.noctalia.package}/bin/noctalia msg";
  menu = "${noctalia} panel-toggle launcher";
  clipboard = "${noctalia} panel-toggle clipboard";
  print = "${noctalia} screenshot-region";

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
          "${modifier}+m" = "exec ${noctalia} panel-toggle control-center";
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
          "${modifier}+g" = "exec ${noctalia} session lock";
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
      bindsym --locked XF86MonBrightnessUp exec ${noctalia} brightness-up
      bindsym --locked XF86MonBrightnessDown exec ${noctalia} brightness-down
      bindsym --locked XF86AudioRaiseVolume exec ${noctalia} volume-up
      bindsym --locked XF86AudioLowerVolume exec ${noctalia} volume-down
      bindsym --locked XF86AudioMute exec ${noctalia} volume-mute
    '';
  };

  home.packages = with pkgs; [
    nerd-fonts.noto
    wl-clipboard
    thunar
  ];
}
