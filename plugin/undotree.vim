if exists('g:plugs["undotree"]') && has('persistent_undo')
  let target_path = expand('~/.undodir')

  if !isdirectory(target_path)
    call mkdir(target_path, "p", 0700)
  endif

  let &undodir = target_path
  set undofile
endif
