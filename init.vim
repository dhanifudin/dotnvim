if empty(glob('~/.config/nvim/autoload/plug.vim'))
	echo 'Installing vim-plug...'
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	echo 'Run :PlugInstall to install plugins'
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'

Plug 'svermeulen/vim-cutlass'
Plug 'svermeulen/vim-yoink'
Plug 'editorconfig/editorconfig-vim'

Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-entire'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'thinca/vim-textobj-function-javascript'

Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'

Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'wakatime/vim-wakatime'

Plug 'noahfrederick/vim-composer'
Plug 'noahfrederick/vim-laravel'

call plug#end()
