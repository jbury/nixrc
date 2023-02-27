{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, vala
, vala-lint
, gettext
, appstream-glib
, desktop-file-utils
, json-glib
, wrapGAppsHook
, cairo
, glib
, gtk3
, libgee
, python3
}:

stdenv.mkDerivation rec {
  pname = "remontoire";
  version = "r2_2";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "remontoire";
    rev = version;
    sha256 = "sha256-Cb6tzTGZdQA9oA04DO/xLBw5F+FRj5BM2Aa62YWGmZA=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    pkg-config
    meson
    ninja
    vala
    vala-lint
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    cairo
    glib
    gtk3
    json-glib
    libgee
  ];

  # mesonFlags = [ "-Dprofile=default" ];

   postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = {
    homepage = "https://github.com/regolith-linux/remontoire";
    description = "Keybinding Hints";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
