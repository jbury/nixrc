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
          # Kubernetes
          kubectl         # Talk at my kubernet pls
          k9s             # Like kubectl, but _fancy_
          krew            # Plugin manager
          kubernetes-helm # Bane of my existence
          kind            # Local kluster
          kustomize    # We don't mess with the kubectl-bundled version
          kubent

          # Kubernet-curious apps
          open-policy-agent # Policies and such
          istioctl          # TLS?  I've never met her!
          tilt              # gottagofast

          terraform

          # stern really ought to be installed via krew
          argocd
        ];
      };

      modules.shell.zsh.aliases.kc = "kubectl";
      modules.shell.zsh.aliases.k = "kubectl";
      modules.shell.zsh.aliases.kccc = "kubectl config current-context";

      modules.shell.zsh.aliases.tfdiff = "terraform show --json | jq '.resource_changes[] | select(.change.actions | index(\"no-op\") | not)'";

      env.PATH = [ "$HOME/.krew/bin" ];
    })
  ];
}
