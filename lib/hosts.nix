{ lib, mkPkgsForSystem, ... }:
let

	inherit (builtins) pathExists readDir;
	inherit (lib) filterAttrs hasSuffix hasPrefix mapAttrs nameValuePair removeSuffix;


	mkNixosHost = path: {
		#TODO: Pull this from the hostConfig
		system = "x86_64-linux";

		inherit lib;
		specialArgs = { inherit lib inputs system jbury-lib; };
		modules = [
			{
				nixpkgs.pkgs = mkPkgs { inherit system; };
			}
				(import path)
		];
	};
in {
	mapHosts = hostsDir: mkPkgsFn: {
		mapNixosHosts



		# TODO someday if I feel like running nix on mac
		# mapDarwinHosts
	};

}
