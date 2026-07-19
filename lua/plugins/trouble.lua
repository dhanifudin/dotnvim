return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                    desc = "Diagnostics (workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",       desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",            desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                        desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                         desc = "Quickfix list" },
    },
  },
}
