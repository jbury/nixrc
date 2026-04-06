{ config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.dev.cloud.gcp;
in {
	options.jbury.nixrc.home.modules.dev.cloud.gcp = {
		enable = mkEnableOption "gcp";
	};

	config = mkIf cfg.enable {
		home.packages = [
			(pkgs.google-cloud-sdk.withExtraComponents ([
				pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
				pkgs.google-cloud-sdk.components.config-connector
				pkgs.google-cloud-sdk.components.terraform-tools
			]))
			pkgs.google-cloud-sql-proxy
		];

		home.sessionVariables = {
			USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
		};
	};
}
