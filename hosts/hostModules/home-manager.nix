{ lib, config, ... }:

let inherit (lib) mkDefault;
in {
  home-manager = {
    useGlobalPkgs = true;

    # I don't currently have any use for nixos-rebuild build-vm, so /etc/profiles isn't needed
    useUserPackages = false;
  };

  home = {
    stateVersion = "config.system.stateVersion";
  };

  time.timeZone = mkDefault "America/Los_Angeles";

  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
