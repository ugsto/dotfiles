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
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [ "amdgpu" ];
  };

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
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d --max-kept-generations 5";
    };
  };

  services = {
    openssh.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = false;
    system76-scheduler.settings.cfsProfiles.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 1;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 81;
      };
    };
  };

  powerManagement.powertop.enable = true;

  zramSwap.enable = true;

  system.stateVersion = "26.05";
}
