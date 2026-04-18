{ username, hostname, ... }:
let
  loginServer = "netbird.bortoli.phd";
in
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
  systemd.services."netbird-wt0-custom-up" = {
    description = "Custom auto-login for Netbird wt0";
    wantedBy = [ "multi-user.target" ];
    requires = [ "netbird-wt0.service" ];
    after = [ "netbird-wt0.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      sleep 3
      export NB_MANAGEMENT_URL="${loginServer}"
      export NB_SETUP_KEY="$(< /var/lib/netbird-wt0.key)"
      /run/current-system/sw/bin/netbird-wt0 up
    '';
  };
}
