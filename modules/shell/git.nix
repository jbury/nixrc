{ config, lib, pkgs, ... }:

let
  inherit (lib) mkMerge mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.shell.git;
  configDir = config.dotfiles.configDir;

  personalGitIdentity = {
    user.name = "Jason Bury";
    user.email = "jasondougbury@gmail.com";
    user.signingkey = "~/.ssh/jbury_github.pub";
  };

in {

  options.modules.shell.git = {
    enable = mkBoolOpt false;
    gitlab.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.configFile = {
	"git/config".source = "${configDir}/git/config";
        "git/ignore".source = "${configDir}/git/ignore";
        "git/attributes".source = "${configDir}/git/attributes";
        "git/dad.txt".source = "${configDir}/git/dad.txt";

        "git/personal-user.ini".text = generators.toGitINI personalGitIdentity;
        "git/default-user.ini".text = generators.toGitINI {
          user.name = "Jason Bury";
          user.email = config.hostSettings.email;
          user.signingkey = "~/.ssh/default_git.pub";.
        }
      };

      modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
    })
    (mkIf (cfg.enable && cfg.gitlab.enable) {
      user.packages = [ pkgs.glab ];
    })
  ];
}
