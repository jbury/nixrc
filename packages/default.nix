{ pkgs ? import <nixpkgs> {} }:

with pkgs;
{
  aerc = (callPackage ./aerc {});
  autoname-workspaces = (callPackage ./autoname-workspaces.nix {});
  beeper = (callPackage ./beeper.nix {});
  cyrus-sasl-xoauth2 = (callPackage ./cyrus-sasl-xoauth2.nix {});
  flashfocus = (callPackage ./flashfocus.nix {});
  fuzzel = (callPackage ./fuzzel {});
  godoc = (callPackage ./godoc.nix { });
  google-cloud-sdk-gke-gclound-auth-plugin = (callPackage ./google-cloud-sdk-gke-gclound-auth-plugin.nix { });
  gorename = (callPackage ./gorename.nix { });
  grizzly = (callPackage ./grizzly.nix { });
  guru = (callPackage ./guru.nix { });
  kustomize = (callPackage ./kustomize.nix { });
  min = (callPackage ./min.nix {});
  pizauth = (callPackage ./pizauth.nix { });
  pragmasevka = (callPackage ./pragmasevka.nix { });
  powerctl = (callPackage ./powerctl.nix {});
  remontoire = (callPackage ./remontoire.nix { });
  sloth = (callPackage ./sloth.nix { });
  swaycons = (callPackage ./swaycons { });
  testkube = (callPackage ./testkube.nix {});
  tilt = (callPackage ./tilt.nix {});
  thermald = (callPackage ./thermald {});
}
