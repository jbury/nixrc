{ config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.dev.cloud.aws;
in {
	options.jbury.nixrc.home.modules.dev.cloud.aws = {
		enable = mkEnableOption "aws";
	};

	config = mkIf cfg.enable {
		home.packages = [
			pkgs.awscli2
			pkgs.eksctl
		];
	};
}
