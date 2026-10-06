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

require("lazy").setup({
  -- Keep the lockfile next to the config when that dir is writable (plain
  -- clone). Under Nix, ~/.config/nvim is a symlink into the read-only store,
  -- so fall back to stdpath("data"); the Nix module seeds it from the tracked
  -- lazy-lock.json on activation.
  lockfile = vim.fn.filewritable(vim.fn.stdpath("config")) == 2
      and vim.fn.stdpath("config") .. "/lazy-lock.json"
    or vim.fn.stdpath("data") .. "/lazy-lock.json",
  spec = {
    { import = "plugins" },
  },
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
