# modules/dev/cloud.nix
#
# Packages for various cloud services
#
# Also Kubernetes, because what else even _is_ a cloud?

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkMerge mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.cloud;
in {
  options.modules.dev.cloud = {
    enable = mkBoolOpt false;
    gcp.enable = mkBoolOpt false;
    aws.enable = mkBoolOpt false;
    azure.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf (cfg.enable && cfg.gcp.enable) {
      user.packages = with pkgs; [
        (google-cloud-sdk.withExtraComponents ([
          google-cloud-sdk.components.gke-gcloud-auth-plugin
          google-cloud-sdk.components.config-connector
          google-cloud-sdk.components.terraform-tools
        ]))
        google-cloud-sql-proxy
      ];

      env.USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    })

    (mkIf (cfg.enable && cfg.aws.enable) {
      user.packages = [
        pkgs.awscli2
        pkgs.eksctl
      ];
    })

    (mkIf (cfg.enable && cfg.azure.enable) {
      user.packages = [ pkgs.azure-cli ];
    })

    (mkIf cfg.enable {
      user = {
        packages = with pkgs; [
          # Certifiable
          certbot

          # Visualizing terraform graphs upsets me deeply, but I had to do it
          graphviz

          # Useful for putting together shareable collections of test requests
          postman

          # Kubernetes
          kubectl # Talk at my kubernet pls
          k9s # Like kubectl, but _fancy_
          krew # Plugin manager
          kubernetes-helm # Bane of my existence
          kind # Local kluster
          kustomize # We don't mess with the kubectl-bundled version
          kubent

          # Kubernet-curious apps
          istioctl # TLS?  I've never met her!
          tilt # gottagofast

          terraform
          terraform-docs
          terramate

          # stern really ought to be installed via krew
          argocd
        ];
      };

      modules.shell.zsh.aliases.kc = "kubectl";
      modules.shell.zsh.aliases.k = "kubectl";
      modules.shell.zsh.aliases.kccc = "kubectl config current-context";

      modules.shell.zsh.aliases.tf = "terraform";
      modules.shell.zsh.aliases.tir = "terraform plan -var-file=secrets.tfvars -out=planfile";
      modules.shell.zsh.aliases.tap = "terraform apply planfile";
      modules.shell.zsh.aliases.tfp = "terraform plan";
      modules.shell.zsh.aliases.tfa = "terraform apply";
      modules.shell.zsh.aliases.tfw = "terraform workspace";
      modules.shell.zsh.aliases.tfws = "tfw select";
      modules.shell.zsh.aliases.tfwl = "tfw list";
      modules.shell.zsh.aliases.tfv = "terraform validate";
      modules.shell.zsh.aliases.tfdiff =
        "terraform show --json | jq '.resource_changes[] | select(.change.actions | index(\"no-op\") | not)'";

      env.PATH = [ "$HOME/.krew/bin" ];
    })
  ];
}
