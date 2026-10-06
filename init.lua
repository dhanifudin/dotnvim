-- Set leader keys before lazy.nvim loads (required)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Minimal profile: plain editing + AI CLIs, no treesitter/LSP/native builds.
-- Default on native Windows; DOTNVIM_MINIMAL=1 forces it on any OS.
vim.g.dotnvim_minimal = vim.fn.has("win32") == 1 or vim.env.DOTNVIM_MINIMAL == "1"

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
if not vim.g.dotnvim_minimal then
  require("config.runner")
end
