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

  home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = ''
        rm -rf ${config.xdg.dataHome}/"applications/home-manager"
        mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
        cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
      '';
    };
  };
}
