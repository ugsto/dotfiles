{ username, hostname, ... }:
{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  users.users.${username}.extraGroups = [ "networkmanager" ];

  services.netbird.clients.wt0 = {
    autoStart = true;
    port = 51821;
    ui.enable = false;
    openFirewall = true;
    openInternalFirewall = true;
  };
  services.resolved.enable = true;
}
