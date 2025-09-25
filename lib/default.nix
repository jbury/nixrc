{ lib, mkPkgsForSystem, ... }:
let

	subLibs = {
		options = import ./options.nix
		hosts = import ./hosts.nix { lib, mkPkgsForSystem }
	};
in {
	inherit (subLibs.options)
		mkOpt
		mkOpt'
		mkBoolOpt'
		;
};
