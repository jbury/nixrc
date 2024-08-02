{ config, pkgs, ... }: {
  home-manager.users.${config.user.name}.xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
  };

  # config = {
  #   xdg.portal = {
  #     enable = true;
  #     wlr.enable = true;

  #   };
  # };
}
