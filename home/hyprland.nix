{
  pkgs,
  ...
}:
let
  browser = "${pkgs.librewolf}/bin/librewolf";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  menu = "${pkgs.wofi}/bin/wofi --show run";
  print = "${pkgs.grimblast}/bin/grimblast";
  mail = "${pkgs.thunderbird}/bin/thunderbird";
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
          "$mod, P, exec, ${print}"

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
        "[workspace 2 silent] ${browser}"
        "[workspace 9 silent] ${mail}"
      ];
    };
  };
}
