{ lib, python3, netcat-openbsd, nix-update-script }:

let
in
python3.pkgs.buildPythonApplication rec {
  pname = "flashfocus";
  version = "2.3.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-XT3CKJWn1uKnPPsJC+MWlEAd8sWdVTEXz5b3n0UUedY=";
  };

  postPatch = ''
    substituteInPlace bin/nc_flash_window \
      --replace "nc" "${lib.getExe netcat-openbsd}"
  '';

  nativeBuildInputs = with python3.pkgs; [
    pytest-runner
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    i3ipc
    (xcffib.overrideAttrs (_: {
      doCheck = false;
      checkPhase = ''true'';
    }))
    click
    cffi
    (xpybutil.override {
      xcffib = (xcffib.overrideAttrs (_: {
        doCheck = false;
        checkPhase = ''true'';
      }));
    })
    marshmallow
    pyyaml
  ];

  pythonRelaxDeps = [
    "xcffib"
    "pyyaml"
  ];

  # Tests require access to a X session
  doCheck = false;

  pythonImportsCheck = [ "flashfocus" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/fennerm/flashfocus";
    description = "Simple focus animations for tiling window managers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
