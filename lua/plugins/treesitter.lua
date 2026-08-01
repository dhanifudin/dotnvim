-- nvim-treesitter v1: pure parser manager
-- configs.lua is gone; setup() only accepts install_dir
-- Highlighting via Neovim's native vim.treesitter.start()
-- Indentation via nvim-treesitter.indent module

local parsers = {
  "typescript", "tsx", "javascript", "vue", "php", "go", "rust",
  "java",
  "yaml", "json", "jsonc", "html", "css", "lua", "bash", "markdown",
  "markdown_inline", "toml", "dockerfile", "vim", "vimdoc", "regex",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy", "BufReadPost", "BufNewFile" },
    config = function()
      -- Install missing parsers (async, shows progress only on first run)
      -- nvim-treesitter main-branch (v1) API: modules .info and .install are gone;
      -- all public functions now live on the top-level require("nvim-treesitter").
      local ts = require("nvim-treesitter")
      local installed = {}
      for _, p in ipairs(ts.get_installed()) do
        installed[p] = true
      end
      local missing = vim.tbl_filter(function(p) return not installed[p] end, parsers)
      if #missing > 0 then
        ts.install(missing)
      end

      -- Enable highlighting + indentation per filetype via FileType autocmd
      -- pcall: silently skips filetypes with no available parser
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim_treesitter", { clear = true }),
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if ok then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Treesitter-powered text objects (af/if function, ac/ic class).
  -- Complements the custom iv/av variable-segment objects in util/variable_segment.lua.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "VeryLazy", "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
      })

      local select = require("nvim-treesitter-textobjects.select").select_textobject
      local map = function(lhs, query, desc)
        vim.keymap.set({ "x", "o" }, lhs, function()
          select(query, "textobjects")
        end, { desc = desc })
      end

      map("af", "@function.outer", "Around function")
      map("if", "@function.inner", "Inner function")
      map("ac", "@class.outer",    "Around class")
      map("ic", "@class.inner",    "Inner class")
    end,
  },
}
