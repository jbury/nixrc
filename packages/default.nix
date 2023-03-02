{ pkgs ? import <nixpkgs> {} }:

with pkgs;
{
  godoc = (callPackage ./godoc.nix { });
  gorename = (callPackage ./gorename.nix { });
  kustomize = (callPackage ./kustomize.nix { });
  testkube = (callPackage ./testkube.nix {});
  thermald = (callPackage ./thermald {});
}
