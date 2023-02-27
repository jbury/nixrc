# modules/themes/base16/default.nix --- a theme for those who cannot choose

{ options, config, lib, pkgs, home-manager, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.theme;
  colors = config.lib.stylix.colors;
  fonts = config.stylix.fonts;
in {
  config = mkIf (cfg.active == "base16") (mkMerge [
    {
      modules = {
        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        shell.tmux.rcFiles = [ ./config/tmux.conf ];
        # desktop.browsers = {
        #   firefox.userChrome = concatMapStringsSep "\n" readFile
        #     [ ./config/firefox/userChrome.css ];
        # };
      };
    }
    {
      home.configFile = mkMerge [{
        "sway/theme".text = ''
          output * bg ${config.stylix.image} fill

          set $base00 #${colors.base00-hex}
          set $base01 #${colors.base01-hex}
          set $base02 #${colors.base02-hex}
          set $base03 #${colors.base03-hex}
          set $base04 #${colors.base04-hex}
          set $base05 #${colors.base05-hex}
          set $base06 #${colors.base06-hex}
          set $base07 #${colors.base07-hex}
          set $base08 #${colors.base08-hex}
          set $base09 #${colors.base09-hex}
          set $base0A #${colors.base0A-hex}
          set $base0B #${colors.base0B-hex}
          set $base0C #${colors.base0C-hex}
          set $base0D #${colors.base0D-hex}
          set $base0E #${colors.base0E-hex}
          set $base0F #${colors.base0F-hex}

          # bar {
          #     colors {
          #         background $base00
          #         separator  $base01
          #         statusline $base04

          #         #                   Border  BG      Text
          #         focused_workspace   $base05 $base0D $base00
          #         active_workspace    $base05 $base03 $base00
          #         inactive_workspace  $base03 $base01 $base05
          #         urgent_workspace    $base08 $base08 $base00
          #         binding_mode        $base00 $base0A $base00
          #     }
          # }

          #                       Border  BG      Text    Ind     Child Border
          client.focused          $base05 $base0D $base00 $base0D $base0D
          client.focused_inactive $base01 $base01 $base05 $base03 $base01
          client.unfocused        $base01 $base00 $base05 $base01 $base01
          client.urgent           $base08 $base08 $base00 $base08 $base08
        '';

        "fuzzel/fuzzel.ini".text = lib.generators.toINIWithGlobalSection { } {
          globalSection = {
            font = "${fonts.monospace.name}:size=16";
            icons-enabled = "no";
            show-actions = "yes";
            width = 60;
            prompt = " ";
          };

          sections = {
            colors = {
              background = "${colors.base00}ff";
              text = "${colors.base05}ff";
              match = "${colors.base0B}ff";
              selection = "${colors.base02}ff";
              selection-text = "${colors.base05}ff";
              border = "${colors.base00}ff";
            };
          };
        };
      }];
    }
    {
      stylix.image = /home/jboyens/Downloads/vhs.png;

      # pkgs.fetchurl {
      #   url =
      #     "https://github.com/vctrblck/gruvbox-wallpapers/raw/main/forest-hut.png";
      #   sha256 = "12rkqy81l1q9q8kr59m1fx100p74d18gkc5cpwr6y0i66czbxmh9";
      # };
      # stylix.base16Scheme = "${inputs.base16-schemes}/onedark.yaml";
      stylix.base16Scheme = "${inputs.base16-schemes}/tomorrow-night.yaml";
      stylix.polarity = "dark";
      stylix.targets.plymouth.enable = true;
      stylix.fonts = {
        serif = {
          package = (pkgs.iosevka-bin.override { variant = "etoile"; });
          name = "Iosevka Etoile";
        };

        sansSerif = {
          package = (pkgs.iosevka-bin.override { variant = "aile"; });
          name = "Iosevka Aile";
        };

        monospace = {
          package = pkgs.my.pragmasevka;
          name = "Pragmasevka";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    }
  ]);
}
