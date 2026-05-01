{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "top";
        showCapsule = true;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              useMonospacedFont = true;
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Network";
            }
            {
              id = "Battery";
            }
            {
              id = "Tray";
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Catppuccin Mocha";
      general = {
        radiusRatio = 0.5;
        fontSize = 0.8;
      };
      location = {
        weatherEnabled = false;
        autoLocate = false;
      };
      idle = {
        enabled = true;
        screenOffTimeout = 600;
        fadeDuration = 5;
        screenOffCommand = "swaymsg \"output * power off\"";
        resumeScreenOffCommand = "swaymsg \"output * power on\"";
        customCommands = "[]";
      };
      dock.enabled = false;
      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "WallpaperSelector";
            }
            {
              id = "NoctaliaPerformance";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "brightness-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
          {
            enabled = false;
            id = "media-sysmon-card";
          }
        ];
      };
    };
  };
}
