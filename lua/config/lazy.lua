-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "ErrorMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local minimal = vim.g.dotnvim_minimal

-- Minimal profile: only these plugin files (no treesitter, LSP/Mason,
-- completion, markdown render, noice, trouble, git, tmux).
local minimal_specs = {
  "ai", "colorscheme", "editing", "navigation", "snacks", "statusline", "telescope", "whichkey", "vscode",
}

-- Full profile: keep the lockfile next to the config when that dir is writable
-- (plain clone). Under Nix, ~/.config/nvim is a symlink into the read-only
-- store, so fall back to stdpath("data"); the Nix module seeds it from the
-- tracked lazy-lock.json on activation.
-- Minimal profile: always stdpath("data"), so a minimal run never rewrites the
-- tracked full lockfile down to its subset; seed it from the tracked file once.
local lockfile
if not minimal and vim.fn.filewritable(vim.fn.stdpath("config")) == 2 then
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
else
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json"
  local tracked = vim.fn.stdpath("config") .. "/lazy-lock.json"
  if minimal and vim.fn.filereadable(lockfile) == 0 and vim.fn.filereadable(tracked) == 1 then
    vim.fn.mkdir(vim.fn.stdpath("data"), "p")
    vim.fn.writefile(vim.fn.readfile(tracked), lockfile)
  end
end

local spec = { { import = "plugins" } }
if minimal then
  spec = vim.tbl_map(function(name) return { import = "plugins." .. name } end, minimal_specs)
end

require("lazy").setup({
  lockfile = lockfile,
  spec = spec,
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "catppuccin", "habamax" },
  },
  checker = {
    enabled = true,
    notify = false,
    frequency = 86400,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
