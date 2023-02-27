{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, cyrus_sasl }:

stdenv.mkDerivation rec {
  pname = "cyrus-sasl-xoauth2";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "moriyoshi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lI8uKtVxrziQ8q/Ss+QTgg1xTObZUTAzjL3MYmtwyd8=";
  };

  nativeBuildInputs = [ autoconf automake libtool cyrus_sasl ];
  buildInputs = [];

  preConfigure = "./autogen.sh";
  makeFlags = [ "CYRUS_SASL_PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/moriyoshi/cyrus-sasl-xoauth2";
    description = "This is a plugin implementation of XOAUTH2.";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}