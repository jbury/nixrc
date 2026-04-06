{ config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.dev.cloud.azure;
in {
	options.jbury.nixrc.home.modules.dev.cloud.azure = {
		enable = mkEnableOption "azure";
	};

	config = mkIf cfg.enable {
		home.packages = [ pkgs.azure-cli ];
	};
}
