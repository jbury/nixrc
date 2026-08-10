{ config, lib, pkgs, ... }:

let
	inherit (lib) mkDefault mkEnableOption mkIf;

	cfg          = config.jbury.nixrc.hosts.modules.docker;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	options.jbury.nixrc.hosts.modules.docker = {
		enable = mkEnableOption "Docker";
	};

	config = mkIf cfg.enable {
		virtualisation = {
			docker = {
				enable = true;

				autoPrune.enable = true;
				enableOnBoot     = mkDefault false;
			};
		};

		environment = {
			systemPackages = [ pkgs.docker pkgs.docker-compose ];

			variables = {
				DOCKER_CONFIG        = "$XDG_CONFIG_HOME/docker";
				MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker/machine";
				DOCKER_BUILDKIT      = "1";
			};
		};

		users.groups.docker.members = [
			hostSettings.userName
		];
	};
}
