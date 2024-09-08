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
        lib = import ./libs/dev-shell.nix { inherit pkgs; };
      in
      {
        devShells.default = lib.mkDevShell { };
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
