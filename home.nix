{ config, pkgs, ... }:

{
  home.username = "jbury";
  home.homeDirectory = "/home/jbury";

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    vim
    curl
    zsh
    git
    slack
  ];
}
