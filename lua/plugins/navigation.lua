-- File extensions better handled by the system default app. vim.ui.open (used by
-- oil's open_external) shells out to xdg-open, which honors the system's XDG MIME
-- defaults (images, media, office). xdg-open may have no pdf default (e.g. on
-- WSL), so pdf is handled directly below (zathura) to work everywhere.
local external_ext = {
  -- documents
  pdf = true, doc = true, docx = true, rtf = true, odt = true,
  xls = true, xlsx = true, ods = true, ppt = true, pptx = true, odp = true,
  -- images
  png = true, jpg = true, jpeg = true, gif = true, webp = true, bmp = true,
  tiff = true, svg = true, avif = true, heif = true,
  -- audio / video
  mp4 = true, mkv = true, webm = true, avi = true, mov = true,
  mp3 = true, flac = true, wav = true, ogg = true, opus = true, m4a = true,
}

-- Enter on a file: open external types in their system app, otherwise open in nvim.
local function oil_open()
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  if entry and entry.type == "file" then
    local ext = entry.name:match("%.([%w]+)$")
    ext = ext and ext:lower()
    if ext == "pdf" and vim.fn.executable("zathura") == 1 then
      local dir = oil.get_current_dir()
      vim.system({ "zathura", dir .. entry.name }, { detach = true })
      return
    end
    if ext and external_ext[ext] then
      require("oil.actions").open_external.callback()
      return
    end
  end
  require("oil.actions").select.callback()
end

return {
  -- Flash.nvim - fast motion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "o" }, desc = "Flash treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Flash remote" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Flash treesitter search" },
    },
  },

  -- Oil.nvim - file explorer as buffer
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-mini/mini.icons" },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" },
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<CR>"] = { callback = oil_open, desc = "Open (external app for docs/media)" },
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-r>"] = "actions.refresh",
        ["g."] = "actions.toggle_hidden",
        ["g?"] = "actions.show_help",
        ["gx"] = "actions.open_external",
      },
      use_default_keymaps = false,
    },
  },
}
