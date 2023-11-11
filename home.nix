{ config, pkgs, username, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Bare Necessities
    curl
    vim
    zsh
    git

    # Stuff you probably want for work
    kubernetes-helm #Helm 3
    kubectl
    kustomize
    istioctl
    postgresql
    pgcenter
    cloud-sql-proxy
    # The only nonfree software in the bunch
    slack

    # Stuff that is _really_ handy to have on hand
    fd
    jq
    ripgrep
    tree
    yq-go
  ];
}
