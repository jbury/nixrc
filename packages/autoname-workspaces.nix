{ stdenv, lib, fetchFromGitHub, python3 }:

let
  pythonWithPackages = python3.withPackages(p: with p; [
    i3ipc
  ]);
in
stdenv.mkDerivation rec {
  pname = "autoname-workspaces";
  version = "1.8";

  src = fetchFromGitHub rec {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "sha256-r5qf50YK0Wl0gFiFdSE/J6ZU+D/Cz32u1mKzOqnIuJ0=";
  };

  buildInputs = [ pythonWithPackages ];

  installPhase = ''
    mkdir -p $out/bin
    cp contrib/autoname-workspaces.py $out/bin
  '';
}
