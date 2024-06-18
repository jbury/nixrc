{ pkgs, lib }:

let
  callPackage = (lib.callPackageWith pkgs);
in {
  thermald = (callPackage ./thermald {});
  kustomize = (callPackage ./kustomize.nix {});
  vanta-agent = (callPackage ./vanta-agent {});
}
