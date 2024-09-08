{ pkgs }:
{
  extraPackages ? [ ],
  extraShellHook ? "",
}:
let
  preCommitScript = pkgs.writeShellApplication {
    name = "create-precommit-config";
    runtimeInputs = [ pkgs.bash ];
    text = builtins.readFile ./scripts/create-precommit-config.sh;
  };
in

pkgs.mkShell {
  nativeBuildInputs =
    with pkgs;
    [
      python3
      pre-commit
      nixfmt-rfc-style
    ]
    ++ extraPackages;

  shellHook = ''
    printf "\n-- Start of pre-commit setup --\n"
    ${preCommitScript}/bin/create-precommit-config
    pre-commit install
    echo "-- End of pre-commit setup ----"
    echo
    ${extraShellHook}
  '';
}
