{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.solokeys;
in {
  options.modules.hardware.solokeys = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.solo2-cli ];

    user.extraGroups = [ "plugdev" ];

    services.udev.extraRules = ''
      # NXP LPC55 ROM bootloader (unmodified)
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0021", TAG+="uaccess"
      # NXP LPC55 ROM bootloader (with Solo 2 VID:PID)
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b000", TAG+="uaccess"
      # Solo 2
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
      # Solo 2
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
      '';
  };
}
