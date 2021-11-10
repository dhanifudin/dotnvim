if has('mac') || ($ITERM_PROFILE == 'Dark')
  set background=dark
else
  set background=light
endif

try
  let g:gruvbox_italic='1'
  colorscheme gruvbox
catch
  colorscheme desert
endtry
