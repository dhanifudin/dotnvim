# dotnvim

Neovim configuration (lazy.nvim + Mason). Works with or without Nix.

## Profiles

| Profile | When | Includes |
|---|---|---|
| **full** | default on Linux, WSL, macOS (and Nix) | everything: treesitter, LSP/Mason, completion, formatting/linting, markdown rendering, git, noice, trouble, tmux integration, build runner (`:Make`, `:Maven`, ...) |
| **minimal** | default on native Windows, or `DOTNVIM_MINIMAL=1` on any OS | simple editing and AI CLIs only: oil, flash, telescope (Lua sorter), which-key, statusline, mini.pairs/surround, snacks, sidekick (`<leader>a*`) |

The minimal profile skips everything that leans on Unix tooling (treesitter parsers,
Mason servers, native builds, the runner) and keeps its lockfile in `stdpath("data")`.
Select it with `vim.g.dotnvim_minimal`, set in `init.lua` (e.g. `DOTNVIM_MINIMAL=1 nvim`).
Which plugin files each profile loads is listed in `lua/config/lazy.lua`.

## Without Nix

Prerequisites: Neovim >= 0.11, git, ripgrep, fd, gcc, node/npm, tree-sitter CLI, unzip.
Optional: java + maven (Java runner/jdtls), zathura (pdf), imagemagick, ghostscript,
mermaid-cli, lua5.1 + luarocks, python3.

```sh
git clone https://github.com/dhanifudin/dotnvim ~/.config/nvim
nvim   # lazy.nvim bootstraps and installs plugins on first start
```

The lockfile (`lazy-lock.json`) lives in the repo, so `:Lazy update` changes it in place.

## Windows (minimal)

On native Windows the config runs a minimal profile meant for simple edits and calling AI
CLIs (sidekick). It skips everything that leans on Unix tooling: treesitter, LSP/Mason,
completion, markdown rendering, the build runner and native plugin builds. It still has
oil, flash, telescope (Lua sorter), which-key, the statusline and the AI CLI toggles
(`<leader>a*`). `pwsh` is used as the shell when installed, otherwise cmd.exe.

```powershell
winget install Neovim.Neovim Git.Git Microsoft.PowerShell BurntSushi.ripgrep.MSVC sharkdp.fd
git clone https://github.com/dhanifudin/dotnvim $env:LOCALAPPDATA\nvim
nvim
```

Plugins live in `%LOCALAPPDATA%\nvim-data`. See [Profiles](#profiles).

## With Nix (home-manager)

```nix
# flake.nix
inputs.dotnvim = {
  url = "github:dhanifudin/dotnvim";
  inputs.nixpkgs.follows = "nixpkgs";
};

# home-manager modules
imports = [ dotnvim.homeManagerModules.default ];
```

The module installs neovim and its runtime deps and symlinks `~/.config/nvim` to the
flake source. Because the store is read-only, lazy.nvim keeps its lockfile in
`~/.local/share/nvim/lazy-lock.json`, seeded from the tracked file on each activation.
After `:Lazy update`, copy that file back into this repo and commit.

Local iteration from a checkout:
`--override-input dotnvim path:$HOME/Workspaces/dhanifudin/dotnvim`.
