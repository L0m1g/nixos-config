{
  description = "My nixos config with WM switch capacity";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager-stable,
    home-manager,
    nur,
    ...
  } @ inputs: let
  mkUnstablePkgsWithNur = { system, config ? {} }:
    import nixpkgs-unstable {
      inherit system;
      overlays = [ nur.overlays.default ];
      config = config ;
    };
  in 

  {
# --- Host NixOS (x86_64) ---
    nixosConfigurations = {
      pennsardin = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = mkUnstablePkgsWithNur  {
          system = "x86_64-linux";
          config = {
            allowUnfree = true ;
            allowUnsupportedSystem = true ;
          };
        };
        modules = [
          ./hosts/pennsardin/configuration.nix
            home-manager.nixosModules.home-manager
        ];
      };

      terre-neuvas = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/terre-neuvas/configuration.nix
            home-manager-stable.nixosModules.home-manager
        ];
      };
    };

# --- DevShell (x86_64 uniquement) ---
    devShells.x86_64-linux.default = import ./devshell.nix {
      pkgs = import nixpkgs-stable {system = "x86_64-linux";};
    };

# --- Formatter (x86_64 uniquement) ---
    formatter.x86_64-linux =
      (import nixpkgs-stable {system = "x86_64-linux";}).alejandra;
  };
}
