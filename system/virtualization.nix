{
  username,
  config,
  lib,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
      setSocketVariable = true;
    };
  };
  users.users.${username}.extraGroups = [ "docker" ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ username ];
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
}
