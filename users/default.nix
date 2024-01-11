{ config, lib, pkgs, ... }:

let a = "hi";
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.jbury = import ./jbury;
  };
}
