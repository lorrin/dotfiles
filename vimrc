" Pathogen (http://www.vim.org/scripts/script.php?script_id=2332)
" allows placing extensions in vim/bundle/<private dir>
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

"From http://jmcpherson.org/vimrc.html
set nocompatible "set nocompatible gets rid of all the crap that Vim does to be vi compatible.
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set showmatch
set guioptions-=T
set vb t_vb=
set ruler
set hls "hi-lite search results
set incsearch "incremental search (as you go)

" From http://vim.runpaint.org
set autowrite "save buffers automatically when switching buffers or running external commands

" From http://www.moolenaar.net/habits.html
set hlsearch
syntax on

" Pig syntax from http://www.vim.org/scripts/script.php?script_id=2186
augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END 

" From http://vim.wikia.com/wiki/Converting_tabs_to_spaces
" Use :retab to convert existing tabs to spaces
set expandtab

" From http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set modelines=0 "prevents some security exploits having to do with modelines in files
set undofile "persistent undo data for files

"search for an all-lowercase string will be case-insensitive, but if one or more characters is uppercase the search will be case-sensitive
set ignorecase
set smartcase

set gdefault "gdefault applies substitutions globally on lines. For example, instead of :%s/foo/bar/g you just type :%s/foo/bar/

" Automatically insert a \v before regexes. This makes vim behave like Perl,Pyton, etc: ( | { etc are special syntax, escape to make literals.
"nnoremap / /\v
"vnoremap / /\v

set colorcolumn=80

" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" Unicode Character 'BLACK RIGHT-POINTING SMALL TRIANGLE' (U+25B8) ▸
" Unicode Character 'NOT SIGN' (U+00AC) ¬
" Unicode Character 'HYPHENATION POINT' (U+2027) ‧
" Unicode Character 'PILCROW SIGN' (U+00B6) ¶
set list
set listchars=tab:▸\ ,trail:‧
