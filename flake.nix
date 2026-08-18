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
            "grok"
            "vagrant"
            "drawio"
            "zoom"
            "zoom-us"
            "slack"
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
          ];
        overlays = [
          nur.overlays.default
          nixgl.overlay
        ];
      };
      theme = import ./home/theme.nix;
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
                      "grok"
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
            hardwareModule = ./system/hardware-configuration.nix;
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
                  system
                  username
                  theme
                  ;
                pkgs-custom = {
                  nvim = inputs.nvim.packages.${system}.default;
                  betterbird = pkgs.callPackage ./pkgs/by-name/be/betterbird/package.nix { };
                  grok = pkgs.callPackage ./pkgs/by-name/gr/grok/package.nix { };
                  vastai = pkgs.callPackage ./pkgs/by-name/va/vastai/package.nix { };
                  google-colab-cli = pkgs.callPackage ./pkgs/by-name/go/google-colab-cli/package.nix { };
                };
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
                      "grok"
                      "slack"
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
