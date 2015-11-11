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
