" Vim ftdetect file for ISC BIND90 and named-related configuration files
" Language:     ISC BIND named configuration file
" Filename:     bind-named.conf
" Path:         ~/.vim/ftdetect
" Maintainer:   egberts <egberts@github.com>
" Last change:  2024-05-24
" Filetypes:    named.conf, rndc.conf
" Filetypes:    named[-_]*.conf, rndc[-_]*.conf
" Filetypes:    *[-_]named.conf
" Filetypes:    rndc.key
" Source:       http://github.com/egberts/bind-named-vim-syntax
" License:      MIT license
" Remarks:
"               See syntax/bind-named.vim for additional info.
"
"               users can disable loading the default plugin completely 
"               by making a filetype plugin with only this line:
"
"                   let ignore_bind_named = 1

" Only do this when not done yet for this buffer
if exists("b:ignore_bind_named")
  finish
endif
let b:ignore_bind_named = 1

au! BufNewFile,BufRead named.conf,rndc.conf,rndc.key,*-named.conf,*_named.conf,*.named.conf,named-*.conf,named_*.conf,named.*.conf,rndc-*.conf,rndc_*.conf,rndc.*.conf,rndc.key,rndc-*.key,rndc_*.key,rndc.key,pz.*,mz.*,sz.*,view.*,named.conf*  set filetype=bind-named
