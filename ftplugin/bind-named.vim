" Vim ftplugin file for ISC BIND and named-related configuration file
" Language:     ISC BIND named configuration file
" Filename:     bind-named.conf
" Path:         ~/.vim/ftpplugin
" Maintainer:   egberts <egberts@github.com>
" Last change:  2024-05-24
" Filetypes:    named.conf, rndc.conf
" Filetypes:    named[-_]*.conf, rndc[-_]*.conf
" Filetypes:    *[-_]named.conf
" Source:       http://github.com/egberts/bind-named-vim-syntax
" License:      MIT license
" Remarks:
"               users can disable loading the default plugin completely by making a
"               filetype plugin with only this line:
"                   let ignore_bind_name = 1
"
"
" Only do this when not done yet for this buffer
if exists("b:ignore_bind_named")
  finish
endif
let b:ignore_bind_named = 1

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
      " echomsg "Expandtabby..."
      setlocal expandtab
    endif
endif

setlocal expandtab
filetype plugin indent on

setlocal completefunc=syntaxcomplete#Complete
