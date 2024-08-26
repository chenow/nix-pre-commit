# Nix-pre-commit

Nix module providing a dev shell with pre-commit installed, and a setup of default hooks.

## Installation

Here is an example of a `flake.nix` file using pre-commit-env

```nix
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

  outputs = { self, nixpkgs, flake-utils, pre-commit-env, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pre-commit-lib =
          import "${pre-commit-env}/libs/dev-shell.nix" { inherit pkgs; };
      in {
        devShells.default = pre-commit-lib.mkDevShell {
          extraPackages = with pkgs;
            [
              # Add any extra packages you need here
            ];
          extraShellHook = ''
            # Add any extra shell commands you want to run here
          '';
        };
      });
}
```

## Usage

When entering a dev shell, Nix-pre-commit will create a default `.pre-commit-config.yaml` configuration file, as well as installing git hooks.

Now, git hooks will be triggered based on your configuration (i.e. at each git commit and push if you left untouched the default configuration).
