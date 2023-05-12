{ pkgs ? import <nixpkgs> {} }:

with pkgs;
{
  thermald = (callPackage ./thermald {});
  kustomize = (callPackage ./kustomize.nix {});
}
