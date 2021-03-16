if exists('g:plugs["vim-yoink"]')
  let g:yoinkIncludeDeleteOperations=1

  nmap [y <plug>(YoinkRotateBack)
  nmap ]y <plug>(YoinkRotateForward)
endif
