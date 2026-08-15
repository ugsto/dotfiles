{
  config,
  lib,
  username,
  hostname,
  netbirdClients ? [ ],
  ...
}:
let
  mkUpService =
    client:
    let
      netbirdUnit = "netbird-${client.name}";
      managementUrlFile = config.sops.secrets.${client.managementUrlSecret}.path;
    in
    lib.nameValuePair "${netbirdUnit}-up" {
      description = "Bring up NetBird client ${client.name}";
      wantedBy = [ "multi-user.target" ];

      requires = [
        "${netbirdUnit}.service"
        "sops-install-secrets.service"
      ];

      after = [
        "${netbirdUnit}.service"
        "sops-install-secrets.service"
      ];

      unitConfig.StartLimitIntervalSec = 0;

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "2s";
        TimeoutStartSec = "2min";
      };

      script = ''
        set -euo pipefail

        export NB_MANAGEMENT_URL="$(
          < ${lib.escapeShellArg managementUrlFile}
        )"

        ${lib.optionalString (client ? setupKeyFile) ''
          export NB_SETUP_KEY="$(
            < ${lib.escapeShellArg client.setupKeyFile}
          )"
        ''}

        exec /run/current-system/sw/bin/netbird-${client.name} up
      '';
    };
in
{
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    defaultSopsFile = ../secrets/secret.yaml;

    secrets = lib.genAttrs (map (client: client.managementUrlSecret) netbirdClients) (_: { });
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/sops-nix 0700 root root -"
  ];

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  users.users.${username}.extraGroups = [
    "networkmanager"
  ];

  services = {
    resolved.enable = true;

    netbird = {
      ui.enable = false;

      clients = lib.listToAttrs (
        map (client: lib.nameValuePair client.name client.settings) netbirdClients
      );
    };
  };

  systemd.services = lib.listToAttrs (map mkUpService netbirdClients);
}
