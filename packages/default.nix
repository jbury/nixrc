{ pkgs ? import <nixpkgs> {} }:

with pkgs;
{
  thermald = (callPackage ./thermald {});
}
