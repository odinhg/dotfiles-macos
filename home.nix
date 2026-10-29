{ config, pkgs, ... }:

let
  # Config folders in the repo are linked straight into ~/.config,
  # so edits take effect immediately (no rebuild needed).
  dotfiles = "${config.home.homeDirectory}/.config/nix-darwin/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
in
{
  home.username = "odinhg";
  home.homeDirectory = "/Users/${config.home.username}";

  # Keep this fixed after the initial setup.
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # AI coding tools
    opencode
    claude-code
    openspec

    # Local LLMs (run on demand, no background service)
    llama-cpp # llama-cli, llama-server (Metal)

    # Terminal tools
    tmux
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
    go-task # the `task` command
    # azure-cli # add when fabric bug is fixed
    tinymist # Typst language server
    hugo
    pandoc

    # Neovim and its language servers
    neovim
    tree-sitter # builds Treesitter parsers
    nodejs # for Copilot
    harper # grammar and spelling
    pyright
    ruff

    # LaTeX
    texliveFull

    # Fonts
    libertine
    monoid
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".direnv/"
    ];
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
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
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
      rebuild = "nh darwin switch -H Odins-MacBook-Pro";

      # MLX via uvx: the nixpkgs mlx is built without Metal (CPU only).
      mlx-chat = "uvx --from mlx-lm mlx_lm.chat";
      mlx-server = "uvx --from mlx-lm mlx_lm.server";
    };
  };

  # Nix helper: `nh search`, `nh darwin switch`, `nh clean`.
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/.config/nix-darwin";
  };

  # Hooks into zsh automatically.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Ctrl-R history search and Ctrl-T file search. Hooks into zsh automatically.
  programs.fzf.enable = true;

  # Prompt. Config lives in config/starship.toml (linked at the bottom).
  programs.starship.enable = true;

  # Terminal file manager. Use `y` to open it; you end up in the folder you quit in.
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  # Dotfiles from ~/nix-darwin/config
  xdg.configFile."nvim".source = link "nvim";
  xdg.configFile."ghostty".source = link "ghostty";
  xdg.configFile."aerospace".source = link "aerospace";
  xdg.configFile."sketchybar".source = link "sketchybar";
  xdg.configFile."tmux".source = link "tmux";
  xdg.configFile."opencode/tui.json".source = link "opencode/tui.json";
  xdg.configFile."htop/htoprc".source = link "htop/htoprc";
  xdg.configFile."gh/config.yml".source = link "gh/config.yml";
  home.file.".claude/settings.json".source = link "claude/settings.json";
  home.file.".claude/CLAUDE.md".source = link "claude/CLAUDE.md";
  home.file.".claude/statusline.sh".source = link "claude/statusline.sh";
  xdg.configFile."starship.toml".source = link "starship.toml";
}
