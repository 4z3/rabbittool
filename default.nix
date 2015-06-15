let
  inherit ((import <nixpkgs> {}).pkgs.haskellPackages) callPackage;
in
callPackage ./rabbittool.nix {
  amqp = callPackage ./amqp.nix {};
}
