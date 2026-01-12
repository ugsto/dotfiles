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
    ./modules/tor.nix
    ./displaylink.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [
      "wheel"
      "input"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    perf
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
    ];
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "kurisu"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d --max-kept-generations 5";
    };
  };
  system.stateVersion = "25.11";
}
