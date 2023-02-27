{ stdenv, lib, buildGo119Module, fetchFromGitHub }:

buildGo119Module rec {
  pname = "grizzly";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grizzly";
    rev = "v${version}";
    sha256 = "sha256-6z/6QZlCm4mRMKAVzLnOokv8ib7Y/7a17ojjMfeoJ4w=";
  };

  vendorSha256 = "sha256-DDYhdRPcD5hfSW9nRmCWpsrVmIEU1sBoVvFz5Begx8w=";

  CGO_ENABLED = 0;

  doCheck = false;

  meta = with lib; {
    description = "A utility for managing various observability resources with Jsonnet";
    homepage = https://github.com/grafana/grizzly;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
