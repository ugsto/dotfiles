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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nvim = {
      url = "path:pkgs/nvim";
    };
  };
  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nur,
      nixgl,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      username = "kurisu";
      work-username = "andre.bortoli";
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

      nixosConfigurations = {
        ${hostname} = lib.nixosSystem {
          specialArgs = {
            inherit
              username
              name
              hostname
              ;
          };
          modules = [
            ./system/configuration.nix
            {
              nixpkgs.config.allowUnfreePredicate =
                pkg:
                builtins.elem (lib.getName pkg) [
                  "vagrant"
                  "drawio"
                  "grok"
                ];
            }
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
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
          };
        };
        modules = [
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.catppuccin.homeModules.catppuccin
          inputs.noctalia.homeModules.default
          ./home/personal.nix
          {
            nixpkgs.config.allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "zoom-us"
                "zoom"
                "drawio"
                "grok"
              ];
          }
        ];
      };

      homeConfigurations.${work-username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit
            inputs
            pkgs-unstable
            system
            theme
            ;
          username = work-username;
        };
        modules = [ ./home/work.nix ];
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
