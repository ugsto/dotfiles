{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      shell = {
        ui_scale = 0.8;
        corner_radius_scale = 0.5;
        font_family = "sans-serif";
      };

      theme = {
        palette = "catppuccin-mocha";
      };

      bar.main = {
        enabled = true;
        position = "top";
        start = [ "control-center" ];
        center = [ "workspaces" ];
        end = [
          "clock"
          "bluetooth"
          "network"
          "battery"
          "tray"
        ];
      };

      widget = {
        control-center = {
          type = "control-center";
          icon = "distributor-logo";
        };
        workspaces = {
          type = "workspaces";
          hide_unoccupied = false;
        };
        clock = {
          type = "clock";
          format = "%H:%M";
        };
        bluetooth = {
          type = "bluetooth";
        };
        network = {
          type = "network";
        };
        battery = {
          type = "battery";
        };
        tray = {
          type = "tray";
        };
      };

      location = {
        auto_locate = false;
      };

      weather = {
        enabled = false;
      };

      idle = {
        enabled = true;
        screen_off_timeout = 600;
        fade_duration = 5;
        screen_off_command = "swaymsg \"output * power off\"";
        resume_screen_off_command = "swaymsg \"output * power on\"";
      };

      dock = {
        enabled = false;
      };

      control_center = {
        position = "close_to_bar_button";
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "wallpaper"; }
          { type = "notification"; }
          { type = "power_profile"; }
          { type = "nightlight"; }
        ];
      };

      wallpaper = {
        enabled = true;
        default.path = ./wallpapers/frieren.png;
      };
    };
  };
}
