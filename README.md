# dotfiles-macos

This is my Mac setup. It uses nix-darwin and Home Manager, so apps, settings and dotfiles all live here, and `rebuild` puts them in place.

## Layout

- `flake.nix` pins the inputs and defines the machine (`Odins-MacBook-Pro`).
- `configuration.nix` has the system stuff: macOS settings, Homebrew apps, fonts, Touch ID for sudo, Sketchybar and a weekly cleanup of the Nix store.
- `home.nix` has my user setup: CLI tools, git, zsh and so on.
- `config/` has the dotfiles for Neovim, Ghostty, AeroSpace and Sketchybar.

The folders in `config/` are symlinked into `~/.config`, so I can edit them and see the result right away, without rebuilding. Neovim has its own [README](config/nvim/README.md).

CLI tools come from Nix. GUI apps come from Homebrew, but the list is kept in `configuration.nix`, and anything I install outside that list gets removed on the next rebuild.

AeroSpace keeps apps on fixed workspaces (`Alt+1` to `Alt+5`): terminal on 1, browser on 2, chat on 3, Office and meetings on 4, music and video on 5.

## Commands I use

```sh
rebuild            # apply changes
nix flake update   # update everything, then rebuild
nix fmt            # format the .nix files
nh clean all       # free up space (also runs on its own every Saturday)
```

## Setting up a new Mac

1. Install Nix with the Determinate installer:
   ```sh
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   ```
2. Install Homebrew:
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Clone the repo. It has to go in `~/.config/nix-darwin`, because the symlinks point there.
   ```sh
   git clone https://github.com/odinhg/dotfiles-macos.git ~/.config/nix-darwin
   ```
4. The username (`odinhg`) and hostname (`Odins-MacBook-Pro`) are hardcoded. On a different machine, change them in `flake.nix`, `configuration.nix` and `home.nix`. `scutil --get LocalHostName` shows the hostname.
5. Do the first build. `rebuild` doesn't exist yet, so run nix-darwin directly:
   ```sh
   sudo nix run nix-darwin -- switch --flake ~/.config/nix-darwin#Odins-MacBook-Pro
   ```
6. Open a new terminal. After this, `rebuild` works.
7. Log out and back in so the macOS settings apply. Then start AeroSpace and give it Accessibility access.

## Backlog

- Linux support. The idea is to split `home.nix` into a shared part and a Mac-only part, so the CLI tools and dotfiles work on Linux too.
