{ lib, ... }:
let
	subLibs = {
		options = import ./options.nix;
	};
in {
	inherit (subLibs.options)
		mkOpt
		mkOpt'
		mkBoolOpt
		;
}
