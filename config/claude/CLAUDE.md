# Personal preferences

- macOS managed with nix-darwin + home-manager. The repo lives at `~/.config/nix-darwin`; dotfiles are in `config/` and linked from `home.nix`.
- Install tools declaratively in `home.nix`, not with brew or `npm -g`. Rebuild with `rebuild`, but don't run it unless asked.
- Don't commit unless asked.
- Don't read or edit credential files (`~/.ssh`, `~/.config/gh/hosts.yml`, `~/.config/github-copilot`).
