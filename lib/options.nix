# Convenience functions that force me to make my Options typed.
#
# functions with suffix "Def" allow setting a default value.

{ lib, ... }:
let
	inherit (lib) mkOption types;

in {

	mkOpt = type:
		mkOption { inherit type; };

	mkOptDef = default: type:
		mkOption { inherit default type; };

	mkBoolOpt =
		mkOption { type = types.bool; };

	mkBoolOptDef = default:
		mkOption { inherit default; type = types.bool; };
}
