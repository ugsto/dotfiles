{
  networking.firewall.enable = false;
  security.rtkit.enable = true;

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}
