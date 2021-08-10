if exists('g:plugs["telescope.nvim"]')
  nnoremap gof <cmd>Telescope find_files<cr>
  nnoremap goF <cmd>Telescope file_browser<cr>
  nnoremap gog <cmd>Telescope live_grep<cr>
  nnoremap goG <cmd>Telescope git_stash<cr>
  nnoremap goc <cmd>Telescope command_history<cr>
  nnoremap gob <cmd>Telescope buffers<cr>
  nnoremap got <cmd>Telescope treesitter<cr>
  nnoremap goT <cmd>Telescope tags<cr>
endif
