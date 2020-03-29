" Vim ftdetect file
" Language:     ISC BIND named configuration file
" Maintainer:   egberts <egberts@github.com>
" Last change:  2020-03-12
" Filenames:    named.conf, rndc.conf
" Filenames:    named[-_]*.conf, rndc[-_]*.conf
" Filenames:    *[-_]named.conf
" Filenames:    rndc.key
" Location:     http://github.com/egberts/bind-named-vim-syntax
" License:      MIT license
" Remarks:
" See syntax/bind-named.vim for additional info.

au! BufNewFile,BufRead named.conf,rndc.conf,rndc.key,*-named.conf,*_named.conf,*.named.conf,named-*.conf,named_*.conf,named.*.conf,rndc-*.conf,rndc_*.conf,rndc.*.conf,rndc.key,rndc-*.key,rndc_*.key,rndc.key set filetype=bind-named
