{ stdenv, lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "swaywindow";
  version = "0.0.1";

  src = fetchgit {
    url = "https://git.sr.ht/~jboyens/swaywindow";
    rev = "v${version}";
    sha256 = "sha256-sBmPCoRB5TGLnUfQ3o1ZO1iPfVhVRTnTonEL0AJFaYU=";
  };

  vendorSha256 = "sha256-x/bIRIMscQKwIeTelrxHvayAtxQr+Ftxtd64BpwcNOA=";

  meta = with lib; {
    description = "A hacky thing that does some aspects of xprop, xdotool, etc. for SwayWM";
    homepage = https://sr.ht/~jboyens/swaywindow;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
