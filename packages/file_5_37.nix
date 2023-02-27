{ lib, stdenv, fetchurl, file, zlib }:

stdenv.mkDerivation rec {
  pname = "file";
  version = "5.37";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${pname}-${version}.tar.gz"
      "https://distfiles.macports.org/file/${pname}-${version}.tar.gz"
    ];
    sha256 = "6cE5Z/fdM5o8JBt3ELoJNWC5ozATSRMY6I5ri1e64H8=";
  };

  nativeBuildInputs = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) file;
  buildInputs = [ zlib ];

  doCheck = true;

  makeFlags = lib.optional stdenv.hostPlatform.isWindows "FILE_COMPILE=file";

  meta = with lib; {
    homepage = "https://darwinsys.com/file";
    description = "A program that shows the type of files";
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
