# modules/dev/cloud.nix
#
# Packages for various cloud services
{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.dev.cloud;
in {
  options.modules.dev.cloud = {
    enable = mkBoolOpt false;
    google.enable = mkBoolOpt false;
    amazon.enable = mkBoolOpt false;
    microsoft.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.google.enable {
      user.packages = with pkgs; [
        (google-cloud-sdk.withExtraComponents([
          google-cloud-sdk.components.gke-gcloud-auth-plugin
          google-cloud-sdk.components.config-connector
          google-cloud-sdk.components.terraform-tools
        ]))
        cloud-sql-proxy
      ];

      env.USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    })

    (mkIf cfg.amazon.enable { user.packages = with pkgs; [ awscli ]; })

    (mkIf cfg.microsoft.enable { user.packages = with pkgs; [ azure-cli ]; })

    (mkIf cfg.enable {
      user = {
        packages = with pkgs; [
          unstable.terraform
          unstable.kubectl
          unstable.minikube
          unstable.k9s
          unstable.kubernetes-helm
          krew
          unstable.open-policy-agent
          istioctl
          unstable.kind
          my.kustomize
          go-jsonnet
          hadolint
          kube3d
          tilt
          stern
          my.sloth
          # my.google-cloud-sdk-gke-gcloud-auth-plugin
        ];
      };

      modules.shell.zsh.aliases.k = "kubectl";
      env.PATH = [ "$HOME/.krew/bin" ];
    })
  ];
}
