{ config, pkgs, ... }:

let
  # Config folders in the repo are linked straight into ~/.config,
  # so edits take effect immediately (no rebuild needed).
  dotfiles = "${config.home.homeDirectory}/.config/nix-darwin/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
in
{
  home.username = "odinhg";
  home.homeDirectory = "/Users/odinhg";

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
    just
    go-task      # the `task` command
    azure-cli
    tinymist     # Typst language server

    # Neovim and its language servers
    neovim
    tree-sitter  # builds Treesitter parsers
    nodejs       # for Copilot
    harper       # grammar and spelling
    pyright
    ruff

    # LaTeX
    texliveSmall
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    ignores = [ ".DS_Store" ".direnv/" ];
    settings = {
      user.name = "Odin Hoff Gardå";
      user.email = "odin.hoff.garda@proton.me";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Neovim config lives in config/nvim (linked at the bottom).
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Tab completion: arrow-key menu, case-insensitive matching.
    initContent = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';

    shellAliases = {
      l = "eza -l";
      ll = "eza -lah";
      c = "clear";
      vim = "nvim";
      cat = "bat";
      grep = "rg";
      rebuild = "nh darwin switch -H Odins-MacBook-Pro";
    };
  };

  # Nix helper: `nh search`, `nh darwin switch`, `nh clean`.
  programs.nh = {
    enable = true;
    flake = "/Users/odinhg/.config/nix-darwin";

  };

  # Hooks into zsh automatically.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Ctrl-R history search and Ctrl-T file search. Hooks into zsh automatically.
  programs.fzf.enable = true;

  # Terminal file manager. Use `y` to open it; you end up in the folder you quit in.
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  # Dotfiles from ~/nix-darwin/config
  xdg.configFile."nvim".source = link "nvim";
  xdg.configFile."ghostty".source = link "ghostty";
}
