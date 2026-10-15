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
    ];

    brews = [ ];
  };

  # Make brew-installed CLI tools available. Appended after Nix paths,
  # so Nix versions win if both exist.
  environment.systemPath = [ "/opt/homebrew/bin" ];

  # Tiling window manager. Needs Accessibility permission on first start.
  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer = { left = 8; right = 8; top = 8; bottom = 8; };
      };
      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-f = "fullscreen";
        alt-slash = "layout tiles horizontal vertical";
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
      };
    };
  };
}
