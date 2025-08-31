{
  description = "My nixos config with WM switch capacity";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
    system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  in {
    nixosConfigurations = {
      pennsardin = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/pennsardin/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true ;
#							home-manager.useUserPackages = true;

              home-manager.users.lomig = import ./user/lomig.nix ;
            }
        ];
      };
    };
  };
}

# vim: set ts=2 sw=2 sts=2 et :
