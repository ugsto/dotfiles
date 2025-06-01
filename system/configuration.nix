{
  config,
  pkgs,
  username,
  name,
  ...
}:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./desktop.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./security.nix
    ./virtualization.nix
    ./modules/mininet.nix
    ./modules/wireguard.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.printing.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [
      "wheel"
      "input"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    config.boot.kernelPackages.perf
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';
  system.stateVersion = "24.11";
}
