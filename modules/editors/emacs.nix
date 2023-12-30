# One day I'll learn how to drive this thing

{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.types) str;
  inherit (lib.my) mkBoolOpt mkOpt;

  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
  myEmacs = pkgs.emacs-git;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    doom = { repoUrl = mkOpt str "https://github.com/doomemacs/doomemacs"; };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      ((emacsPackagesFor myEmacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))

      ## Doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      zstd # for undo-fu-session/undo-tree compression
      python3 # for treemacs

      ## Module dependencies
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :checkers grammar
      languagetool
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      beancount
      # fava
      # :lang rust
      rustfmt
      rust-analyzer
      (makeDesktopItem {
        name = "org-protocol";
        desktopName = "org-protocol";
        exec = "${myEmacs}/bin/emacsclient -n %u";
        type = "Application";
        categories = [ "System" ];
        mimeTypes = [ "x-scheme-handler/org-protocol" ];
      })
      # :lang nix
      nixfmt
      nil # This is the lsp server
      # :lang sh
      shellcheck
      # :lang org
      graphviz

      mpc_cli

      # :lang terraform
      terraform-ls

      # :lang go
      gocode
      gomodifytags
      gotests
      gore

      # :lang markdown
      discount

      # :lang web
      html-tidy

      pandoc
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.packages = [ pkgs.emacs-all-the-icons-fonts ];

    system.userActivationScripts.installDoomEmacs = ''
      if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
         ${pkgs.git}/bin/git clone --depth=1 --single-branch "${cfg.doom.repoUrl}" "$XDG_CONFIG_HOME/emacs"
      fi
    '';
  };
}
