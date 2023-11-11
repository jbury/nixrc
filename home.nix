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
    ripgrep
    keepass
    kubectl
    kustomize
    drawio
    istioctl
    postgresql
    pgcenter
    cloud-sql-proxy
    tree
    jq
    yq-go
    go_1_19
    sublime4
    kubernetes-helm #Helm 3
    rename
    shellcheck
    yamllint
    ruby_2_7
    fd
    krew
    spotify
  ];
}
