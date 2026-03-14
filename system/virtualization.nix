{
  username,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vagrant
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
      setSocketVariable = true;
    };
  };
  users.users.${username}.extraGroups = [
    "docker"
    "libvirtd"
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  services.nfs.server.enable = true;
  users.extraGroups.vboxusers.members = [ username ];

  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
}
