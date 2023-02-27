{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gorename-unstable";
  version = "2021-08-19";
  rev = "bf6c7f26e9f0fea5b256f9ef6968435dddc5be25";

  src = fetchgit {
    inherit rev;

    url = "https://go.googlesource.com/tools";
    sha256 = "MQLY4w0NxeXLVA8M0KmplG78jZIqlHD1bwRDLpAU9CY=";
  };

  vendorSha256 = "60w8MPUN1hRveLmo3xQYcI52EVc82oSVw4EurORHVJE=";

  doCheck = false;

  subPackages = [ "cmd/gorename" ];

  meta = with lib; {
    description = "gorename";
    homepage = "https://go.googlesource.com/tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jboyens ];
  };
}
