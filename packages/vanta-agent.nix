{ stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, zlib
, ...
}:

stdenv.mkDerivation rec {
  # Version and SHA can be found at https://raw.githubusercontent.com/VantaInc/vanta-agent-scripts/main/install-linux.sh
  pname = "vanta-agent";
  version = "2.11.0";

  src = fetchurl {
    url = "https://vanta-agent-repo.s3.amazonaws.com/targets/versions/${version}/vanta-amd64.deb";
    sha256 = "8763c60427111fc84a20662c92aa3b80b35b01825108220b24653e4d25e39d26";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  sourceRoot = ".";
  unpackCmd = ''dpkg-deb -x "$src" .'';

  dontBuild = true;

  # 
  installPhase = ''
    mkdir -p $out
    cp -a var usr/share/ $out

    mkdir -p $out/bin/;
    cp var/vanta/* $out/bin/
  '';
}
