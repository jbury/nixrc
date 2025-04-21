{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  wsl.enable = true;
  wsl.defaultUser = "jbury";
  wsl.wslConf = {
    interop.enabled = false;
    interop.appendWindowsPath = false;
    network.hostname = "oswald";
  };

  # It's dangerous to pull yourself up by your bootstraps alone, take these:
  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    ripgrep
    bind
    cached-nix-shell
    pciutils
    gnumake
    unzip
    wget
    cacert
    nh
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

