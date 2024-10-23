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
  version = "2.10.0";

  src = fetchurl {
    url = "https://vanta-agent-repo.s3.amazonaws.com/targets/versions/${version}/vanta-amd64.deb";
    sha256 = "d749eeb61526c4cd53455fbfed99418f274b272a54543f905dba613f851f3829";
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
