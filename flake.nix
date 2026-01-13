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
        overlays = [ nur.overlays.default ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        overlays = [ nur.overlays.default ];
      };
    in
    {
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
            ;
        };
        modules = [
          ./home/configuration.nix
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
            ;
          username = work-username;
        };
        modules = [
          ./home/configuration.nix
          ./home/work-overrides.nix
          {
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
          }
        ];
      };
    };
}
