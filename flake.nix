{
  description = "A Nix flake for pre-commit setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Exposure of the dev-shell
        lib = {
          mkDevShell = import ./libs/dev-shell.nix { inherit pkgs; };
        };

        # Self use of the dev-shell
        devShells.default = self.lib.${system}.mkDevShell { };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
