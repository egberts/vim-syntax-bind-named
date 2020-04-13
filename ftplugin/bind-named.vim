" Vim ftplugin file for ISC BIND named configuration file
" Language:     ISC BIND named configuration file
" Maintainer:   egberts <egberts@github.com>
" Last change:  2020-04-03
" Filenames:    named.conf, rndc.conf
" Filenames:    named[-_]*.conf, rndc[-_]*.conf
" Filenames:    *[-_]named.conf
" Location:     http://github.com/egberts/bind-named-vim-syntax
" License:      MIT license
" Remarks:
"
let namedindent_override_with_local_expandtab = exists("g:namedident_override_with_local_expandtab")
let namedindent_disable_expandtab = get(g:,"namedident_disable_expandtab", 0)


setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

" If you prefer not to change your settings of hard/soft tab characters 
" instead of replacement with spaces but leave as it is, that is 
" this default behavior here.


" If you prefer hard tab characters instead of replacement with spaces
" only within this Vim bind-named ftplugin,
" put the following into your ~/.vim/after/bind-named.vim to disable 
" this `setlocal expandtab`
"
"     namedident_override_with_local_expandtab = 1
"     namedident_disable_expandtab = 1
"
" In the case of having noexpandtab in your local vimrc, and want
" Bind named using hard tab, set the following
"
"     namedident_override_with_local_expandtab = 1
"     namedident_disable_expandtab = 0

if namedindent_override_with_local_expandtab != 0

    if namedindent_disable_expandtab != 0
      " expandtab got defined elsewhere, so we use hard tab, locally
      setlocal noexpandtab
      echomsg "No nein Expandtabby..."
    else
      " noexpandtab got defined elsewhere, so we use hard tab, locally
      echomsg "Expandtabby..."
      setlocal expandtab
    endif
endif

setlocal expandtab
filetype plugin indent on

setlocal completefunc=syntaxcomplete#Complete
