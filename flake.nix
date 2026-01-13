{
  description = "My dotfiles!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nvim = {
      url = "path:nvim";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nur,
      nixgl,
      catppuccin,
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
        };
        modules = [
          ./home/personal.nix
          {
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
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
        modules = [
          ./home/work.nix
          {
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
          }
        ];
      };
    };
}
