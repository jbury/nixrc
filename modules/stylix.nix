{ pkgs, ... }:

let schemeName = "tokyo-city-terminal-dark.yaml";
in {
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${schemeName}";
  };
}
