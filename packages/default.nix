{ pkgs, lib }:

let
  callPackage = (lib.callPackageWith pkgs);
in {
  kustomize = (callPackage ./kustomize.nix {});
  vanta-agent = (callPackage ./vanta-agent {});
}
