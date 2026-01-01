{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    displaylink
  ];
  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd = {
      kernelModules = [
        "evdi"
      ];
    };
  };
}
