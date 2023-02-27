{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-0XTNkpsyj8y5MHW8fQl1rK+kgWlXpCwDC+YIOH5W05A=";
  };

  vendorSha256 = "sha256-0OWCVoGS1pluDPaRRGm/dOlTs/izd15/Hq4SvohCXiI=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
