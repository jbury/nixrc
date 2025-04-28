{ ... }: {
  imports = [
    ../wslHost.nix
  ];

  hostSettings = {
    email = "jason.bury@docusign.com";
  };

  ## Modules
  modules = {
    dev = {
      cloud.enable = true;
      cloud.aws.enable = true;
      cloud.azure.enable = true;
      go.enable = true;
      shell.enable = true;
    };
    editors = {
      emacs.enable = true;
      vim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      utils.enable = true;
      zsh.enable = true;
    };
    services = {
      docker.enable = true;
    };
    stylix.enable = true;
  };
}
