{ pkgs, ... }:
{
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = -23.5505;
    longitude = -46.6333;
    temperature = {
      day = 6000;
      night = 4000;
    };
    settings = {
      general = {
        adjustment-method = "wayland";
        fade = 1;
      };
    };
    tray = true;
  };

  home.packages = [ pkgs.gammastep ];
}
