{ config, pkgs, ... }:

{
  home.username = "jbury";
  home.homeDirectory = "/home/jbury";

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.vim
    pkgs.curl
    pkgs.zsh
    pkgs.git
  ];
}
