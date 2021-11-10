if exists('g:plugs["nvim-treesitter"]')
" lua <<EOF
" require'nvim-treesitter.configs'.setup {
" 	ensure_installed = "maintained",
" 	highlight = {
" 		enable = true,
" 	},
"   textobjects = {
"     select = {
"       enable = true,
"       lookahead = true,
"       keymaps = {
"         ["af"] = "@function.outer",
"         ["if"] = "@function.outer",
"         ["ac"] = "@function.outer",
"         ["ic"] = "@function.outer",
"       }
"     }
"   }
" }
" EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
endif
