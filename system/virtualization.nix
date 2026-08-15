{
  username,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vagrant
  ];

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = false;
        setSocketVariable = true;
      };
    };
    virtualbox.host.enable = true;
    libvirtd.enable = true;
  };

  users.users.${username}.extraGroups = [
    "docker"
    "libvirtd"
  ];

  users.extraGroups.vboxusers.members = [ username ];

  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
}
