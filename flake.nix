{
  description = "My complete macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, darwin, home-manager, ... }: {
    darwinConfigurations."Odins-MacBook-Pro" = darwin.lib.darwinSystem {
      modules = [
        ./configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # If a file Home Manager wants to manage already exists (e.g. ~/.zshrc),
          # rename it to *.backup instead of failing.
          home-manager.backupFileExtension = "backup";

          home-manager.users.odinhg = import ./home.nix;
        }
      ];
    };
  };
}
