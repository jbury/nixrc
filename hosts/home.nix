{ config, lib, ... }:

with builtins;
with lib;
let
  blocklist =
    fetchurl "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
in {
  networking.extraHosts = ''
    192.168.86.1  router.home

    # Hosts
    192.168.86.76	kitt
    192.168.86.100	irongiant
    192.168.86.161	avocado
    192.168.86.96	wall-e
    192.168.86.34	mediaserver nas backup-host
    192.168.49.2	dev dev.fooninja.org
    127.0.0.1	    api.local.flexe.com
    172.19.0.3	    hydra.localhost hydra-admin.localhost api.local.flexe.com
    192.168.1.240	argocd.fooninja.org
    192.168.1.240	apps.fooninja.org

    # Block garbage
  '';
  # ${readFile blocklist}

  ## Location config -- since Seattle is my 127.0.0.1
  time.timeZone = mkDefault "America/Los_Angeles";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = (if config.time.timeZone == "America/Los_Angeles" then {
    latitude = 47.6062;
    longitude = -122.3321;
  } else
    { });

  # So the vaultwarden CLI knows where to find my server.
  modules.shell.vaultwarden.config.server = "bw.fooninja.org";

  services.syncthing = {
    # Purge folders not declaratively configured!
    overrideFolders = true;
    overrideDevices = true;
    devices = {
      mediaserver.id =
        "L5ZEYSY-NVT73GS-NAD36HV-AO3YJZQ-H53QRJ7-3XVXO5X-PXA2QWN-3J6DQAC";
      kitt.id =
        "Z6KVBYP-VAKL7WV-GQECKAS-FU23XXB-Q5G2RR3-3JQHCHY-BLGK4UM-B3OETA2";
      pixel6pro.id =
        "PIANTRI-R5C7T2F-LSNXDFX-U6TDRJT-TU4P3PU-N7C7WV7-KAPFNPG-62WLNQT";
      irongiant.id =
        "FEEF2M2-B3JYJJX-IHFFP5A-2ZTIGFD-YISKNNB-5G3RML6-ASOG6DB-HSXYKQR";
    };
    folders = let
      mkShare = devices: type: paths: attrs:
        (rec {
          inherit devices type;
          path = if lib.isAttrs paths then
            paths."${config.networking.hostName}"
          else
            paths;
          watch = false;
          rescanInterval = 3600; # every hour
          enable = lib.elem config.networking.hostName devices;
        } // attrs);
    in {
      documents =
        mkShare [ "mediaserver" "kitt" "pixel6pro" "irongiant" ] "sendreceive"
        "${config.user.home}/Documents" {
          watch = true;
          rescanInterval = 300;
        }; # every 5 minutes
      secrets = mkShare [ "mediaserver" "kitt" "irongiant" ] "sendreceive"
        "${config.user.home}/.secrets" {
          watch = true;
          rescanInterval = 3600;
        }; # every hour
    };
  };
}
