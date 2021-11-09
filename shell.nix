with import (import ./nix/sources.nix).nixpkgs {};
let
  drv = pkgs.haskellPackages.callCabal2nix "file-sync" ./. { };
in
mkShell {
  inputsFrom = [ drv.env ];
  buildInputs = [
    
    hpack
    cabal2nix
    niv
    haskellPackages.haskell-language-server
  ];
}
