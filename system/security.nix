{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  programs.dconf.enable = true;

  networking.firewall.enable = false;
  networking.nftables.enable = false;

  users.users.kurisu.extraGroups = [ "adbusers" ];
}
