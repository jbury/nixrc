{ config, lib, ... }:

let
	inherit (lib) mkDefault mkIf;
	inherit (lib.my) mkBoolOpt;

	cfg = config.hostModules.managedNetwork;
in {
	options.hostModules.managedNetwork = {
		enable = mkBoolOpt true;
	};

	config = {
		networking = mkIf cfg.enable {
			useDHCP = mkDefault true;
			enableIPv6 = mkDefault true;
			useNetworkd = mkDefault true;
			nameservers = mkDefault [];
			nftables.enable = mkDefault true;

			firewall = {
				enable = true;
				allowedTCPPorts = [ 22 80 443 ];
				allowedTCPPortRanges = [ { from = 8080; to = 8090; } ];

				allowedUDPPorts = [
					#DHCPv6
					546
				];
				allowedUDPPortRanges = [];
			};
		};
	};
}
