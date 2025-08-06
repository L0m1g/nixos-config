{
  description = "Mon système NixOS flake-enabled avec Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # Change si t’as un ordi chelou
    in {
      nixosConfigurations = {
        pennsardin = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/pennsardin/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.lomig = import ./home/pennsardin.nix;
            }
          ];
        };
      };
    };
}

