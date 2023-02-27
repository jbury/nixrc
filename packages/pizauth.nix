{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-+Uc6es9NBtE43ehHrnfvPJ4M3WnIZY9B0ZE/MypL3tA=";
  };

  cargoSha256 = "sha256-p3nxZUHeXiQDjYO79lAgTXcSjd/UqaRKzJE8h9MTJe8=";

  meta = with lib; {
    description = "pizauth is a simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
  };
}