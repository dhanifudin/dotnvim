if has('mac') || ($ITERM_PROFILE == 'Light')
  set background=light
else
  set background=dark
endif

try
  let g:gruvbox_italic='1'
  colorscheme gruvbox
catch
  colorscheme desert
endtry
