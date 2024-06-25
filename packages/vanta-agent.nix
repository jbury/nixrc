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
  version = "2.7.1";

  src = fetchurl {
    url = "https://vanta-agent-repo.s3.amazonaws.com/targets/versions/${version}/vanta-amd64.deb";
    sha256 = "5899df5f1510ed181c9997a2c8fb62c4e78bf724f95537ad7fd011921a090a60";
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
