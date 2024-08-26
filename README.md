{
  description = "Your project description";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-env = {
      url = "github:chenow/nix-pre-commit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-env, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pre-commit-env.lib.${system}.mkDevShell {
          extraPackages = with pkgs; [
            # add your packages here...
          ];
          extraShellHook = ''
            echo "Welcome to the pre-commit development environment!"
          '';
        };
      });
}
