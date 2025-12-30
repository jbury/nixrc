{ lib, ... }:
let
	subLibs = {
		options = import ./options.nix {inherit lib;};
	};
in {
	inherit (subLibs.options) mkOpt mkBoolOpt;
}
