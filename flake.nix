{
  description = "My nixos config with WM switch capacity";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: {
    # --- Host NixOS (x86_64) ---
    nixosConfigurations.pennsardin = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/pennsardin/configuration.nix
        home-manager.nixosModules.home-manager
        # L'utilisateur HM est déclaré dans hosts/pennsardin/configuration.nix
      ];
    };

    # --- DevShell (x86_64 uniquement) ---
    devShells.x86_64-linux.default = import ./devshell.nix {
      pkgs = import nixpkgs {system = "x86_64-linux";};
    };

    # --- Formatter (x86_64 uniquement) ---
    formatter.x86_64-linux =
      (import nixpkgs {system = "x86_64-linux";}).alejandra;
  };
}
