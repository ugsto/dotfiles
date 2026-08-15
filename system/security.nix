{ username, ... }:
{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  programs.dconf.enable = true;

  networking.firewall = {
    enable = true;
    allowPing = false;
    logRefusedConnections = true;
    logRefusedPackets = true;
  };
  networking.nftables.enable = false;

  users.users.${username}.extraGroups = [ "adbusers" ];

  services.openssh.enable = false;
}
