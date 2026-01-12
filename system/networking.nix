{ username, hostname, ... }:
{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  users.users.${username}.extraGroups = [ "networkmanager" ];
}
