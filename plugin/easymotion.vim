if exists('g:plugs["vim-easymotion"]')
  let g:EasyMotion_do_mapping=0
  let g:EasyMotion_smartcase=1
  nmap s <Plug>(easymotion-overwin-f)
  map / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)
  nmap gj <Plug>(easymotion-j)
  nmap gk <Plug>(easymotion-k)
endif
