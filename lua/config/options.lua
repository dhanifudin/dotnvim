local opt = vim.opt

-- WSLg should export DISPLAY=:0 for XWayland but sometimes doesn't (only
-- WAYLAND_DISPLAY survives). GTK/Wayland apps (zathura) don't care, but
-- Java AWT/Swing (:MavenRun on a Swing project) is X11-only and needs it.
-- Fixed at the nvim-process level, not in shell dotfiles: :Maven/:MavenRun
-- (config/runner.lua) spawn vim.o.shell directly (bash on this profile),
-- which never sources zsh's .zshenv — but every child process, regardless
-- of shell, inherits vim.env.
if vim.fn.has("wsl") == 1 and vim.env.DISPLAY == nil then
  vim.env.DISPLAY = ":0"
  -- Weston's RAIL shell doesn't reparent; without this Swing windows can
  -- render blank/gray on WSLg.
  vim.env._JAVA_AWT_WM_NONREPARENTING = "1"
end

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Sign column + cursor
opt.signcolumn = "yes"
opt.cursorline = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Scroll
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Terminal colors
opt.termguicolors = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Mouse
opt.mouse = "a"

-- UI
opt.showmode = false
opt.fillchars = { eob = " " }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
