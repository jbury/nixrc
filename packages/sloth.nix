{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sloth";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "sloth";
    rev = "v${version}";
    sha256 = "sha256-KMVD7uH3Yg9ThnwKKzo6jom0ctFywt2vu7kNdfjiMCs=";
  };

  vendorSha256 = "sha256-j6qXUQ/Tu3VNQL5xBOHloRn5DH3KG/znCLi1s8RIoL8=";

  subPackages = ["cmd/sloth"];

  doCheck = false;

  meta = with lib; {
    description = "Easy and simple Prometheus SLO generator";

    homepage = https://sloth.dev;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
