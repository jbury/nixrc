{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.printing;
in {
  options.modules.services.printing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.system-config-printer.enable = true;

    services.printing = {
      enable = true;
    };

    hardware.printers = {
      ensureDefaultPrinter = "HLL2350DW";
      ensurePrinters = [{
        name = "HLL2350DW";
        deviceUri = "ipp://192.168.86.39";
        model = "everywhere";
        ppdOptions = {
          PageSize = "Letter";
          Duplex = "DuplexNoTumble";
        };
      }];
    };
  };
}
