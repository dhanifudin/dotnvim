require("telescope").load_extension "file_browser"

vim.api.nvim_set_keymap(
  "n",
  "goF",
  "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
  {noremap = true}
)
