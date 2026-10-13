{ pkgs, ... }:

{
  home.username = "odinhg";
  home.homeDirectory = "/Users/odinhg";

  # Home Manager compatibility version.
  # Keep this fixed after the initial setup.
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # AI coding tools
    opencode
    claude-code

    # Terminal tools
    htop
    ripgrep
    fd
    fzf
    bat
    eza
    jq
    tree
    wget
    unzip
    zip

    # Development
    uv
    typst
    gh
    lazygit
    direnv
    just

    # LaTeX
    texlive.combined.scheme-small
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;

    settings = {
      user.name = "Odin Hoff Gardå";
      user.email = "odin.hoff.garda@proton.me";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "eza -lah";
      cat = "bat";
      grep = "rg";
    };

    initContent = ''
      eval "$(direnv hook zsh)"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
