{
  description = "dotnvim: Neovim configuration (plain clone or Nix/home-manager)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    # home-manager module: installs neovim + runtime deps and links
    # ~/.config/nvim to this repo.
    homeManagerModules.default = { pkgs, config, lib, ... }: {
      # Plain packages (not programs.neovim) so home-manager does NOT manage
      # ~/.config/nvim/init.lua, which would force a real directory and block
      # the symlink below.
      home.packages = with pkgs; [
        neovim
        ripgrep fd     # telescope.nvim
        gcc            # nvim-treesitter parser compilation
        nodejs         # Mason LSP installs
        tree-sitter    # treesitter CLI
        unzip          # Mason archive extraction
      ];

      xdg.enable = true;

      # Symlink ~/.config/nvim -> this flake source at activation time.
      # Self-healing: replaces a stale directory or wrong symlink.
      home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        nvim_target="${self}"
        nvim_link="${config.home.homeDirectory}/.config/nvim"
        $DRY_RUN_CMD mkdir -p "$(${pkgs.coreutils}/bin/dirname "$nvim_link")"

        if [ -L "$nvim_link" ] && [ "$(${pkgs.coreutils}/bin/readlink "$nvim_link")" = "$nvim_target" ]; then
          $VERBOSE_ECHO "Nvim config symlink already correct"
        else
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm -rf "$nvim_link"
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln -s "$nvim_target" "$nvim_link"
        fi

        # The store is read-only, so lazy.nvim keeps its lockfile in
        # stdpath("data"). Seed it from the tracked lazy-lock.json; after
        # ":Lazy update" copy the updated file back into the repo manually.
        lock_dest="${config.home.homeDirectory}/.local/share/nvim/lazy-lock.json"
        $DRY_RUN_CMD mkdir -p "$(${pkgs.coreutils}/bin/dirname "$lock_dest")"
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 644 "${self}/lazy-lock.json" "$lock_dest"
      '';
    };
  };
}
