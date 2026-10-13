{ pkgs, ... }:

{
  # Apple Silicon uses aarch64-darwin.
  # Intel Macs should use x86_64-darwin.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Your short macOS username.
  system.primaryUser = "odinhg";

  # Compatibility version for nix-darwin.
  # Keep this unchanged after the initial setup.
  system.stateVersion = 6;

  # Allow the proprietary Claude Code package if needed.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "claude-code"
    ];

  # Homebrew is managed by nix-darwin.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    casks = [
      "firefox"
      "ghostty"
      "slack"
      "signal"
      "discord"
      "vlc"
    ];

    brews = [];
  };
}
