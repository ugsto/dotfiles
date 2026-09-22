{
  description = "My dotfiles!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nvim = {
      url = "path:pkgs/nvim";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    ai-jail.url = "github:akitaonrails/ai-jail/1a51f003f5d1a9df9970c56fb1f0855dd9125943";
  };

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nur,
      nixgl,
      disko,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      username = "kurisu";
      name = "André Augusto Bortoli";
      hostname = "steins-gate";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "vagrant"
            "drawio"
            "zoom"
            "zoom-us"
            "slack"
            "grayjay"
          ];
        overlays = [
          nur.overlays.default
          nixgl.overlay
        ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "antigravity-cli"
            "claude-code"
            "grayjay"
          ];
        overlays = [
          nur.overlays.default
          nixgl.overlay
          (final: prev: {
            claude-code = prev.claude-code.override {
              manifest = {
                version = "2.1.280";
                platforms.linux-x64 = {
                  binary = "claude.zst";
                  checksum = "27910e2ae704d8f2e8024897d8fdf1e7710807baf4f6982c0e3797c058315384";
                };
              };
            };
          })
        ];
      };
      theme = import ./home/theme.nix;
      # Shared by the NixOS and home-manager sides so a package installed into the
      # user profile and a system module referencing it resolve to one store path.
      pkgs-custom = {
        nvim = inputs.nvim.packages.${system}.default;
        ai-usagebar = pkgs.callPackage ./pkgs/by-name/ai/ai-usagebar/package.nix { };
        betterbird = pkgs.callPackage ./pkgs/by-name/be/betterbird/package.nix { };
        grayjay = pkgs.callPackage ./pkgs/by-name/gr/grayjay/package.nix { };
        vastai = pkgs.callPackage ./pkgs/by-name/va/vastai/package.nix { };
        google-colab-cli = pkgs.callPackage ./pkgs/by-name/go/google-colab-cli/package.nix { };
        mgccli = pkgs.callPackage ./pkgs/by-name/mg/mgccli/package.nix { };
        helium = pkgs.callPackage ./pkgs/by-name/he/helium/package.nix { };
        openlogi = pkgs.callPackage ./pkgs/by-name/op/openlogi/package.nix { };
        deepseek-harness = pkgs.callPackage ./pkgs/by-name/de/deepseek-harness/package.nix { };
        orca = pkgs.callPackage ./pkgs/by-name/or/orca/package.nix { };
      };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      nixosConfigurations =
        let
          mkConfiguration =
            {
              hostName,
              hardwareModule,
              diskModule ? null,
              storageModule ? null,
              videoDrivers ? [ ],
              netbirdClients ? [ ],
            }:
            lib.nixosSystem {
              specialArgs = {
                inherit
                  username
                  name
                  pkgs-custom
                  hardwareModule
                  diskModule
                  storageModule
                  videoDrivers
                  netbirdClients
                  ;
                hostname = hostName;
              };
              modules = [
                inputs.sops-nix.nixosModules.sops
                ./system/configuration.nix
                {
                  nixpkgs.config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (lib.getName pkg) [
                      "vagrant"
                      "drawio"
                      "slack"
                    ];
                }
              ]
              ++ lib.optional (diskModule != null) disko.nixosModules.disko;
            };
        in
        {
          ${hostname} = mkConfiguration {
            hostName = hostname;
            hardwareModule = ./system/hardware-configuration-steins-gate.nix;
            diskModule = ./system/disko-steins-gate.nix;
            storageModule = ./system/storage-btrfs.nix;
            videoDrivers = [ "amdgpu" ];
            netbirdClients = [
              {
                name = "wt0";
                settings = {
                  port = 51821;
                };
                managementUrlSecret = "netbird_wt0_management_url";
                setupKeyFile = "/var/lib/netbird-wt0.key";
              }
            ];
          };
          andrebortoli-workstation = mkConfiguration {
            hostName = "andrebortoli-workstation";
            hardwareModule = ./system/hardware-configuration-andrebortoli-workstation.nix;
            diskModule = ./system/disko-andrebortoli-workstation.nix;
            storageModule = ./system/storage-btrfs.nix;
            videoDrivers = [ "modesetting" ];
            netbirdClients = [
              {
                name = "wt0";
                settings = {
                  port = 51821;
                };
                managementUrlSecret = "netbird_wt0_management_url";
                setupKeyFile = "/var/lib/netbird-wt0.key";
              }
              {
                name = "wt1";
                settings = {
                  port = 51822;
                };
                managementUrlSecret = "netbird_wt1_management_url";
              }
            ];
          };
        };

      homeConfigurations =
        let
          mkHomeConfiguration =
            profile:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                inherit
                  inputs
                  pkgs-unstable
                  pkgs-custom
                  system
                  username
                  theme
                  ;
              };
              modules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.catppuccin.homeModules.catppuccin
                profile
                {
                  nixpkgs.config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (lib.getName pkg) [
                      "zoom-us"
                      "zoom"
                      "drawio"
                      "slack"
                      "grayjay"
                    ];
                }
              ];
            };
        in
        rec {
          personal = mkHomeConfiguration ./home/profiles/personal.nix;
          professional = mkHomeConfiguration ./home/profiles/professional.nix;
          # Backwards-compatible alias for the old standalone activation command.
          ${username} = personal;
        };

      devShells.${system}.default = pkgs.mkShell {
        name = "dotfiles-shell";
        buildInputs = with pkgs; [
          pre-commit
          detect-secrets
          deadnix
          statix
          nixfmt
        ];
        shellHook = ''
          pre-commit install
        '';
      };
    };
}
