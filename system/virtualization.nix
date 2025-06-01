{ username, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "Oracle_VirtualBox_Extension_Pack"
    ];

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ username ];
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
