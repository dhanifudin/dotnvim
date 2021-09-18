if exists('g:plugs["goyo.vim"]')
  nnoremap goz <cmd>Goyo<cr>

  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
endif

if exists('g:plugs["limelight.vim"]')
  let g:limelight_conceal_ctermfg = 'gray'
  let g:limelight_conceal_guifg = 'gray'
  let g:limelight_default_coefficient = 0.7
endif
