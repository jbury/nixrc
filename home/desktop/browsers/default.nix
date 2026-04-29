{ homeSettings, lib, pkgs, ... }:
let
	inherit (lib) mkIf;
in {
	imports = [
		./firefox.nix
	];
	
	config = mkIf homeSettings.hasDesktop {
		home.packages = [
			pkgs.chromium
		];
	};
}
