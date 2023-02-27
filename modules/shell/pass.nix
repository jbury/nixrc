{ config, options, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.pass;
  package = pkgs.pass-wayland.overrideAttrs(oa: { x11Support = false; waylandSupport = true; });
in {
  options.modules.shell.pass = with types; {
    enable = mkBoolOpt false;
    passwordStoreDir = mkOpt str "$HOME/.secrets/password-store";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      [
        (package.withExtensions (exts:
          [ exts.pass-otp exts.pass-genphrase exts.pass-update exts.pass-audit ]
          ++ (if config.modules.shell.gnupg.enable then
            [ exts.pass-tomb ]
          else
            [ ])))
      ];
    env.PASSWORD_STORE_DIR = cfg.passwordStoreDir;
  };
}
