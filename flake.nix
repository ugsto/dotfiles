{
  description = "My dotfiles!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    catppuccin.url = "github:catppuccin/nix/release-25.11";
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
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      username = "kurisu";
      work-username = "andre.bortoli";
      name = "André Augusto Bortoli";
      hostname = "steins-gate";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nur.overlays.default
          nixgl.overlay
        ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        overlays = [
          nur.overlays.default
          nixgl.overlay
        ];
      };
      theme = import ./home/theme.nix;
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;

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
          nixfmt-rfc-style
        ];
        shellHook = ''
          pre-commit install
        '';
      };
    };
}
