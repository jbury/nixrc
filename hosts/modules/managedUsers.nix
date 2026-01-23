{ config, lib, ... }:
let
	inherit (lib) mkDefault mkEnableOption mkIf;

	cfg          = config.jbury.nixrc.hosts.modules.managedUsers;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	options.jbury.nixrc.hosts.modules.managedUsers = {
		enable = mkEnableOption "Nixos-driven default user creation";
	};

	config.users.users.${hostSettings.userName} = mkIf cfg.enable {
			isNormalUser = true;
			uid = mkDefault 1000;
			extraGroups = [ "wheel" ];
	};
}
