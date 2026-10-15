{ pkgs, ... }:

let
  user = "odinhg";
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = user;
  users.users.${user}.home = "/Users/${user}";

  # Keep this unchanged after the initial setup.
  system.stateVersion = 6;

  # Nix itself is managed by the installer, not by nix-darwin.
  # Required if you used the Determinate installer; harmless otherwise.
  nix.enable = false;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "claude-code"
    ];

  # Weekly garbage collection (nix.gc is unavailable with nix.enable = false).
  # Runs Saturday at noon, so a bad cleanup leaves Sunday to fix it.
  launchd.daemons.nh-clean = {
    path = [
      pkgs.nh
      "/nix/var/nix/profiles/default"
    ];
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.nh}/bin/nh"
        "clean"
        "all"
        "--keep-since"
        "14d"
        "--keep"
        "5"
      ];
      StartCalendarInterval = [
        {
          Weekday = 6;
          Hour = 12;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/nh-clean.log";
      StandardErrorPath = "/var/log/nh-clean.log";
    };
  };

  # Use Touch ID for sudo (handy since darwin-rebuild needs sudo).
  security.pam.services.sudo_local.touchIdAuth = true;

  # Status bar. Runs as a launchd agent, restarted if it crashes.
  services.sketchybar.enable = true;

  # Font for Ghostty. Installed system-wide.
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # macOS settings.
  system.defaults = {
    finder.AppleShowAllFiles = true;
    finder.ShowPathbar = true;
    NSGlobalDomain.AppleShowAllExtensions = true;

    # Sketchybar takes the top of the screen instead.
    NSGlobalDomain._HIHideMenuBar = true;

    # Fast key repeat, and holding a key repeats it instead of showing accents.
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;

    dock.autohide = true;
    dock.show-recents = false;
    # Keep Spaces in a fixed order (recommended by AeroSpace).
    dock.mru-spaces = false;

    trackpad.Clicking = true;
  };

  # Homebrew must be installed separately; nix-darwin only manages what it installs.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # Remove anything not listed here, including its app data.
      cleanup = "zap";
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
      "skim" # PDF viewer with SyncTeX, used by VimTeX
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
