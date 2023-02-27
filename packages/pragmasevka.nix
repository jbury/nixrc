{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "pragmasevka";
  version = "1.6.0";

  src = fetchzip {
    url = "https://github.com/shytikov/pragmasevka/releases/download/v${version}/Pragmasevka.zip";
    stripRoot = false;
    hash = "sha256-ety9HTD606IKYP1OSZZVFfgnWLNFgN0rRDTt0pWBzNk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "PragmataPro meets Iosevka";
    homepage = "https://github.com/shytikov/pragmasevka";
    license = licenses.ofl;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.all;
  };
}
