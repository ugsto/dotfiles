{
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
    ./modules/ollama.nix
    ./modules/wireguard.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.printing.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "24.11";
}
