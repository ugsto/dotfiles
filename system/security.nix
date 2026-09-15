{ pkgs, username, ... }:
{
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          authfile = pkgs.writeText "u2f_keys" ''
            kurisu:TPLAEAnPt3p81XsM/UxM4XG6jwzm9VSP6NwaqHELSbPfa70YIrxzXCgBsosFnR4JRMo1SAUWCnwMJXV5g4bD5A==,+KeDRXLjolTjrxVEYetJ5nTrloBQkfARhn1x/4dFQBPecirdVLLptZLESA+xRir26TkCuepXH/lT1D+sgtCO6A==,es256,+presence
            kurisu:ginc9qZ6kuXwcxD8wJ7fcRJKLtFUff/6iKuhufcl1ZxPW2+cc1OiOF/EaxSOS92NMwZQqcKt9flc+7bHOoRrfw==,jf00sLTWah3ICUKvDaC3fV5mg6A2ikF62OVFTDj15c1p/nLtvjDXOS9vMYLeg05iIleQvMPquGeXrse0e87hsw==,es256,+presence
          '';
        };
      };
      services = {
        greetd.u2fAuth = true;
        sudo.u2fAuth = true;
        login.u2fAuth = true;
        swaylock.u2fAuth = true;
      };
    };
  };

  programs.dconf.enable = true;

  environment.systemPackages = [
    pkgs.pam_u2f
    pkgs.yubikey-personalization
  ];

  networking.firewall = {
    enable = false;
    allowPing = false;
    logRefusedConnections = true;
    logRefusedPackets = true;
  };
  networking.nftables.enable = false;

  users.users.${username}.extraGroups = [ "adbusers" ];

  services.openssh.enable = false;

  security.pki.certificateFiles = [
    ../certs/homelab-root-ca.pem
  ];
}
