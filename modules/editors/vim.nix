# When I don't want to risk my disk quota being reduced by 100K

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.vim = {
        enable = true;
        settings = {
          background = "dark";
          copyindent = true;
          # Because I use emacs most everywhere, vim is only for machines
          # I don't want to install all emacs things on, which is probably
          # a hellscape where people use spaces.
          expandtab = true;
          # Save me from myself, vim-sama
          hidden = false;
          ignorecase = false;
          modeline = false;
          mouse = null;
          mousefocus = false;
          mousehide = false;
          mousemodel = "extend";
          number = true;
          shiftwidth = 2;
          tabstop = 2;
        };

        extraConfig = ''
          syntax on
          set t_Co=256
          set encoding=utf-8

          set paste
          set backspace=indent,eol,start
          set cursorline
          set showmatch
          set hlsearch
          set incsearch

          hi CursorLine cterm=NONE ctermbg=234 ctermfg=NONE

          highlight ExtraWhitespace ctermbg=red guibg=red
          autocmd Syntax * syn match ExtraWhitespace /\s\+$| \+\ze|t/

          set listchars:tab:»·,trail:·
          set list

          set colorcolumn=125

          set visualbell
          set noerrorbells

          set title
          set showcmd
          set laststatus=2

          set autoread
        '';

        defaultEditor = true;
      };
    };
  };
}
