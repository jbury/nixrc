{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swaycons";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ActuallyAllie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cah0M5J6vRXn81uEK49g3r1R7TkCdojJ0bIwJ3hpG3s=";
  };

  cargoLock = let
    fixupLockFile = path: (builtins.readFile path);
  in {
    lockFileContents = fixupLockFile ./Cargo.lock;
  };

  cargoSha256 = lib.fakeHash;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [];
  propagatedBuildInputs = [];

  meta = with lib; {
    homepage = "https://github.com/ActuallyAllie/swaycons";
    description = "Window Icons in Sway with Nerd Fonts!";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jboyens ];
  };
}
