{ pkgs, username, ... }:
{
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    pam = {
      u2f.settings = {
        authfile = "/etc/u2f_mappings";
        origin = "pam://kurisu";
        appid = "pam://kurisu";
        cue = true;
        nouserok = true;
      };
      services.greetd.u2f = {
        enable = true;
        control = "required";
      };
    };
  };

  programs.dconf.enable = true;

  environment.systemPackages = [
    pkgs.pam_u2f
    pkgs.libfido2
  ];

  environment.etc."u2f_mappings" = {
    source = ./u2f-mappings;
    mode = "0444";
  };

  networking.firewall = {
    enable = false;
    allowPing = false;
    logRefusedConnections = true;
    logRefusedPackets = true;
  };
  networking.nftables.enable = false;

  users.users.${username}.extraGroups = [ "adbusers" ];

  services.openssh.enable = false;
}
