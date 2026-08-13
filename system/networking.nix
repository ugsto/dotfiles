{
  config,
  username,
  hostname,
  ...
}:
let
  wt0ManagementUrl = config.sops.secrets.netbird_wt0_management_url.path;
  wt1ManagementUrl = config.sops.secrets.netbird_wt1_management_url.path;
in
{
  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secret.yaml;

    secrets = {
      netbird_wt0_management_url = { };
      netbird_wt1_management_url = { };
    };
  };

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
      export NB_MANAGEMENT_URL="$(< ${wt0ManagementUrl})"
      export NB_SETUP_KEY="$(< /var/lib/netbird-wt0.key)"
      /run/current-system/sw/bin/netbird-wt0 up
    '';
  };

  services.netbird.clients.wt1 = {
    autoStart = true;
    port = 51822;
    ui.enable = false;
    openFirewall = true;
    openInternalFirewall = true;
  };
  systemd.services."netbird-wt1-custom-up" = {
    description = "Custom auto-login for Netbird wt1";
    wantedBy = [ "multi-user.target" ];
    requires = [ "netbird-wt1.service" ];
    after = [ "netbird-wt1.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      sleep 3
      export NB_MANAGEMENT_URL="$(< ${wt1ManagementUrl})"
      /run/current-system/sw/bin/netbird-wt1 up
    '';
  };
}
