if exists('g:plugs["coc.nvim"]')
  let g:coc_global_extensions = [
        \'coc-emmet',
        \'coc-explorer',
        \'coc-flutter-tools',
        \'coc-git',
        \'coc-go',
        \'coc-highlight',
        \'coc-json',
        \'coc-markdownlint',
        \'coc-pairs',
        \'coc-phpls',
        \'coc-python',
        \'coc-prettier',
        \'coc-snippets',
        \'coc-tsserver',
        \'coc-yaml',
        \'coc-vetur',
        \'https://github.com/h4kst3r/php-awesome-snippets',
        \'https://github.com/xabikos/vscode-javascript'
        \]

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'
endif
