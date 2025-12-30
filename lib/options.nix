{ lib, ... }:
let

	inherit (lib) mkOption types;

in {
	mkOpt = type: default:
		mkOption { inherit type default; };

	mkBoolOpt = default:
		mkOption { inherit default; type = types.bool; };
}
