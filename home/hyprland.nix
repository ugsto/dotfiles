{
  pkgs,
  pkgs-unstable,
  ...
}:
let
  browser = "${pkgs.librewolf}/bin/librewolf";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  menu = "${pkgs.wofi}/bin/wofi --show run";
  print = "${pkgs.grimblast}/bin/grimblast save area \"$HOME/Imagens/Capturas de tela/Captura de tela de $(date '+%Y-%m-%d %H-%M-%S').png\"";
  mail = "${pkgs.thunderbird}/bin/thunderbird";
  increase-backlight = "${pkgs.light}/bin/light -A 5";
  decrease-backlight = "${pkgs.light}/bin/light -U 5";
  password-manager = "${pkgs-unstable.keepassxc}/bin/keepassxc";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          # Launch apps
          "$mod, F, exec, ${browser}"
          "$mod SHIFT, Return, exec, ${terminal}"
          "$mod, R, exec, ${menu}"

          # Window control
          "$mod, Q, killactive"
          "$mod, M, exit"
          "$mod, V, togglefloating"

          # Focus windows with HJKL
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          # Move windows with SHIFT + HJKL
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"

          # Print
          ", Print, exec, ${print}"

          # Backlight control
          ", code:233, exec, ${increase-backlight}"
          ", code:234, exec, ${decrease-backlight}"
          ", code:232, exec, ${decrease-backlight}"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      decoration = {
        rounding = 10;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
      };

      input = {
        kb_layout = "br";
        touchpad = {
          natural_scroll = true;
        };
      };

      monitor = [
        "eDP-1, 1920x1080@60.01Hz, 0x0, 1"
        "HDMI-A-1, 1920x1080@60.00000, 1920x0, 1"
      ];

      exec-once = [
        "[workspace 2 silent] ${terminal}"
        "[workspace 4 silent] ${mail}"
        "[workspace 9 silent] ${password-manager}"
        "waybar &"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [
          "custom/launcher"
          "clock"
        ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "battery"
        ];
        "custom/launcher" = {
          format = " ";
          on-click = "wofi --show run";
          on-click-right = "pkill wofi";
        };
        clock = {
          format = "󰃭 {:%Y/%m/%d 󰥔 %H:%M}";
        };
        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name} {icon}";
          format-icons = {
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = "󰇮 ";
            "9" = "󰌾 ";
            default = " ";
          };
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
            ];
          };
          icon = true;
        };
        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 10px;
        font-family: "JetbrainsMono Nerd Font";
        font-size: 15px;
        min-height: 10px;
      }

      window#waybar {
        background: transparent;
      }

      #window {
        margin-top: 6px;
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 10px;
        color: transparent;
        background: transparent;
      }

      #custom-launcher {
        font-size: 22px;
        margin-top: 6px;
        margin-left: 24px;
        padding-left: 10px;
        padding-right: 5px;
        border-radius: 10px;
        color: #89dceb;
        background: #161320;
      }

      #clock {
        margin-top: 6px;
        margin-left: 8px;
        padding: 0px 12px;
        border-radius: 10px;
        background: #161320;
        color: #b5e8e0;
      }

      #workspaces {
        border-radius: 10px;
        background: #161320;
      }

      #workspaces button {
        color: #b5e8e0;
        background: transparent;
        font-size: 16px;
        border-radius: 2px;
      }

      #workspaces button.empty {
        color: #f28fad;
        background: transparent;
      }

      #workspaces button.active {
        color: #abe9b3;
        border-top: 2px solid #abe9b3;
        border-bottom: 2px solid #abe9b3;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #fae3b0;
        border-color: #e8a2af;
        color: #e8a2af;
      }

      #workspaces button.focused:hover {
        color: #e8a2af;
      }

      #battery {
        margin-top: 6px;
        margin-right: 24px;
        padding: 0px 18px 0px 12px;
        border-radius: 10px;
        background: #161320;
        color: #b5e8e0;
      }
    '';
  };
}
