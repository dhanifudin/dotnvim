if exists('g:plugs["nvim-treesitter"]')
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	},
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
endif
