" This a manual incarnation of what the (minimal) amix/vimrc installer generates. But rather than expect
" to find modifications in a my_configs.vim inside the amix/vimrc repo, this vimrc leaves the repo pristine
" and includes desired modifications in-line

set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

" ,/ to toggle search highlight on and off (courtesey https://github.com/spf13/spf13-vim/blob/master/.vimrc)
nmap <silent> <leader>/ :set invhlsearch<CR>

if has ('x') && has ('gui') " On Linux use + register for copy-paste
    set clipboard=unnamedplus
elseif has ('gui')          " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
endif

" Restore ctrl-f as page-forward. You can still get to CtrlP with <leader>j
" (CtrlP is not mapped to ctrl-p because YankRing uses ctrl-p)
let g:ctrlp_map = '<leader>j'
let g:ctrlp_cmd = 'CtrlP'
" Restore ctrl-b as page-back. Add <leader>J to start CtrlP in find-buffer
" mode.
map <leader>J :CtrlPBuffer<cr>
map <c-b> <PageUp>


" hitting Tab in insert mode will produce the appropriate number of spaces
set expandtab
" how many columns a tab character counts for
set tabstop=8
" how many columns vim uses when you hit Tab in insert mode
set softtabstop=4
" how many columns text is indented with the reindent operations (<< and >>) and automatic C-style indentation
set shiftwidth=4
" display whitespace
set list
" control how whitespace is displayed
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set listchars=tab:>·,trail:~,extends:>,precedes:<
