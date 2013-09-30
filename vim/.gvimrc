" Violate dotfiles convention of .local file meaning local to this machine. Here it means personal override of
" stock spf13 vim configuration. Will need more nuanced approach if different machines need different settings.

" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        if has("gui_gtk2")
            set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
        else
            set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        endif
    endif
" }
