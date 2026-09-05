{ pkgs-custom, ... }:
{
  services.udev.packages = [ pkgs-custom.openlogi ];
  hardware.uinput.enable = true;
}
