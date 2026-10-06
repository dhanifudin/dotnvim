# dotnvim

Neovim configuration (lazy.nvim + Mason). Works with or without Nix.

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

Plugins live in `%LOCALAPPDATA%\nvim-data`. Set `DOTNVIM_MINIMAL=1` to use the same
minimal profile on any other OS.

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
