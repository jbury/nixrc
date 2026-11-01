{ config, lib, ... }:
let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.dev.ai.claude;
in {
	options.jbury.nixrc.home.modules.dev.ai.claude = {
		enable = mkEnableOption "claude";
	};

	config = mkIf cfg.enable {
		programs.claude-code.enable = true;
	};
}
