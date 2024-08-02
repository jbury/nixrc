{ config, ... }: {
  config = {
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      wlr.enable = true;
    };
  };
}
