# One day I'll learn how to drive this thing

{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.types) str;
  inherit (lib.my) mkBoolOpt mkOpt;

  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
  myEmacs = with pkgs; (emacsPackagesFor
    (if config.modules.desktop.swaywm.enable
    then pkgs.emacs-git-pgtk
    else pkgs.emacs-git)).emacsWithPackages (epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      vterm
    ]);
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    doom = { repoUrl = mkOpt str "https://github.com/doomemacs/doomemacs"; };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      myEmacs

      ## Doom dependencies
      git
      ripgrep
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      zstd # for undo-fu-session/undo-tree compression
      python3 # for treemacs

      ## Module dependencies
      #(aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      (aspellWithDicts (ds: with ds; [ en en-computers ]))

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
      (makeDesktopItem {
        name = "org-protocol";
        desktopName = "org-protocol";
        exec = "${myEmacs}/bin/emacsclient -n %u";
        type = "Application";
        categories = [ "System" ];
        mimeTypes = [ "x-scheme-handler/org-protocol" ];
      })

      # :lang nix
      nixfmt-rfc-style
      nil # This is the lsp server

      # :lang sh
      shellcheck
      shfmt

      # :lang org
      graphviz

      mpc_cli

      # :lang terraform
      terraform-ls

      # :lang go
      gopls
      gomodifytags
      gotests
      gore

      # :lang markdown
      discount

      # :lang web
      html-tidy

      # :app everywhere
      xdotool
      xorg.xwininfo

      pandoc
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    env.ALTERNATE_EDITOR = "";

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.packages = [ pkgs.emacs-all-the-icons-fonts ];

    system.userActivationScripts.installDoomEmacs = ''
      if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
         ${pkgs.git}/bin/git clone --depth=1 --single-branch "${cfg.doom.repoUrl}" "$XDG_CONFIG_HOME/emacs"
      fi
    '';
  };
}
