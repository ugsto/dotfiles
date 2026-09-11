{
  config,
  inputs,
  pkgs-custom,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];
  home.packages = [ pkgs-custom.ai-usagebar ];

  sops.templates."ai-usagebar-config.toml".content = ''
    [ui]
    primary = "anthropic"

    [anthropic]
    enabled = true

    [openai]
    enabled = true

    [antigravity]
    enabled = true

    [zai]
    enabled = true
    api_key = "${config.sops.placeholder.zai_api_key}"

    [deepseek]
    enabled = true
    api_key = "${config.sops.placeholder.deepseek_api_key}"

    [minimax]
    enabled = true
    api_key = "${config.sops.placeholder.minimax_api_key}"

    [openrouter]
    enabled = false
  '';

  xdg.configFile."ai-usagebar/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      config.sops.templates."ai-usagebar-config.toml".path;

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
          "ai-usage"
          "clock"
          "bluetooth"
          "network"
          "battery"
          "tray"
        ];
      };

      plugins.enabled = [ "felipeartur/ai-usagebar" ];

      plugin_settings."felipeartur/ai-usagebar" = {
        refresh_minutes = 5;
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
        ai-usage = {
          type = "felipeartur/ai-usagebar:bar";
          vendor = "auto";
          provider_limit = 2;
          visualization = "gauge";
          extras = "countdown";
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
