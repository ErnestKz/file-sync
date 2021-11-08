with import (import ./nix/sources.nix).nixpkgs {};
let
  drv = pkgs.haskellPackages.callCabal2nix "FileSync" ./. { };
in
mkShell {
  inputsFrom = [ drv.env ];
  buildInputs = [
    cabal2nix
    niv
    haskellPackages.haskell-language-server
  ];
}
