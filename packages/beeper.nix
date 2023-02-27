{ lib, stdenv, fetchurl, appimageTools }:

let
  version = "3.7.9";
in appimageTools.wrapType2 { # or wrapType1
    name = "beeper";
    src = fetchurl {
      url = "https://download.beeper.com/linux/appImage/x64";
      sha256 = "sha256-JE0C7Oobd7rj1euodrJQfTehGSblJa0892cTS24uSMU=";
    };
    extraPkgs = pkgs: with pkgs; [ ];
  meta = with lib; {
    description = "All your chats in one app.";
    homepage = https://beeper.com;
    license = licenses.free;
    maintainers = [ maintainers.jboyens ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
