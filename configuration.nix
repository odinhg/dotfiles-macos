{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "odinhg";
  users.users.odinhg.home = "/Users/odinhg";

  # Keep this unchanged after the initial setup.
  system.stateVersion = 6;

  # Nix itself is managed by the installer, not by nix-darwin.
  # Required if you used the Determinate installer; harmless otherwise.
  nix.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "claude-code"
    ];

  # Use Touch ID for sudo (handy since darwin-rebuild needs sudo).
  security.pam.services.sudo_local.touchIdAuth = true;

  # Font for Ghostty. Installed system-wide.
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # macOS settings.
  system.defaults = {
    finder.AppleShowAllFiles = true;
    finder.ShowPathbar = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # Homebrew must be installed separately; nix-darwin only manages what it installs.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # Switch to "zap" later to remove anything not listed here.
      cleanup = "none";
    };

    casks = [
      "firefox"
      "ghostty"
      "slack"
      "signal"
      "discord"
      "vlc"
      "spotify"
      "citrix-workspace"
      "skim"  # PDF viewer with SyncTeX, used by VimTeX
      "microsoft-excel"
      "microsoft-word"
      "microsoft-powerpoint"
      "microsoft-teams"
      "microsoft-outlook"
      "bitwarden"
      "nikitabobko/tap/aerospace"
      "zoom"
    ];

    brews = [ ];
    taps = [ "nikitabobko/tap" ];
  };

  # Make brew-installed CLI tools available. Appended after Nix paths,
  # so Nix versions win if both exist.
  environment.systemPath = [ "/opt/homebrew/bin" ];
}
