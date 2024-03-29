{ autoconf, autoconf-archive, automake, dbus, dbus-glib, docbook_xml_dtd_412
, docbook-xsl-nons, fetchFromGitHub, gtk-doc, libevdev, libtool, libxml2, xz
, pkg-config, stdenv, upower }:

stdenv.mkDerivation rec {
  pname = "thermald";
  version = "2.5.2";

  outputs = [ "out" "devdoc" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "thermal_daemon";
    rev = "v${version}";
    sha256 = "sha256-Ex3HSGJJDPPciX0Po9TpySVPUL257wz1ZjaLCa2igCM=";
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    docbook-xsl-nons
    docbook_xml_dtd_412
    gtk-doc
    libtool
    pkg-config
  ];

  buildInputs = [ dbus dbus-glib libevdev libxml2 xz upower ];

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--localstatedir=/var"
    "--enable-gtk-doc"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  preConfigure = "NO_CONFIGURE=1 ./autogen.sh";

  # patches = [ ./338.patch ];

  postInstall = ''
    cp ./data/thermal-conf.xml $out/etc/thermald/
  '';
}
