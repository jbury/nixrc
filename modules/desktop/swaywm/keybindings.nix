{ options, config, lib, pkgs, inputs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.swaywm;
  swayConfig = config.home.wayland.windowManager.sway.config;
in {
  config = mkIf cfg.enable {
    home.wayland.windowManager.sway = let
      super = "Mod4";
      alt = "Mod1";
      control = "Ctrl";
      shift = "Shift";
      hyper = "${control}+${alt}+${super}+${shift}";
      meh = "${control}+${alt}+${shift}";
      left = "h";
      down = "j";
      up = "k";
      right = "l";
    in {
      config = {
        modifier = "Mod4";
        keybindings = lib.mkOptionDefault {
          "${super}+Return" = "exec ${swayConfig.terminal}";
          "${super}+f" = "exec firefox";
          "${super}+k" = "exec keepassxc";
          "${super}+q" = "kill";
          "${super}+space" = "exec $DOTFILES/bin/rofi/appmenu";
          "${super}+Tab" = "exec $DOTFILES/bin/rofi/windowmenu";
          "${super}+Shift+c" = "reload";
          "${super}+${control}+${shift}+Escape" = "reload";
          "${super}+question" = "exec $DOTFILES/bin/remontoire-toggle";
          "${super}+e" = "exec emacsclient -e '(emacs-everywhere)'";
          "${super}+t" =
            "exec emacsclient -n -c ~/Documents/org-mode/todo.org && $DOTFILES/bin/activate emacs";
          "${super}+n" =
            "exec emacsclient -n -c ~/Documents/org-mode/notes.org && $DOTFILES/bin/activate emacs";
          "${super}+d" =
            "exec emacsclient -n -c -e '(org-roam-dailies-goto-today)' && $DOTFILES/bin/activate emacs";
          "${super}+${control}+t" =
            "exec $XDG_CONFIG_HOME/emacs/bin/org-capture -k t";
          "${super}+${control}+n" =
            "exec $XDG_CONFIG_HOME/emacs/bin/org-capture -k n";
          "${super}+m" =
            "exec emacsclient -c -n -e '(=mu4e)' && $DOTFILES/bin/activate emacs";
          "${hyper}+e" = "$DOTFILES/bin/activate emacs";
          "${hyper}+f" = "$DOTFILES/bin/activate firefox";
          "${hyper}+s" = "$DOTFILES/bin/activate slack";
          "${hyper}+z" = "$DOTFILES/bin/activate zoom zoom-us";

          "${super}+${shift}+${left}" = "move left";
          "${super}+${shift}+${down}" = "move down";
          "${super}+${shift}+${up}" = "move up";
          "${super}+${shift}+${right}" = "move right";

          "${super}+${shift}+${control}+${left}" = "move output left";
          "${super}+${shift}+${control}+${down}" = "move output down";
          "${super}+${shift}+${control}+${up}" = "move output up";
          "${super}+${shift}+${control}+${right}" = "move output right";

          "${meh}+${left}" = "move workspace to output left";
          "${meh}+${down}" = "move workspace to output down";
          "${meh}+${up}" = "move workspace to output up";
          "${meh}+${right}" = "move workspace to output right";

          "${super}+w" =
            "exec swayr toggle-tab-shuffle-tile-workspace include-floating";
          #"${super}+e" = "layout toggle split";

          "${super}+${alt}+f" = "floating toggle";
          "${super}+${control}+f" = "fullscreen";
          "${super}+a" = "focus parent";
          "${super}+minus" = "scratchpad show";
          "${super}+${shift}+minus" = "move scratchpad";

          "${super}+Left" = "resize grow width 40 px";
          "${super}+Down" = "resize grow height 40 px";
          "${super}+Up" = "resize grow height 40 px";
          "${super}+Right" = "resize grow width 40 px";
          "${super}+${control}+Left" = "resize shrink width 40 px";
          "${super}+${control}+Down" = "resize shrink height 40 px";
          "${super}+${control}+Up" = "resize shrink height 40 px";
          "${super}+${control}+Right" = "resize shrink width 40 px";

          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";

          "XF86MonBrightnessUp" =
            "exec ${pkgs.brightnessctl}/bin/brightness_ctl set +10% && $DOTFILES/bin/brightnessctl_perc > $SWAYSOCK.wob";
          "XF86MonBrightnessDown" =
            "exec ${pkgs.brightnessctl}/bin/brightness_ctl set 10%- && $DOTFILES/bin/brightnessctl_perc > $SWAYSOCK.wob";

          "XF86AudioRaiseVolume" =
            "exec pamixer -ui 2 && pamixer --get-volume > $SWAYSOCK.wob";
          "XF86AudioLowerVolume" =
            "exec pamixer -ud 2 && pamixer --get-volume > $SWAYSOCK.wob";
          "XF86AudioMute" =
            "exec pamixer -t && if [ $(pamixer --get-mute) == true ]; then; echo 0; else; pamixer --get-volume; fi > $SWAYSOCK.wob";

          "${super}+r" = ''mode "resize"'';

          "--no-repeat --release ${hyper}+m" = "exec $DOTFILES/bin/mute-huddle";

          #     floating_modifier $super normal
        };
        modes = {
          resize = {
            "${left}" = "resize shrink width 10px";
            "${down}" = "resize grow height 10px";
            "${up}" = "resize shrink height 10px";
            "${right}" = "resize grow width 10px";

            "Left" = "resize shrink width 10px";
            "Down" = "resize grow height 10px";
            "Up" = "resize shrink height 10px";
            "Right" = "resize grow width 10px";

            "Return" = ''mode "default"'';
            "Escape" = ''mode "default"'';
          };
        };
      };
    };
  };
}
