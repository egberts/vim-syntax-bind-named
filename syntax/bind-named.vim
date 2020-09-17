" Vim syntax file for ISC BIND v9.16 named.conf configuration file
" Language:     ISC BIND named.conf configuration file
" Maintainer:   egberts <egberts@github.com>
" Last change:  2020-04-24
" Filenames:    named.conf, rndc.conf
" Filenames:    named[-_]*.conf, rndc[-_]*.conf
" Filenames:    *[-_]named.conf
" Location:     https://github.com/egberts/vim-syntax-bind-named
" License:      MIT license
" Remarks:
" Bug Report:   https://github.com/egberts/vim-syntax-bind-named/issues
"
"
" Inspired by Nick Hibma <nick@van-laarhoven.org> 'named.vim',
" also by glory hump <rnd@web-drive.ru>, and Marcin Dalecki.
"
" Jumpstarted to Bind 9.15 by Egberts <egberts@github.com>
"
" This file could do with a lot of improvements, so comments are welcome.
" Please submit the afflicted but privatized version of your 
" named.conf (segment) file snippet with any comments.
"
" Basic highlighting is covered for all Bind configuration 
" options.  Only 'Normal' (default to black; if dark backgroud, white) 
" highlight gets used to show 'undetected' Bind syntax.  
"
" Every valid keywords get colorized. Every character-valid 
" values get colorized, some range-checking done here.
"
" Most importantly, every semicolon must be colorized.
"
" New Bind 9.13+ terminologies/notation used here:
"    Stmt   - top-level statement keyword (formerly 'clause' 
"             from Bind 4 to 9.11)
"    Opt    - an option keyword found within each of its 
"             top-level keywords.
"    Clause - very specific keywords used within each of its 
"             option statement
"
" Syntax Naming Convention: 
"    All macro names that are defined here start with 
"    'named' prefix. This is a Vim standard to ensure
"    no conflict with global Vim namespace.
"
"    Each macro name contains a camel-case notation to 
"    denote each shorten word that identifies the:
"
"      -  its statement (top-level keyword), 
"        - any ONE of its options used, then 
"          - any ONE of its clauses used.  
"
"    For example, 'ControlsInetSection' represents the 
"    curly braces region of a particular 'inet' of that 
"    'controls' statement
"
"        controls xxx { inet { ... }; };
"                            ^^^^^^^
"
"    Additionally, following sub-notations may be used 
"    within each of the camel-cased macro names:
"    Section - Surrounded by curly braces, followed by an
"              ending semicolon.
"    Element - entire item(s) that must have an ending
"              semicolon terminators.  
"              Element are used one or more times within 
"              a Section.
"    Ident   - the declaration of an identifier
"    Name    - the usage of an Ident identifier
"    Error   - denotes that Vim Error color is used
"    Not     - an inverse pattern, useful for Errors
"
" Clarification: In the following Vim syntax macros, 
" there is an 'Options' notation as one of the 
" top-level Bind keyword statements, and then there 
" is an 'Opt' notation for those 'option' used under 
" each (top-level) statement: 
" Opt <> Options.
"
" 'iskeyword' is a Vim script function used here or ONLY 
" for Bind-builtins because such keywords transcend all 
" syntax processing (including nested curly-braces 
" sections; so you don't want to be using the bruteforce 
" absolute Vim '\k'\keyword\iskeyword too much
" other than Bind 'builtins'; 
" Same deal for '\i'/isident/identifiers.
"
" Bind builtins are 'any', 'none', 'localhost', 
" 'localnets' because we shouldn't be using those builtins 
" anywhere else as an identifier or a label names either.  
"
" ACL names are like identifier but will not be treated
" like Vim identifier here.
" Another reason why you shouldn't use period or slashes 
" in ACL names because it would only confuses our 
" simplistic IP address syntax processing here. But I 
" do test for these corner-cases, in case.
"
" isident is used for the most-lax naming convention of 
" all Bind identifiers combined.  Those naming convention
" are ordered from VIEW_name, Zone_name, ACL_name, 
" master_name, and then to the most strictest naming 
" convention, domain_name.  
"
" I'm moving away from isident within this syntax file.
"
" charset_view_name_base = alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed
" charset_zone_name_base = alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed

" charset_acl_name_base =  alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed
" charset_master_name = alphanums + '_-.'
" charset_fqdn_name_base = alphanums + '_-.'
"
" NOTE: you can't use nextgroup for proper ordering of its multi-statements,
"       only line position of statements of those referenced by 
"       that 'nextgroup'.
"
" NOTE: DON'T put Vim inline comment on continuation lines for `syntax ...`.
"       It hurts, badly.
"
" quit when a syntax file was already loaded
if !exists('main_syntax')
  if exists('b:current_syntax')
    finish
  endif
  let main_syntax='bind-named'
endif

syn case match

" iskeyword severly impacts '\<' and '\>' atoms
setlocal iskeyword=.,-,48-58,A-Z,a-z,_
setlocal isident=.,-,48-58,A-Z,a-z,_

" syn sync match namedSync grouphere NONE "^(zone|controls|acl|key)"
syn sync fromstart

let s:save_cpo = &cpoptions
set cpoptions-=C

" First-level highlighting

hi link namedHL_Comment     Comment
hi link namedHL_Include     DiffAdd
hi link namedHL_ToDo        Todo
hi link namedHL_Identifier  Identifier
hi link namedHL_Statement   Keyword
hi link namedHL_Option      Label     " could use a 2nd color here
hi link namedHL_Clause      Type    " could use a 3rd color here
hi link namedHL_Type        Type
" Bind has only one operator '!'
hi link namedHL_Operator    Operator  
hi link namedHL_Number      Number
hi link namedHL_String      String
" Bind's builtins: 'any', 'none', 'localhost', 'localnets'
hi link namedHL_Builtin     Special 
hi link namedHL_Underlined  Underlined
" Do not use Vim's "Boolean" highlighter, Bind has its own syntax.
hi link namedHL_Error       Error

" Second-level highlight alias
hi link namedOK           21
hi link namedHL_Boolean     namedHL_Type 
hi link namedHL_Domain      namedHL_String 
hi link namedHL_Hexidecimal namedHL_Number
hi link namedHL_Wildcard    namedHL_Builtin
hi link namedHL_Base64      namedHL_Identifier "  RFC 3548
hi link namedHL_ACLName     namedHL_Identifier
hi link namedHL_Algorithm   namedHL_Identifier
hi link namedHL_ClassName   namedHL_Identifier
hi link namedHL_Filespec    namedHL_Identifier
hi link namedHL_KeyName     namedHL_Identifier
hi link namedHL_MasterName  namedHL_Identifier
hi link namedHL_ViewName    namedHL_Identifier
hi link namedHL_ZoneName    namedHL_Identifier

" Third-level highlight alias should be next to their keywords

" Down-Top/Bottom-Up syntax approach.
" Smallest granular definition starts here.
" Largest granular definition goes at the bottom.
" Pay attention to tighest-pattern-first ordering of syntax.
"
" Many Vim-match/region/keyword are mixed together here by
" reusing its same macro name, to attain that desired 
" First-match method.

" 'Vim-uncontained' statements are the ones used GLOBALLY

hi link namedE_UnexpectedSemicolon namedHL_Error
syn match namedE_UnexpectedSemicolon contained /;\+/ skipwhite skipempty

hi link namedE_MissingSemicolon namedHL_Error
syn match namedE_MissingSemicolon contained /[ \n\r]*\zs[^;]*/he=s+1|

" Keep this 'uncontained' EOF search shallow and short
hi link namedE_MissingLastSemicolon namedHL_Error
syn match namedE_MissingLastSemicolon /[^; \n\r][ \n\r]\{0,10}\%$/rs=s,he=s+1 skipwhite skipnl skipempty

hi link namedE_MissingLParen namedHL_Error
syn match namedE_MissingLParen contained /[ \n\r#]*\zs[^\{]*/he=s+1|

hi link namedE_UnexpectedRParen namedHL_Error
syn match namedE_UnexpectedSemicolon contained /;\+/ skipwhite skipempty

hi link namedSemicolon namedHL_Type
" syn match namedSemicolon contained /\(;\+\s*\)\+/ skipwhite skipempty
syn match namedSemicolon contained /;/ skipwhite skipempty

hi link namedA_Semicolon namedHL_Type
syn match namedA_Semicolon contained /;/ skipwhite skipempty



hi link named_ToDo namedHL_ToDo
syn keyword named_ToDo xxx contained XXX FIXME TODO TODO: FIXME:

hi link namedComment namedHL_Comment
syn match namedComment "//.*" contains=named_ToDo
" syn match namedComment \"#.*\" contains=named_ToDo
syn region namedComment start=/#/ end=/$/ contains=named_ToDo
syn region namedComment start="/\*" end="\*/" contains=named_ToDo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FIXED-LENGTH FIXED-CHARACTERS PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""


hi link namedA_Bind_Builtins namedHL_Builtin
syn keyword namedA_Bind_Builtins contained skipwhite skipnl skipempty
\    any
\    none
\    localhost
\    localnets
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedA_Semicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FIXED-LENGTH VARIABLE-CHARACTERS PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link named_AllowMaintainOff namedHL_Type
syn match named_AllowMaintainOff contained /\callow/ skipwhite nextgroup=namedSemicolon
syn match named_AllowMaintainOff contained /\cmaintain/ skipwhite nextgroup=namedSemicolon
syn match named_AllowMaintainOff contained /\coff/ skipwhite nextgroup=namedSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VARIABLE-LENGTH FIXED-NONSPACE PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VARIABLE-LENGTH VARIABLE-CHARACTERS PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variable-length variable-characters patterns - Number
hi link namedNumber namedHL_Number
syn match namedNumber contained "\d\{1,10}"

hi link named_Number_SC namedHL_Number
syn match named_Number_SC contained "\d\{1,10}" skipwhite 
\ nextgroup=namedSemicolon

hi link named_Keyname_SC namedHL_KeyName
syn match named_Keyname_SC contained skipwhite
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ nextgroup=namedSemicolon

" Variable-length variable-characters patterns - String
hi link named_Filespec namedHL_Filespec
syn match named_Filespec contained skipwhite skipempty skipnl
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/\\?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
syn match named_Filespec contained skipwhite skipempty skipnl
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/\\?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
syn match named_Filespec contained skipwhite skipempty skipnl
\ /[a-zA-Z\]\-\[0-9\._,:\/\\?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ 

hi link named_E_Filespec_SC namedHL_Filespec
" TODO those curly braces and semicolon MUST be able to work within quotes.
syn match named_E_Filespec_SC contained /\'[ a-zA-Z\]\-\[0-9\._,:\;\/?<>|"`~!@#$%\^&*\\(\\)=\+{}]\{1,1024}\'/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /"[ a-zA-Z\]\-\[0-9\._,:\;\/?<>|'`~!@#$%\^&*\\(\\)=\+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)=\+]\{1,1024}/ skipwhite skipempty skipnl nextgroup=namedSemicolon

hi link namedNotSemicolon namedHL_Error
syn match namedNotSemicolon contained /[^;]\+/he=e-1 skipwhite

hi link  namedE_TrailingSpaces  namedHL_Error
" Show trailing whitespace only after some text (ignores blank lines):
syn match namedE_TrailingSpaces contained /\S\zs\s\+$/ 

hi link namedError        namedHL_Error
syn match namedError /[^;{#]$./

hi link namedNotNumber    namedHL_Error
syn match namedNotNumber contained "[^  0-9;]\+"

" <0-30000> (resolver-query-timeout in millisecond)
hi link named_Interval_Max30ms_SC namedHL_Number
syn match named_Interval_Max30ms_SC contained /\d\+/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

" <0-30> (servfail-ttl)
hi link named_Ttl_Max30sec_SC namedHL_Number
syn match named_Ttl_Max30sec_SC contained 
\     /\d\+/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

" <0-90> (min-cache-ttl)
hi link named_Ttl_Max90sec_SC namedHL_Number
syn match named_Ttl_Max90sec_SC contained 
\     /\d\+/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

" <0-1200> ([max-]clients-per-query)
hi link named_Number_Max20min_SC namedHL_Number
syn match named_Number_Max20min_SC contained 
\    "\d\{1,10}" 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

" edns-udp-size: range: 512 to 4096 (default 4096)
hi link named_Number_UdpSize namedHL_Number
syn match named_Number_UdpSize contained skipwhite skipnl skipempty
\     /\(409[0-6]\)\|\(40[0-8][0-9]\)\|\([1-3][0-9][0-9][0-9]\)\|\([6-9][0-9][0-9]\)\|\(5[2-9][0-9]\)\|\(51[2-9]\)/
\ nextgroup=namedSemicolon,namedError

" TTL <0-10800> (max-ncache-ttl)
hi link named_Ttl_Max3hour_SC namedHL_Number
syn match named_Ttl_Max3hour_SC contained skipwhite skipnl skipempty
\ /\d\+/
\ nextgroup=namedSemicolon

" TTL <0-1800> (lame-ttl)
hi link named_Ttl_Max30min_SC namedHL_Number
syn match named_Ttl_Max30min_SC contained skipwhite skipnl skipempty
\ /\d\+/
\ nextgroup=namedSemicolon

" <0-3660> days (dnskey-sig-validity)
hi link named_Number_Max3660days namedHL_Number
syn match named_Number_Max3660days contained skipwhite skipnl skipempty
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ nextgroup=namedSemicolon

" <0-604800> (max-cache-ttl)
hi link named_Ttl_Max1week_SC namedHL_Number
syn match named_Ttl_Max1week_SC contained skipwhite  skipnl skipempty
\ /\d\+/
\ nextgroup=namedSemicolon

" heartbeat-interval: range: 0-40320
hi link named_Number_Max28day_SC namedHL_Number
syn match named_Number_Max28day_SC contained
\ /\%(40320\)\|\%(403[0-1][0-9]\)\|\%(40[0-2][0-9][0-9]\)\|\%([1-3][0-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9]\)\|\%([1-9][0-9]\)\|\%([0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

" <0-2419200> (max-refresh-time, min-refresh-time, min-retry-time,
" max-retry-time)
hi link named_Number_Max24week_SC namedHL_Number
syn match named_Number_Max24week_SC contained "\d\{1,10}" skipwhite nextgroup=namedSemicolon

hi link named_Number_GID namedHL_Number
syn match named_Number_GID contained "[0-6]\{0,1}[0-9]\{1,4}"

hi link namedUserID namedHL_Number
syn match namedUserID contained "[0-6]\{0,1}[0-9]\{1,4}"

hi link namedFilePerm   namedHL_Number
syn match namedFilePerm contained "[0-7]\{3,4}"

hi link namedDSCP   namedHL_Number
syn match namedDSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/

hi link named_Port namedHL_Number
syn match named_Port contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link named_Port_SC namedHL_Number
syn match named_Port_SC contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/ skipwhite nextgroup=namedSemicolon

hi link named_PortWild    namedHL_Builtin
syn match named_PortWild contained /\*/
syn match named_PortWild contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link namedElementPortWild namedHL_Number
syn match namedElementPortWild contained /\*\s*;/ skipwhite
"syn match namedElementPortWild contained /\d\{1,5}\s*;/hs=s,me=e-1
syn match namedElementPortWild contained /\%([1-9]\|[1-5]\?[0-9]\{2,4}\|6[1-4][0-9]\{3}\|65[1-4][0-9]\{2}\|655[1-2][0-9]\|6553[1-5]\)\s*;/he=e-1
\ contains=named_Port skipwhite

hi link namedWildcard     namedHL_Builtin
syn match namedWildcard contained /\*/

" Boolean value with an ending semicolon
hi link named_Boolean_SC namedHL_Boolean
syn match named_Boolean_SC contained /\cyes/ skipnl skipempty skipwhite nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\cno/ skipwhite skipnl skipempty nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\ctrue/ skipwhite skipnl skipempty nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\cfalse/ skipwhite skipnl skipempty nextgroup=namedSemicolon
syn keyword named_Boolean_SC contained 1 skipwhite skipnl skipempty nextgroup=namedSemicolon
syn keyword named_Boolean_SC contained 0 skipwhite skipnl skipempty nextgroup=namedSemicolon

hi link namedNotBool  namedHL_Error
syn match namedNotBool contained "[^  ;]\+"

hi link namedTypeBool  namedHL_Boolean
syn match namedTypeBool contained /\cyes/
syn match namedTypeBool contained /\cno/
syn match namedTypeBool contained /\ctrue/
syn match namedTypeBool contained /\cfalse/
syn keyword namedTypeBool contained 1
syn keyword namedTypeBool contained 0

hi link named_IgnoreWarn_SC namedHL_Type
syn match named_IgnoreWarn_SC contained /\cwarn/ skipwhite nextgroup=namedSemicolon
syn match named_IgnoreWarn_SC contained /\cignore/ skipwhite nextgroup=namedSemicolon

hi link named_IgnoreWarnFail_SC namedHL_Type
syn match named_IgnoreWarnFail_SC contained /\cwarn/ skipwhite nextgroup=namedSemicolon
syn match named_IgnoreWarnFail_SC contained /\cfail/ skipwhite nextgroup=namedSemicolon
syn match named_IgnoreWarnFail_SC contained /\cignore/ skipwhite nextgroup=namedSemicolon

hi link named_StrictRelaxedDisabledOff namedHL_Type
syn match named_StrictRelaxedDisabledOff  contained /\cstrict/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\crelaxed/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\cdisabled/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\coff/ skipwhite nextgroup=namedSemicolon

hi link namedACLName namedHL_ACLName
syn match namedACLName contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ skipwhite

hi link named_E_ACLName_SC namedHL_ACLName
syn match named_E_ACLName_SC contained /\<[0-9a-zA-Z\-_\[\]\<\>]\{1,63}\>/
\ skipwhite
\ nextgroup=
\    namedSemicolon,
\    namedE_MissingSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REGEX PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOV_CZ_MasterName_SC namedHL_MasterName
syn match namedOV_CZ_MasterName_SC contained /\<[0-9a-zA-Z\-_\.]\{1,63}/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedA_ACL_Name namedHL_ACLName
syn match namedA_ACL_Name contained "\<\(\w\|\.\|\-\)\{1,63}\ze[^;]*" 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_MissingSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IP patterns, 
" organized by IP4 to IP6; global to specific subgroups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link named_IP4Addr namedHL_Number
syn match named_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/

hi link named_IP4AddrPrefix namedHL_Number
syn match named_IP4AddrPrefix contained 
\  /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/

hi link named_E_IP4Addr_SC namedHL_Number
syn match named_E_IP4Addr_SC contained 
\  /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link named_E_IP4AddrPrefix_SC namedHL_Number
syn match named_E_IP4AddrPrefix_SC contained 
\ /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedA_IP4Addr_SC namedHL_Number
syn match namedA_IP4Addr_SC contained 
\     /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\ze[^;]*\ze[^;]*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedSemicolon,
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon

hi link namedA_IP4AddrPrefix_SC namedHL_Number
syn match namedA_IP4AddrPrefix_SC contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}\ze[^;]*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon

" named_IP6Addr  should match:
"  IPv6 addresses
"    zero compressed IPv6 addresses (section 2.2 of rfc5952)
"    link-local IPv6 addresses with zone index (section 11 of rfc4007)
"    IPv4-Embedded IPv6 Address (section 2 of rfc6052)
"    IPv4-mapped IPv6 addresses (section 2.1 of rfc2765)
"    IPv4-translated addresses (section 2.1 of rfc2765)
"  IPv4 addresses
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link named_E_IP6Addr_SC namedHL_Number
syn match named_E_IP6Addr_SC contained 
\ /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match named_E_IP6Addr_SC contained 
\ /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_E_IP6Addr_SC contained 
\ /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_E_IP6Addr_SC contained 
\ /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_E_IP6Addr_SC contained 
\ /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_E_IP6Addr_SC contained 
\ /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_E_IP6Addr_SC contained 
\ /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_E_IP6Addr_SC contained 
\ /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_E_IP6Addr_SC contained 
\ /fe08%[a-zA-Z0-9\-_\.]\{1,64}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_E_IP6Addr_SC contained 
\ /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_E_IP6Addr_SC contained 
\ /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained 
\ /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained 
\ /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ 
\ containedin=namedElementAMLSection
\ nextgroup=namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_E_IP6Addr_SC contained 
\ /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained 
\ /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ 
\ skipwhite skipnl skipempty
\ containedin=
\    namedElementAMLSection
\ nextgroup=namedSemicolon

hi link namedA_IP6Addr_SC namedHL_Number
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedA_IP6Addr_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedA_IP6Addr_SC contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedA_IP6Addr_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedA_IP6Addr_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6Addr_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6Addr_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedA_IP6Addr_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6Addr_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon


" Full IPv6 with Prefix with trailing semicolon
hi link named_E_IP6AddrPrefix_SC namedHL_Number
syn match named_E_IP6AddrPrefix_SC contained
\    /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_A_AML_Nested_Semicolon,
\    namedSemicolon,
\    named_E_MissingSemicolon
" ::/123
syn match named_E_IP6AddrPrefix_SC contained /::\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_E_IP6AddrPrefix_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_E_IP6AddrPrefix_SC contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_E_IP6AddrPrefix_SC contained 
\ /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}\/[0-9]\{1,3}%[a-zA-Z0-9]\{1,64}/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_E_IP6AddrPrefix_SC contained 
\    /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_E_IP6AddrPrefix_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

" Full IPv6 with Prefix with trailing semicolon (used by AML only)
hi link namedA_IP6AddrPrefix_SC namedHL_Number
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedA_IP6AddrPrefix_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedA_IP6AddrPrefix_SC contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedA_IP6AddrPrefix_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}\/[0-9]\{1,3}%[a-zA-Z0-9]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedA_IP6AddrPrefix_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6AddrPrefix_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6AddrPrefix_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedA_IP6AddrPrefix_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6AddrPrefix_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
"
" Full IPv6 with Prefix (without semicolon)
hi link named_IP6AddrPrefix namedHL_Number
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/ 
" 1::                              1:2:3:4:5:6:7::
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/ 
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/ 
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/ 
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_IP6AddrPrefix contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_IP6AddrPrefix contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_IP6AddrPrefix contained /fe80:\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_IP6AddrPrefix contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6AddrPrefix contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6AddrPrefix contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_IP6AddrPrefix contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6AddrPrefix contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/

" Full IPv6 (without the trailing '/') (without semicolon)
hi link named_IP6Addr namedHL_Number
syn match named_IP6Addr /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ contained
" 1::                              1:2:3:4:5:6:7::
syn match named_IP6Addr /\%(\x\{1,4}:\)\{1,7}:/ contained
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_IP6Addr /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ contained
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_IP6Addr /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/ contained
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_IP6Addr contained /fe80%[a-zA-Z0-9\-_\.]\{1,64}/
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_IP6Addr contained /fe80:\%(:\x\{1,4}\)\{1,2}%[a-zA-Z0-9\-_\.]\{1,64}/
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_IP6Addr /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ contained
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/



" --- string 
hi link named_AlgorithmName_SC namedHL_String
syn match named_AlgorithmName_SC contained skipwhite
\ /\<[0-9A-Za-z\-_]\{1,63}/
\ nextgroup=namedSemicolon

hi link namedString namedHL_String
syn region namedString start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
syn region namedString start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
syn match namedString contained /\<[a-zA-Z0-9_\.\-]\{1,63}\>/

hi link named_String_DQuoteForced namedHL_String
syn region named_String_DQuoteForced start=/"/ skip=/\\"/ end=/"/ contained

hi link named_String_SQuoteForced namedHL_String
syn region named_String_SQuoteForced start=/'/ skip=/\\'/ end=/'/ contained

hi link named_String_QuoteForced namedHL_String
syn region named_String_QuoteForced start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
syn region named_String_QuoteForced start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
hi link named_String_DQuoteForced_SC namedHL_String
syn region named_String_DQuoteForced_SC start=/"/ skip=/\\"/ end=/"/ contained nextgroup=namedSemicolon
hi link named_String_SQuoteForced_SC namedHL_String
syn region named_String_SQuoteForced_SC start=/'/ skip=/\\'/ end=/'/ contained nextgroup=namedSemicolon
hi link named_String_QuoteForced_SC namedHL_String
syn region named_String_QuoteForced_SC start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained nextgroup=namedSemicolon
syn region named_String_QuoteForced_SC start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained nextgroup=namedSemicolon

" -- Identifier
hi link namedTypeBase64 namedHL_Base64
syn match namedTypeBase64 contained /\<[0-9a-zA-Z\/\-\_\,+=]\{1,4099}/

hi link namedKeySecretValue   namedHL_Base64
syn match namedKeySecretValue contained /\<[0-9a-zA-Z\+\=\/]\{1,4099}\s*;/he=e-1 skipwhite

hi link namedKeyName namedHL_KeyName
syn match namedKeyName contained /\<[0-9a-zA-Z\-_]\{1,63}/ skipwhite

hi link namedKeyAlgorithmName namedHL_Algorithm
syn match namedKeyAlgorithmName contained /\<[0-9A-Za-z\-_]\{1,4096}/ skipwhite

hi link namedMasterName namedHL_MasterName
syn match namedMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}/ skipwhite

hi link namedElementMasterName namedHL_MasterName
syn match namedElementMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}\s*;/he=e-1 skipwhite

hi link namedHexSecretValue   namedHL_Hexidecimal
syn match namedHexSecretValue contained /\<'[0-9a-fA-F]\+'\>/ skipwhite
syn match namedHexSecretValue contained /\<"[0-9a-fA-F]\+"\>/ skipwhite

hi link namedViewName namedHL_ViewName
syn match namedViewName contained /\<[a-zA-Z0-9_\.\-]\{1,63}\>/
\ skipwhite skipnl skipempty
syn region namedViewName start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
\ skipwhite skipnl skipempty
syn region namedViewName start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
\ skipwhite skipnl skipempty


hi link named_E_ViewName_SC namedHL_ViewName
syn match named_E_ViewName_SC contained /[a-zA-Z0-9\-_\.]\{1,63}/ skipwhite
\ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
syn region named_E_ViewName_SC start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
\ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
syn region named_E_ViewName_SC start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
\ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty

hi link namedZoneName namedHL_ZoneName
syn match namedZoneName contained /[a-zA-Z0-9]\{1,64}/ skipwhite

hi link namedElementZoneName namedHL_ZoneName
syn match namedElementZoneName contained /[a-zA-Z0-9]\{1,63}\s\{1,63};/he=e-1 skipwhite

hi link namedDlzName namedHL_Identifier
syn match namedDlzName contained /[a-zA-Z0-9_\.\-]\{1,63}/ skipwhite
hi link namedDyndbName namedHL_Identifier
syn match namedDyndbName contained /[a-zA-Z0-9_\.\-]\{1,63}/ skipwhite

syn match namedKRB5username contained /\i\+;/he=e-1 skipwhite
syn match namedKRB5realm contained /\i\+;/he=e-1 skipwhite
syn match namedKRB5principal contained /\i\+;/he=e-1 skipwhite

syn match namedTypeSeconds /\d\{1,11}\s*;/he=e-1 contained skipwhite

hi link namedTypeMinutes namedHL_Number
syn match namedTypeMinutes contained /\d\{1,11}\s*;/he=e-1 skipwhite
syn match namedTypeDays contained /\d\{1,11}\s*;/he=e-1 skipwhite
syn match namedTypeCacheSize contained /\d\{1,3}\s*;/he=e-1 skipwhite

" --- syntax errors
hi link namedIllegalDom   namedHL_Error
syn match namedIllegalDom contained /"\S*[^-A-Za-z0-9.[:space:]]\S*"/ms=s+1,me=e-1

hi link namedIPerror      namedHL_Error
syn match namedIPerror contained /\<\S*[^0-9.[:space:];]\S*/

hi link namedNotParenError namedHL_Error
syn match namedNotParenError contained /\%([^{]\|$\)/ skipwhite

hi link namedEParenError  namedHL_Error
syn match namedEParenError contained +{+

hi link namedParenError   namedHL_Error
syn match namedParenError /}\%([^;]\|$\)/


" --- IPs & Domains


hi link namedIPwild   namedHL_Wildcard
syn match namedIPwild contained /\*/

hi link namedSpareDot     namedHL_Error
syn match namedSpareDot contained /\./
syn match namedSpareDot_SC contained /\.\s\+;/



" syn match namedDomain contained /"\."/ms=s+1,me=e-1 skipwhite
hi link namedDomain namedHL_Domain
syn match namedDomain contained /\<[0-9A-Za-z\._\-]\+\>/ nextgroup=namedSpareDot
hi link named_QuotedDomain namedHL_Domain
syn match named_QuotedDomain contained /\<[0-9A-Za-z\._\-]\{1,1023}\>/ nextgroup=namedSpareDot
syn match named_QuotedDomain contained /'\<[0-9A-Za-z\.\-_]\{1,1023}'\>/hs=s+1,he=e-1 nextgroup=namedSpareDot
syn match named_QuotedDomain contained /"\<[0-9A-Za-z\.\-_]\{1,1023}"\>\"/ nextgroup=namedSpareDot
hi link named_QuotedDomain_SC namedHL_Domain
syn match named_QuotedDomain_SC contained /[0-9A-Za-z\._\-]\{1,1023}\.\{0,1}/ nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /'[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}'/hs=s+1,he=e-1 nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /"[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}"/hs=s+1,he=e-1 nextgroup=namedSemicolon skipwhite

hi link named_E_Domain_SC namedHL_Domain
syn match named_E_Domain_SC contained /\<[0-9A-Za-z\._\-]\+\>/
\ nextgroup=namedSemicolon

hi link named_E_SuffixDomain_SC namedHL_Domain
syn match named_E_SuffixDomain_SC contained /\<[0-9A-Za-z\._\-]{1,1023}[A-Za-z\.]\>/
\ nextgroup=namedSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nesting of PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" We'll do error RED highlighting on all statement firstly, then later on
" all the options, then all the clauses.
" hi link namedStmtKeywordUnknown namedHL_Error
" syn match namedStmtKeywordUnknown /\<\S\{1,64}\>/


hi link namedInclude namedHL_Include
syn match namedInclude /\_s*include/ 
\ nextgroup=named_E_Filespec_SC
\ skipwhite skipnl skipempty


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -- Vim syntax clusters
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedClusterBoolean_SC namedHL_Error
syntax cluster namedClusterBoolean_SC contains=named_Boolean_SC 
syntax cluster namedClusterBoolean contains=namedTypeBool,namedNotBool,@namedClusterCommonNext
syntax cluster namedDomainFQDNCluster contains=namedDomain,namedError
syn cluster namedCommentGroup contains=named_ToDo


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link named_SizeSpec namedHL_Number
syn match named_SizeSpec contained skipwhite
\ /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/ 

hi link named_SizeSpec_SC namedHL_Number
syn match named_SizeSpec_SC contained skipwhite
\ /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/ 
\ nextgroup=namedSemicolon


hi link named_DefaultUnlimited_SC namedHL_Builtin
syn match named_DefaultUnlimited_SC contained skipwhite /\cunlimited/
\ nextgroup=namedSemicolon
syn match named_DefaultUnlimited_SC contained skipwhite /\cdefault/
\ nextgroup=namedSemicolon


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'acl' statement
"
" acl acl-name {
"    [ address_match_nosemicolon | any | all ];
"    ... ;
" };
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedA_KeyName namedHL_KeyName
syn match namedA_KeyName contained 
\    /\S\{1,63}/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedA_Key namedHL_Option
syn match namedA_Key contained /\<key\>/ skipwhite skipnl skipempty
\ nextgroup=named_Keyname_SC 

hi link namedA_AML_Nested_Semicolon namedHL_Type
syn match namedA_AML_Nested_Semicolon contained 
\    /;/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Recursive,
\    namedA_AML_Nested_Not_Operator,
\    namedA_AML_Nested_Semicolon

hi link namedA_AML_Not_Operator namedHL_Operator
syn match namedA_AML_Not_Operator contained /!/ skipwhite skipempty
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML,
\    namedE_UnexpectedSemicolon,
\    namedE_MissingLParen,
\    namedE_UnexpectedRParen

hi link namedA_AML_Nested_Not_Operator namedHL_Operator
syn match namedA_AML_Nested_Not_Operator contained /!/ skipwhite skipempty
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedInclude,
\    namedComment,
\    namedA_AML_Recursive,
\    namedA_IP4Addr_SC,
\    namedA_IP4AddrPrefix_SC,
\    namedA_IP6Addr_SC,
\    namedA_IP6AddrPrefix_SC,
\    namedA_Bind_Builtins,
\    namedA_Key,
\    namedA_ACL_Name,
\    namedE_UnexpectedSemicolon,
\    namedE_MissingLParen,
\    namedE_UnexpectedRParen

" Keep keepend/extend on AML_Recursive!!!
syn region namedA_AML_Recursive contained start=+{+ end=+}+ keepend extend
\ skipwhite skipnl skipempty
\ contains=
\    namedA_AML_Recursive,
\    namedInclude,
\    namedComment,
\    namedA_IP4Addr_SC,
\    namedA_IP4AddrPrefix_SC,
\    namedA_IP6Addr_SC,
\    namedA_IP6AddrPrefix_SC,
\    namedA_Bind_Builtins,
\    namedA_Key,
\    namedA_ACL_Name,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_MissingSemicolon
\ containedin=
\    namedA_AML_Recursive

" acl <acl_name> { ... } ;
syn region namedA_AML contained start=+{+ end=+}+  
\ skipwhite skipnl skipempty
\ contains=
\    namedInclude,
\    namedComment,
\    namedA_IP4Addr_SC,
\    namedA_IP4AddrPrefix_SC,
\    namedA_IP6Addr_SC,
\    namedA_IP6AddrPrefix_SC,
\    namedA_Bind_Builtins,
\    namedA_Key,
\    namedA_ACL_Name,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_Semicolon,
\    namedE_MissingSemicolon

" acl <string> { <address_match_element>; ... }; // may occur multiple times
hi link namedA_ACLIdentifier  namedHL_ACLName
syn region namedA_ACLIdentifier contained start=+'+ skip="\\'" end=+'+
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen
syn region namedA_ACLIdentifier contained start=+"+ skip="\\'" end=+"+
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen
syn match namedA_ACLIdentifier contained /\<[0-9a-zA-Z\-_]\{1,63}\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen


" Syntaxes that are found only within 'controls' statement
"
" controls { inet ( * | <ip46_addr> ) 
"                [ port <port_no> ] 
"                allow { <address_match_element>; ... };
"                [ keys { <key_name>; ... } ] 
"                [ read-only <boolean> ]; 
"          };
" controls { unix <quoted_string> 
"                 perm <perm_integer> 
"                 owner <owner_id> 
"                 group <group_id> 
"                 [ keys { <key_name>; ... } ] 
"                 [ read-only <boolean> ]; 
"          };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedC_InetOptACLName namedHL_ACLName
syn match namedC_InetOptACLName contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ 
\ skipwhite skipnl skipempty
\ contains=namedACLName
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

hi link namedC_ClauseInet namedHL_Option
syn match namedC_OptReadonlyBool contained /\i/ 
\ skipwhite skipnl skipempty
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedC_OptReadonlyKeyword namedHL_Option
syn match namedC_OptReadonlyKeyword contained /\<read\-only\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_OptReadonlyBool,
\    namedError

hi link namedC_UnixOptKeysElement namedHL_KeyName
syn match namedC_UnixOptKeysElement contained /[a-zA-Z0-9_\-\.]\+/
\ skipwhite skipnl skipempty
\ contains=namedKeyName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

syn region namedC_UnixOptKeysSection contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=namedC_UnixOptKeysElement
\ nextgroup=
\    namedC_OptReadonlyKeyword,
\    namedSemicolon

hi link namedC_UnixOptKeysKeyword namedHL_Option
syn match namedC_UnixOptKeysKeyword contained /\<keys\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedC_UnixOptKeysSection

hi link namedC_UnixOptGroupInteger namedHL_Number
syn match namedC_UnixOptGroupInteger contained /\d\{1,5}/ 
\ skipwhite skipnl skipempty
\ contains=named_Number_GID
\ nextgroup=
\     namedC_OptReadonlyKeyword,
\     namedC_UnixOptKeysKeyword,
\     namedSemicolon,
\     namedError

hi link namedC_UnixOptGroupKeyword namedHL_Option
syn match namedC_UnixOptGroupKeyword contained /\<group\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_UnixOptGroupInteger,
\    namedError

hi link namedC_UnixOptOwnerInteger namedHL_Number
syn match namedC_UnixOptOwnerInteger contained /\d\{1,5}/ 
\ skipwhite skipnl skipempty
\ contains=namedUserID
\ nextgroup=
\    namedC_UnixOptGroupKeyword,
\    namedError

hi link namedC_UnixOptOwnerKeyword namedHL_Option
syn match namedC_UnixOptOwnerKeyword contained /\<owner\>/ 
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedC_UnixOptOwnerInteger,
\    namedError

hi link namedC_UnixOptPermInteger namedHL_Number
syn match namedC_UnixOptPermInteger /\d\{1,4}/ contained skipwhite skipempty skipnl
\ contains=namedFilePerm
\ nextgroup=namedC_UnixOptOwnerKeyword,namedError

hi link namedC_UnixOptPermKeyword namedHL_Option
syn match namedC_UnixOptPermKeyword /\<perm\>/ contained 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_UnixOptPermInteger,
\    namedError

syn match namedC_UnixOptSocketName contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/
\ skipwhite skipnl skipempty
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

" Dirty trick, use a single '"' char for a string match
hi link namedC_UnixOptSocketName namedHL_Number
syn match namedC_UnixOptSocketName contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ skipwhite skipnl skipempty
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

syn match namedC_UnixOptSocketName contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ skipwhite skipnl skipempty
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

hi link namedC_ClauseUnix namedHL_Option
syn keyword namedC_ClauseUnix contained unix
\ skipwhite skipnl skipempty
\ nextgroup=namedC_UnixOptSocketName

hi link namedC_InetOptReadonlyBool namedHL_Builtin
syn match namedC_InetOptReadonlyBool contained /\i/
\ skipwhite skipnl skipempty
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

hi link namedC_InetOptReadonlyKeyword namedHL_Option
syn match namedC_InetOptReadonlyKeyword contained /read\-only/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptReadonlyBool

syn region namedC_InetAMLSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    named_E_IP6Addr_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedSemicolon,
\    namedInclude,
\    namedComment
\ nextgroup=
\    namedC_InetOptReadonlyKeyword,
\    namedC_UnixOptKeysKeyword,
\    namedSemicolon

hi link namedC_InetOptAllowKeyword namedHL_Option
syn match namedC_InetOptAllowKeyword contained /\<allow\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetAMLSection,namedComment

hi link namedC_InetOptPortWild namedHL_Builtin
syn match namedC_InetOptPortWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptAllowKeyword

hi link namedC_InetOptPortNumber namedHL_Number
syn match namedC_InetOptPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptAllowKeyword

hi link namedC_InetOptPortKeyword namedHL_Option
syn match namedC_InetOptPortKeyword contained /port/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptPortWild,
\    namedC_InetOptPortNumber


hi link namedC_InetOptIPaddrWild namedHL_Builtin
syn match namedC_InetOptIPaddrWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

syn match namedC_InetOptIPaddr contained /[0-9a-fA-F\.:]\{3,45}/ 
\ skipwhite skipnl skipempty
\ contains=named_IP6Addr,named_IP4Addr
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

hi link namedC_ClauseInet namedHL_Option
syn match namedC_ClauseInet contained /\<inet\>/
\ skipnl skipempty skipwhite 
\ nextgroup=
\    namedC_InetOptACLName,
\    namedC_InetOptIPaddrWild,
\    namedC_InetOptIPaddr

syn region namedC_ControlsSection contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    namedC_ClauseInet,
\    namedC_ClauseUnix,
\    namedComment,
\    namedInclude
\ nextgroup=
\    namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'dnssec-policy' statement
" 
" dnssec-policy <domain-name> {
"         dnskey-ttl <duration>;
"         keys { ( csk | ksk | zsk ) [ ( key-directory ) ] lifetime
"             <duration_or_unlimited> algorithm <string> [ <integer> ]; ...
"  };
"         max-zone-ttl <duration>;
"         parent-ds-ttl <duration>;
"         parent-propagation-delay <duration>;
"         parent-registration-delay <duration>;
"         publish-safety <duration>;
"         retire-safety <duration>;
"         signatures-refresh <duration>;
"         signatures-validity <duration>;
"         signatures-validity-dnskey <duration>;
"         zone-propagation-delay <duration>;
" }; // may occur multiple times
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedDp_Duration namedHL_Number
syn match namedDp_Duration contained /\d\{1,10}[sSmMhHdDwW]\{0,1}/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedDp_KeyTtl namedHL_Option
syn keyword namedDp_KeyTtl contained skipwhite skipnl skipempty
\    dnskey-ttl
\ nextgroup=namedDp_Duration

hi link namedDpKs_AlgorithmSize namedHL_Number
syn match namedDpKs_AlgorithmSize contained /\d\{1,10}/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedDpKs_AlgorithmNumber namedHL_String
syn match namedDpKs_AlgorithmNumber contained /\d\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=namedDpKs_AlgorithmSize

hi link namedDpKs_AlgorithmName namedHL_String
syn match namedDpKs_AlgorithmName contained /\S\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=namedDpKs_AlgorithmSize

hi link namedDpKs_Algorithm namedHL_Clause
syn keyword namedDpKs_Algorithm contained algorithm
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedDpKs_AlgorithmNumber,
\    namedDpKs_AlgorithmName

hi link namedDpKs_LifetimeDuration namedHL_Number
hi link namedDpKs_LifetimeUnlimited namedHL_Builtin
syn keyword namedDpKs_LifetimeUnlimited contained unlimited
\ skipwhite skipnl skipempty
\ nextgroup=namedDpKs_Algorithm
syn match namedDpKs_LifetimeDuration contained /\S\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=namedDpKs_Algorithm

hi link namedDpKs_Lifetime namedHL_Clause
syn keyword namedDpKs_Lifetime contained lifetime
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedDpKs_LifetimeDuration,
\    namedDpKs_LifetimeUnlimited

hi link namedDpKs_KeyDirectory namedHL_Clause
syn match namedDpKs_KeyDirectory contained /\S\{1,256}/
\ skipwhite skipnl skipempty
\ nextgroup=namedDpKs_Lifetime

hi link namedDpKs_KeyType namedHL_Option
syn match namedDpKs_KeyType contained 
\    /\(ksk\)\|\(csk\)\|\(zsk\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedDpKs_KeyDirectory,
\    namedDpKs_Lifetime

hi link namedDp_KeysSection White
syn region namedDp_KeysSection contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    namedDpKs_KeyType,
\    namedComment
\ nextgroup=
\    namedComment,
\    namedSemicolon

hi link namedDp_Keys namedHL_Option
syn keyword namedDp_Keys contained skipwhite skipnl skipempty
\    keys
\ nextgroup=namedDp_KeysSection

hi link namedDp_MaxZone namedHL_Option
syn keyword namedDp_MaxZone contained skipwhite skipnl skipempty
\    max-zone-ttl
\ nextgroup=namedDp_Duration

hi link namedDp_ParentDs namedHL_Option
syn keyword namedDp_ParentDs contained skipwhite skipnl skipempty
\    parent-ds-ttl
\ nextgroup=namedDp_Duration

hi link namedDp_ParentPropagation namedHL_Option
syn keyword namedDp_ParentPropagation contained skipwhite skipnl skipempty
\    parent-propagation-delay
\ nextgroup=namedDp_Duration

hi link namedDp_ParentRegistration namedHL_Option
syn keyword namedDp_ParentRegistration contained skipwhite skipnl skipempty
\    parent-registration-delay
\ nextgroup=namedDp_Duration

hi link namedDp_PublishSafety namedHL_Option
syn keyword namedDp_PublishSafety contained skipwhite skipnl skipempty
\    publish-safety
\ nextgroup=namedDp_Duration

hi link namedDp_RetireSafety namedHL_Option
syn keyword namedDp_RetireSafety contained skipwhite skipnl skipempty
\    retire-safety
\ nextgroup=namedDp_Duration

hi link namedDp_SignatureRefresh namedHL_Option
syn keyword namedDp_SignatureRefresh contained skipwhite skipnl skipempty
\    signatures-refresh
\ nextgroup=namedDp_Duration

hi link namedDp_SignatureValidity namedHL_Option
syn keyword namedDp_SignatureValidity contained skipwhite skipnl skipempty
\    signatures-validity
\ nextgroup=namedDp_Duration

hi link namedDp_SignatureValidityDnskey namedHL_Option
syn keyword namedDp_SignatureValidityDnskey contained skipwhite skipnl skipempty
\    signatures-validity-dnskey
\ nextgroup=namedDp_Duration

hi link namedDp_ZonePropagationDelay namedHL_Option
syn keyword namedDp_ZonePropagationDelay contained skipwhite skipnl skipempty
\    zone-propagation-delay
\ nextgroup=namedDp_Duration

syn region namedDp_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    namedDp_KeyTtl,
\    namedDp_Keys,
\    namedDp_MaxZone,
\    namedDp_ParentDs,
\    namedDp_ParentPropagation,
\    namedDp_ParentRegistration,
\    namedDp_PublishSafety,
\    namedDp_RetireSafety,
\    namedDp_SignatureRefresh,
\    namedDp_SignatureValidity,
\    namedDp_SignatureValidityDnskey,
\    namedDp_ZonePropagationDelay,
\    namedComment
\ nextgroup=namedSemicolon

hi link namedDp_DomainName namedHL_String
syn match namedDp_DomainName contained /\S\{1,1023}/
\ skipwhite skipnl skipempty
\ nextgroup=namedDp_Section
hi link namedDp_DomainNameBuiltin namedHL_Builtin
syn keyword namedDp_DomainNameBuiltin contained 
\    none default
\ skipwhite skipnl skipempty
\ nextgroup=namedDp_Section

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'dlz' statement
" 
" dlz <string> {
"        database <string>;
"        search <boolean>;
"     }; // may occur multiple times
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedD_SearchBoolean namedHL_String
syn match namedD_SearchBoolean contained /\i/ skipwhite
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedSemicolon,
\    namedD_DatabaseKeyword

hi link namedD_Search namedHL_Option
syn match namedD_Search contained /\<search\>/ skipwhite
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedD_SearchBoolean,
\    namedD_Database

hi link namedD_DatabaseString namedHL_String
syn region namedD_DatabaseString start=/"/ skip=/\\"/ end=/"/ contained
syn region namedD_DatabaseString start=/'/ skip=/\\'/ end=/'/ contained
\ skipwhite skipnl skipempty
\ contains=named_QuotedString_SC
\ nextgroup=
\    namedSemicolon,
\    namedD_Search

hi link namedD_Database namedHL_Option
syn match namedD_Database contained /\<database\>/ skipwhite
\ nextgroup=namedD_DatabaseString

syn region namedD_DlzSection contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    namedD_Database,
\    namedD_Search
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

hi link namedD_Identifier namedHL_Identifier
syn match namedD_Identifier contained /\<[a-zA-Z0-9_\.\-]\{1,63}\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedD_DlzSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'dyndb' statement
" 
" dyndb <dyndb_name> <device_driver_filename> {
"            <arguments> }; // may occur multiple times
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link   namedDy_DriverParameters namedHL_String
syn match namedDy_DriverParameters contained /[<>\|:"'a-zA-Z0-9_\.\-\/\\]\+[^;]/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

syn region namedDy_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=namedDy_DriverParameters
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

syn match namedDy_DriverFilespec contained 
\ /[a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}/hs=s+1,he=e-1
\ skipwhite skipnl skipempty
\ contains=named_String_QuoteForced
\ nextgroup=namedDy_Section
syn match namedDy_DriverFilespec contained 
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ skipwhite skipnl skipempty
\ contains=named_String_QuoteForced
\ nextgroup=namedDy_Section
syn match namedDy_DriverFilespec contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ skipwhite skipnl skipempty
\ contains=named_String_QuoteForced
\ nextgroup=namedDy_Section

hi link namedStmtDyndbIdent namedHL_Identifier
syn match namedStmtDyndbIdent contained /[a-zA-Z0-9_\.\-]\{1,63}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedDy_DriverFilespec

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'key' statement
" 
" key <key_name> { algorithm <string>; secret <string>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedK_SecretValue namedHL_Base64
syn match namedK_SecretValue contained /["'0-9A-Za-z\+\=\/]\{1,4098}\s*/
\ skipwhite skipnl skipempty
\ contains=namedTypeBase64
\ nextgroup=
\    namedSemicolon,
\    namedError

hi link namedK_Secret namedHL_Option
syn match namedK_Secret contained /\<secret\>/ skipwhite skipnl skipempty
\ nextgroup=
\    namedK_SecretValue,
\    namedError

syn match namedK_AlgorithmName contained /[a-zA-Z0-9\-_\.]\{1,128}\s*/he=e-1
\ skipwhite skipnl skipempty
\ contains=namedKeyAlgorithmName
\ nextgroup=
\    namedSemicolon,
\    namedError

hi link namedK_Algorithm namedHL_Option
syn match namedK_Algorithm contained /\<algorithm\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedK_AlgorithmName,
\    namedError

syn region namedK_Section contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ contains=
\    namedK_Algorithm,
\    namedK_Secret
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

hi link namedStmtKeyIdent namedHL_Identifie
syn region namedStmtKeyIdent contained start=+"+ skip="\\'" end=+"+
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedK_Section,
\    namedNotParem,
\    namedError
syn region namedStmtKeyIdent contained start=+'+ skip="\\'" end=+'+
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedK_Section,
\    namedNotParem,
\    namedError

syn match namedStmtKeyIdent contained /[a-zA-Z0-9_\-]\{1,63}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedK_Section,
\    namedNotParem,
\    namedError

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'logging' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # logging {
"    [ channel <channel_name> {
"        [ buffered <boolean>; ]
"        ( 
"            ( file <path_name>
"                [ versions (<number> |unlimited) ]
"                [ size <size_spec> ]
"                [ suffix ( increment | timestamp ) ]
"             )
"          | stderr;
"          | null;
"          | syslog <log_facility>;
"        )
"      [ severity ( critical | error | warning | notice
"                   info | debug [ <level> ] | dynamic ); ]
"      [ print-category <boolean>; ]
"      [ print-severity <boolean>; ]
"      [ print-time ( iso8601 | iso8601-utc | local | <boolean>) ;  ]
"    }; ]
"    [ category category_name {
"      channel_name ; [ channel_name ; ... ]
"    }; ]
"    ...
" }
hi link namedL_CategoryChannelName namedHL_Type
syn match namedL_CategoryChannelName contained /\i\{1,63}/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

syn region namedL_CategorySection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ contains=namedL_CategoryChannelName
\ nextgroup=namedSemicolon

hi link namedL_CategoryBuiltins namedHL_Builtin
syn keyword namedL_CategoryBuiltins contained skipwhite skipnl skipempty
\    client cname config database default delegation-only dnssec dispatch
\    dnstap edns-disabled general lame-servers
\    network notify nsid queries query-errors 
\    rate-limit resolver rpz security serve-stale spill 
\    trust-anchor-telemetry unmatched update update-security
\    xfer-in xfer-out zoneload 

hi link namedL_CategoryCustom Identifier
syn match namedL_CategoryCustom contained skipwhite /\<\i\{1,63}\>/

hi link namedL_CategoryIdentifier Identifier
syn match namedL_CategoryIdentifier /\<\i\{1,63}\>/ skipwhite contained
\ contains=
\    namedL_CategoryCustom,
\    namedL_CategoryBuiltins
\ nextgroup=
\    namedL_CategorySection,
\    namedError

hi link namedL_Category namedHL_Option
syn match namedL_Category contained /category/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedL_CategoryIdentifier,
\    namedError 

" logging { channel xxxxx { ... }; };

hi link namedL_ChannelSeverityDebugValue namedHL_Number
syn match namedL_ChannelSeverityDebugValue /[0-9]\{1,5}/ 
\ contained skipwhite 
\ nextgroup=
\    namedComment,
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedL_ChannelSeverityDebug namedHL_Builtin
syn match namedL_ChannelSeverityDebug contained /debug\s*[^;]/me=e-1
\ nextgroup=
\    namedL_ChannelSeverityDebugValue,
\    namedComment,
\    namedSemicolon,
\    namedNotSemicolon_SC,
\    namedNotComment,
\    namedError
syn match namedL_ChannelSeverityDebug contained /debug\s*;/he=e-1

hi link namedL_ChannelSeverityType namedHL_Builtin
syn keyword namedL_ChannelSeverityType contained skipwhite
\    info
\    notice
\    warning
\    error
\    critical
\    dynamic
\ nextgroup=
\    namedSemicolon,
\    namedError

hi link namedL_ChannelOptNull namedHL_Clause
syn keyword namedL_ChannelOptNull null contained skipwhite
\ nextgroup=
\    namedComment,
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError
syn keyword namedL_ChannelOptNull stderr contained skipwhite
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedComment,
\    namedError

hi link namedL_ChannelOpts namedHL_Option
syn keyword namedL_ChannelOpts contained skipwhite 
\    buffered
\    print-category
\    print-severity
\ nextgroup=@namedClusterBoolean_SC,namedError

" BUG: You can specify 'severity' twice on same line before semicolon
hi link namedL_ChannelOptSeverity namedHL_Option
syn keyword namedL_ChannelOptSeverity contained severity skipwhite skipempty
\ nextgroup=
\    namedL_ChannelSeverityType,
\    namedL_ChannelSeverityDebug,
\    namedComment,
\    namedError

hi link namedL_ChannelSyslogFacility namedHL_Builtin
syn keyword namedL_ChannelSyslogFacility contained
\    user kern mail daemon
\    auth syslog lpr news
\    uucp cron authpriv
\    local0 local1 local2 local3 local4
\    local5 local6 local7 local8 local9
\ nextgroup=
\    namedSemicolon,
\    namedComment,
\    namedParenError,
\    namedError

hi link namedL_ChannelOptSyslog namedHL_Option
sy keyword namedL_ChannelOptSyslog syslog contained skipwhite 
\ nextgroup=
\    namedL_ChannelSyslogFacilityKern,
\    namedL_ChannelSyslogFacilityUser,
\    namedL_ChannelSyslogFacility,
\    namedParenError,
\    @namedClusterCommonNext,

hi link namedL_ChannelOptPrinttimeISOs namedHL_Builtin
syn keyword namedL_ChannelOptPrinttimeISOs contained skipwhite
\    iso8601
\    iso8601-utc
\    local
\ nextgroup=
\    namedSemicolon,
\    namedComment,
\    namedError

hi link namedL_ChannelOptPrintTime namedHL_Option
syn match namedL_ChannelOptPrintTime /print\-time/ contained skipwhite
\ nextgroup=
\    namedL_ChannelOptPrinttimeISOs,
\    @namedClusterBoolean_SC,
\    namedParenError,
\    @namedClusterCommonNext,
\    namedError,

hi link namedL_ChannelFileVersionOptUnlimited namedHL_Builtin
syn match namedL_ChannelFileVersionOptUnlimited /unlimited/
\ contained skipwhite
\ nextgroup=namedL_ChannelFileOptSuffix,
\           namedL_ChannelFileOptSize,
\           namedSemicolon
syn match namedL_ChannelFileVersionOptInteger contained skipwhite
\    /[0-9]\{1,11}/
\    contains=namedNumber
\ nextgroup=namedL_ChannelFileOptSuffix,
\           namedL_ChannelFileOptSize,
\           namedSemicolon
hi link namedL_ChannelFileOptVersions namedHL_Clause
syn match namedL_ChannelFileOptVersions contained skipwhite /versions/
\ nextgroup=
\    namedL_ChannelFileVersionOptInteger,
\    namedL_ChannelFileVersionOptUnlimited,

hi link namedL_ChannelFileSizeOpt namedHL_Number
" [0-9]\{1,12}\([BbKkMmGgPp]\{1}\)/
syn match namedL_ChannelFileSizeOpt 
\ /[0-9]\{1,11}\([BbKkMmGgPp]\)\{0,1}/
\ contains=named_SizeSpec
\ contained skipwhite
\ nextgroup=namedL_ChannelFileOptSuffix,
\           namedL_ChannelFileOptVersions,
\           namedSemicolon

hi link namedL_ChannelFileOptSize namedHL_Clause
syn match namedL_ChannelFileOptSize /size/
\ contained  skipwhite
\ nextgroup=namedL_ChannelFileSizeOpt

hi link namedL_ChannelFileSuffixOpt namedHL_Builtin
syn match namedL_ChannelFileSuffixOpt contained /\(\(increment\)\|\(timestamp\)\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedL_ChannelFileOptSize,
\    namedL_ChannelFileOptVersions,
\    namedSemicolon

hi link namedL_ChannelFileOptSuffix namedHL_Clause
syn match namedL_ChannelFileOptSuffix contained /suffix/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedL_ChannelFileSuffixOpt,
\    namedEParenError

syn match namedL_ChannelFileIdent contained 
\ /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/
\ contained
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedL_ChannelFileOptSuffix,
\    namedL_ChannelFileOptSize,
\    namedL_ChannelFileOptVersions,
\    namedSemicolon

hi link namedL_ChannelFileIdent namedHL_String
syn match namedL_ChannelFileIdent contained 
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedL_ChannelFileOptSuffix,
\    namedL_ChannelFileOptSize,
\    namedL_ChannelFileOptVersions,
\    namedSemicolon

syn match namedL_ChannelFileIdent contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ contained
\ skipwhite skipnl skipempty
\ contains=named_Filespec
\ nextgroup=
\    namedL_ChannelFileOptSuffix,
\    namedL_ChannelFileOptSize,
\    namedL_ChannelFileOptVersions,
\    namedSemicolon

hi link namedL_ChannelOptFile namedHL_Option
syn match namedL_ChannelOptFile /file/ contained 
\ skipwhite skipempty
\ nextgroup=
\    namedL_ChannelFileIdent,
\    namedParenError

syn region namedL_ChannelSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ contains=
\    namedL_ChannelOpts,
\    namedL_ChannelOptFile,
\    namedL_ChannelOptPrintTime,
\    namedL_ChannelOptSyslog,
\    namedL_ChannelOptNull,
\    namedL_ChannelOptSeverity,
\    namedComment,
\    namedInclude,
\    namedParenError
\ nextgroup=namedSemicolon

hi link namedL_ChannelIdent namedHL_Identifier
syn match namedL_ChannelIdent contained /\S\+/ skipwhite
\ nextgroup=namedL_ChannelSection

hi link namedL_Channel namedHL_Option
syn match namedL_Channel contained /\<channel\>/ skipwhite
\ nextgroup=
\    namedL_ChannelIdent,
\    namedError

syn region namedL_LoggingSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ contains=
\    namedL_Category,
\    namedL_Channel,
\    namedComment,
\    namedInclude,
\    namedParenError
\ nextgroup=namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'managed-keys' statement
"
" managed-keys { <domain> ( static-key | initial-key ) 
"                    <flag_type>
"                         <protocol>
"                             <algorithm_id>
"                                 <key_secret>;
"               ... }; // may occur multiple times, deprecated
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedMk_E_KeySecret namedKeySecretValue
syn match namedMk_E_KeySecret contained /["'0-9A-Za-z\+\=\/]\{1,4098}/ 
\ skipwhite skipnl skipempty
\ contains=namedKeySecretValue
\ nextgroup=namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedMk_E_AlgorithmType namedHL_Number
syn match namedMk_E_AlgorithmType contained /\d\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedMk_E_KeySecret,
\    namedError

hi link namedMk_E_ProtocolType namedHL_Number
syn match namedMk_E_ProtocolType contained /\d\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedMk_E_AlgorithmType,
\    namedError

hi link namedMk_E_FlagType namedHL_Number
syn match namedMk_E_FlagType contained /\d\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedMk_E_ProtocolType,
\    namedError

hi link namedMk_E_InitialKey namedHL_Number
syn match namedMk_E_InitialKey contained /\(static\-key\)\|\(initial\-key\)/
\ skipwhite skipnl skipempty
\ contains=namedString
\ nextgroup=
\    namedMk_E_FlagType,
\    namedError

hi link namedMk_E_DomainName namedHL_Identifier
syn match namedMk_E_DomainName contained /[0-9A-Za-z][_\-0-9A-Za-z.]\{1,1024}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedMk_E_InitialKey,
\    namedError

syn region namedStmt_ManagedKeysSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ contains=namedMk_E_DomainName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" masters <string> [ port <integer> ] 
"                  [ dscp <integer> ] 
"             { ( <masters> | 
"                 <ipv4_address> [ port <integer> ] | 
"                 <ipv6_address> [ port <integer> ] 
"               ) [ key <string> ];
"               ... 
"             }; // may occur multiple times
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedM_KeyName namedHL_Identifier
syn match namedM_KeyName contained /[a-zA-Z][0-9a-zA-Z\-_]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedM_Key namedHL_Clause
syn match namedM_Key contained /\<key\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedM_KeyName,
\    namedError

hi link namedM_IPaddrPortNumber namedHL_Error
syn match namedM_IPaddrPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ contains=named_Port
\ nextgroup=
\    namedM_Key

hi link namedM_IPaddrPort namedHL_Clause
syn match namedM_IPaddrPort contained /\<port\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedM_IPaddrPortNumber,
\    namedError

hi link namedM_MasterName namedHL_Identifier
syn match namedM_MasterName contained /[a-zA-Z][a-zA-Z0-9_\-]\+/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedM_Key,
\    namedSemicolon,
\    namedComment, 
\    namedInclude,
\    namedError

hi link namedM_IP6addr namedHL_Number
syn match namedM_IP6addr contained /[0-9a-fA-F:\.]\{6,48}/
\ skipwhite skipnl skipempty
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedM_IPaddrPort,
\   namedM_Key,
\   namedComment, 
\   namedInclude,
\   namedError

hi link namedM_IP4addr namedHL_Number
syn match namedM_IP4addr contained 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\   namedSemicolon,
\   namedM_IPaddrPort,
\   namedM_Key,
\   namedComment, namedInclude,
\   namedError

syn region namedM_MastersSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    namedInclude,
\    namedComment,
\    namedM_MasterName,
\    namedM_IP4addr,
\    namedM_IP6addr,
\    namedError
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

hi link namedM_Dscp_Number namedHL_Number
syn match namedM_Dscp_Number contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedM_Port,
\    namedM_MastersSection,
\    namedSemicolon

hi link namedM_Dscp  namedHL_Option
syn match namedM_Dscp contained /\<dscp\>/ skipwhite skipnl skipempty
\ nextgroup=namedM_Dscp_Number

hi link namedM_Port_Number namedHL_Number
syn match namedM_Port_Number contained 
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedM_Dscp,
\    namedM_MastersSection,
\    namedSemicolon

hi link namedM_Port  namedHL_Option
syn match namedM_Port contained /\<port\>/ skipwhite skipnl skipempty
\ nextgroup=namedM_Port_Number

hi link namedM_Identifier namedHL_Identifier
syn match namedM_Identifier contained /\<[0-9a-zA-Z\-_\.]\{1,64}/
\ skipwhite skipnl skipempty
\ contains=namedMasterName
\ nextgroup=
\    namedM_Port,
\    namedM_Dscp,
\    namedM_MastersSection,
\    namedComment, namedInclude,
\    namedError

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'options' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedO_Boolean_Group namedHL_Option
syn keyword namedO_Boolean_Group contained skipwhite skipnl skipempty
\     acache-enable
\     additional-from-auth
\     additional-from-cache
\     automatic-interface-scan 
\     answer-cookie
\     deallocate-on-exit
\     fake-iquery
\     geoip-use-ecs
\     has-old-clients
\     host-statistics
\     flush-zones-on-shutdown
\     match-mapped-addresses
\     memstatistics
\     multiple-cnames
\     querylog
\     treat-cr-as-space
\     use-id-pool
\ nextgroup=@namedClusterBoolean_SC

hi link namedO_UdpPorts namedHL_Option
syn match namedO_UdpPorts contained skipwhite skipnl skipempty
\    /\<\(avoid\-v4\-udp\-ports\)\|\(avoid\-v6\-udp\-ports\)\>/
\ nextgroup=
\    named_PortSection,
\    namedInclude,
\    namedComment,
\    namedError

hi link named_Hostname_SC namedHL_Builtin
syn keyword named_Hostname_SC contained skipwhite skipnl skipempty
\    hostname
\ nextgroup=namedSemicolon

hi link namedO_ServerId namedHL_Option
syn keyword namedO_ServerId contained skipwhite skipnl skipempty
\    server-id
\ nextgroup=
\    named_Builtin_None_SC,
\    named_Hostname_SC,
\    named_QuotedDomain_SC

hi link namedO_String_QuoteForced namedHL_Option
syn keyword namedO_String_QuoteForced contained skipwhite skipnl skipempty
\    bindkeys-file
\    cache-file
\    directory
\    dump-file
\    managed-keys-directory
\    memstatistics-file
\    named-xfer
\ nextgroup=
\    named_String_QuoteForced_SC,
\    namedNotString


hi link namedO_Filespec_None namedHL_Builtin
syn keyword namedO_Filespec_None contained skipwhite skipnl skipempty
\    none
\ nextgroup=namedSemicolon

hi link namedO_ListenOn_DscpValue namedHL_Number
syn match namedO_ListenOn_DscpValue contained /\d\{1,11}/
\ skipwhite skipnl skipempty
\ nextgroup=namedA_AML

hi link namedO_ListenOn_Dscp namedHL_Option
syn keyword namedO_ListenOn_Dscp contained dscp skipwhite skipnl skipempty
\ nextgroup=namedO_ListenOn_DscpValue

hi link namedO_ListenOn_PortValue namedHL_Number
syn match namedO_ListenOn_PortValue contained /\d\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML,
\    namedO_ListenOn_Dscp

hi link namedO_ListenOn_Port namedHL_Option
syn keyword namedO_ListenOn_Port contained port skipwhite skipnl skipempty
\ nextgroup=namedO_ListenOn_PortValue

hi link namedO_ListenOn namedHL_Option
syn match namedO_ListenOn contained 
\    /\<\(listen\-on\-v6\)\|\(listen\-on\)\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_ListenOn_Port,
\    namedO_ListenOn_Dscp,
\    namedA_AML,
\    namedInclude,
\    namedComment

hi link namedO_Blackhole namedHL_Option
syn keyword namedO_Blackhole contained blackhole skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML,
\    namedInclude,
\    namedComment

hi link namedO_CheckNamesType namedHL_Builtin
syn match namedO_CheckNamesType contained /primary/ skipwhite skipnl skipempty
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /secondary/ skipwhite skipnl skipempty
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /response/ skipwhite skipnl skipempty
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /master/ skipwhite skipnl skipempty
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /slave/ skipwhite skipnl skipempty
\ nextgroup=named_IgnoreWarnFail_SC 

" not the same as 'check-names' in View or Zone
hi link namedO_CheckNames namedHL_Option
syn keyword namedO_CheckNames contained check-names skipwhite skipnl skipempty
\ nextgroup=
\    namedO_CheckNamesType,
\    namedError

hi link namedO_CookieAlgorithmChoicesObsoleted namedHL_Error
syn match namedO_CookieAlgorithmChoicesObsoleted contained 
\ skipwhite skipnl skipempty
\ /\%(aes\)\|\%(siphash24\)/
\ nextgroup=namedSemicolon,namedError
hi link namedO_CookieAlgorithmChoices namedHL_Type
syn match namedO_CookieAlgorithmChoices contained skipwhite skipnl skipempty
\ /\%(sha256\)\|\%(sha1\)/
\ nextgroup=namedSemicolon,namedError

hi link namedO_CookieAlgs namedHL_Option
syn keyword namedO_CookieAlgs contained cookie-algorithm
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_CookieAlgorithmChoices

hi link namedO_CookieSecretValue namedHL_Identifier
syn match namedO_CookieSecretValue contained /\c['"][0-9a-f]\{32}['"]/
\ skipwhite skipnl skipempty
\ contains=namedHexSecretValue
\ nextgroup=namedSemicolon
syn match namedO_CookieSecretValue contained /\c['"][0-9a-f]\{20}['"]/
\ skipwhite skipnl skipempty
\ contains=namedHexSecretValue
\ nextgroup=namedSemicolon
syn match namedO_CookieSecretValue contained /\c['"][0-9a-f]\{16}['"]/
\ skipwhite skipnl skipempty
\ contains=namedHexSecretValue
\ nextgroup=namedSemicolon

hi link namedO_CookieSecret namedHL_Option
syn keyword namedO_CookieSecret contained cookie-secret
\ skipwhite skipnl skipempty
\ nextgroup=namedO_CookieSecretValue

hi link named_NumberSize_SC namedHL_Number
syn match named_NumberSize_SC contained /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/he=e-1
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedO_DefaultUnlimitedSize namedHL_Option
syn keyword namedO_DefaultUnlimitedSize contained 
\     coresize
\     datasize
\     stacksize
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

hi link namedO_DnstapOutputSuffixType namedHL_Builtin
syn keyword namedO_DnstapOutputSuffixType contained 
\    increment
\    timestamp
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon,
\    namedO_DnstapOutputSize,
\    namedO_DnstapOutputVersions

hi link namedO_DnstapOutputSizeValue namedHL_Number
syn match namedO_DnstapOutputSizeValue contained /[0-9]\{1,10}/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon,
\    namedO_DnstapOutputSuffix,
\    namedO_DnstapOutputVersions
    
hi link namedO_DnstapOutputSizeBuiltin namedHL_Builtin
syn keyword namedO_DnstapOutputSizeBuiltin contained 
\    unlimited
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon,
\    namedO_DnstapOutputSuffix,
\    namedO_DnstapOutputVersions

hi link namedO_DnstapOutputVersionsBuiltin namedHL_Builtin
syn keyword namedO_DnstapOutputVersionsBuiltin contained 
\    unlimited
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon,
\     namedO_DnstapOutputSuffix,
\     namedO_DnstapOutputSize,

hi link namedO_DnstapOutputVersionsNumber namedHL_Number
syn match namedO_DnstapOutputVersionsNumber contained /\d\+/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon,
\    namedO_DnstapOutputSuffix,
\    namedO_DnstapOutputSize

hi link namedO_DnstapOutputVersions namedHL_Clause
syn keyword namedO_DnstapOutputVersions contained versions
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_DnstapOutputVersionsBuiltin,
\    namedO_DnstapOutputVersionsNumber

hi link namedO_DnstapOutputSize namedHL_Clause
syn keyword namedO_DnstapOutputSize contained size 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_DnstapOutputSizeBuiltin,
\    namedO_DnstapOutputSizeValue

hi link namedO_DnstapOutputSuffix namedHL_Clause
syn keyword namedO_DnstapOutputSuffix contained suffix 
\ skipwhite skipnl skipempty
\ nextgroup=namedO_DnstapOutputSuffixType

hi link namedO_DnstapOutputFilespec namedHL_String
syn match namedO_DnstapOutputFilespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|`~!@#$%\^&*\\(\\)+{}]\{1,256}'/hs=s+1,he=e-1 
\ skipwhite skipempty skipnl
\ nextgroup=namedSemicolon,
\    namedO_DnstapOutputSuffix,
\    namedO_DnstapOutputSize,
\    namedO_DnstapOutputVersions

syn match namedO_DnstapOutputFilespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|`~!@#$%\^&*\\(\\)+{}]\{1,256}"/hs=s+1,he=e-1 
\ skipwhite skipempty skipnl
\ nextgroup=namedSemicolon,
\     namedO_DnstapOutputSuffix,
\     namedO_DnstapOutputSize,
\     namedO_DnstapOutputVersions

hi link namedO_DnstapOutputType namedHL_Type
syn keyword namedO_DnstapOutputType contained skipwhite skipnl skipempty
\    file
\    unix
\ nextgroup=namedO_DnstapOutputFilespec

hi link namedO_DnstapOutput namedHL_Option
syn keyword namedO_DnstapOutput contained
\    dnstap-output 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_DnstapOutputType,
\    namedO_DnstapOutputFilespec

hi link namedO_DnstapVersion namedHL_Option
syn keyword namedO_DnstapVersion contained
\    dnstap-version
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_Builtin_None_SC,
\    named_E_Filespec_SC

hi link namedO_DscpNumber namedHL_Number
syn match namedO_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedO_Dscp namedHL_Option
syn keyword namedO_Dscp contained dscp skipwhite skipnl skipempty
\ nextgroup=namedO_DscpNumber

hi link namedO_Fstrm_ModelValue namedHL_Builtin
syn keyword namedO_Fstrm_ModelValue contained
\    mpsc
\    spsc
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedO_Fstrm_Model namedHL_Option
syn keyword namedO_Fstrm_Model contained
\    fstrm-set-output-queue-model
\ skipwhite skipnl skipempty
\ nextgroup=namedO_Fstrm_ModelValue

hi link namedO_InterfaceInterval namedHL_Option
syn keyword namedO_InterfaceInterval contained skipwhite skipnl skipempty
\    interface-interval
\ nextgroup=named_Number_Max28day_SC

hi link namedO_Number_Group namedHL_Option
syn keyword namedO_Number_Group contained skipwhite skipnl skipempty
\    acache-cleaning-interval
\    fstrm-set-buffer-hint
\    fstrm-set-flush-timeout
\    fstrm-set-input-queue-size
\    fstrm-set-output-notify-threshold
\    fstrm-set-output-queue-size
\    fstrm-set-reopen-interval
\    host-statistics-max
\    max-rsa-exponent-size
\    nocookie-udp-size
\    notify-rate
\    recursive-clients
\    reserved-sockets
\    serial-queries
\    serial-query-rate
\    startup-notify-rate
\    statistics-interval
\    tcp-advertised-timeout
\    tcp-clients
\    tcp-idle-timeout
\    tcp-initial-timeout
\    tcp-keepalive-timeout
\    tcp-listen-queue
\    transfer-message-size
\    transfers-in
\    transfers-out
\    transfers-per-ns
\ nextgroup=named_Number_SC

hi link namedO_Ixfr_From_Diff_Opts namedHL_Builtin
syn keyword namedO_Ixfr_From_Diff_Opts contained skipwhite skipnl skipempty
\    primary
\    master
\    secondary
\    slave
\ nextgroup=namedSemicolon

" ixfr-from-differences is different in View/Zone sections
hi link namedO_Ixfr_From_Diff namedHL_Option
syn keyword namedO_Ixfr_From_Diff contained 
\    ixfr-from-differences 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_Ixfr_From_Diff_Opts,
\    @namedClusterBoolean

hi link namedO_KeepResponseOrder namedHL_Option
syn keyword namedO_KeepResponseOrder contained 
\ skipwhite skipnl skipempty
\     keep-response-order 
\ nextgroup=namedA_AML

hi link namedO_RecursingFile namedHL_Option
syn keyword namedO_RecursingFile contained skipwhite skipnl skipempty
\    recursing-file
\ nextgroup=named_E_Filespec_SC

hi link namedO_Filespec_None_ForcedQuoted_Group namedHL_Option
syn keyword namedO_Filespec_None_ForcedQuoted_Group contained 
\ skipwhite skipnl skipempty
\    geoip-directory
\    lock-file
\    pid-file
\    random-device
\ nextgroup=
\    named_E_Filespec_SC,
\    named_Builtin_None_SC

hi link namedO_Filespec_Group namedHL_Option
syn keyword namedO_Filespec_Group contained skipwhite skipnl skipempty
\    secroots-file
\    statistics-file
\ nextgroup=
\    named_E_Filespec_SC,
\    named_Builtin_None_SC

hi link namedO_Port namedHL_Option
syn keyword namedO_Port contained port skipwhite skipnl skipempty
\ nextgroup=named_Port_SC

hi link namedO_SessionKeyAlg namedHL_Option
syn keyword namedO_SessionKeyAlg contained session-keyalg 
\ skipwhite skipnl skipempty
\ nextgroup=named_AlgorithmName_SC

hi link namedO_SessionKeyfile namedHL_Option
syn keyword namedO_SessionKeyfile contained session-keyfile 
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_Filespec_SC,
\    named_Builtin_None_SC

" RNDC/rndc keywords
hi link namedO_DefaultKey namedHL_Option
syn keyword namedO_DefaultKey contained default-key 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedKeyName_SC

hi link namedO_DefaultServer namedHL_Option
syn keyword namedO_DefaultServer contained default-server 
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_E_IP4Addr_SC,
\    named_E_IP6Addr_SC

hi link namedO_DefaultPort namedHL_Option
syn keyword namedO_DefaultPort contained default-port 
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_Port_SC

hi link namedO_TkeyDhkeyId namedHL_Number
syn match namedO_TkeyDhkeyId contained /\d\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedSemicolon

hi link namedO_TkeyDhkeyName namedHL_String
syn match namedO_TkeyDhkeyName contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ skipwhite skipnl skipempty
\ nextgroup=namedO_TkeyDhkeyId
syn match namedO_TkeyDhkeyName contained skipwhite skipempty skipnl
\ /"[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ nextgroup=namedO_TkeyDhkeyId
syn match namedO_TkeyDhkeyName contained skipwhite skipempty skipnl
\ /[a-zA-Z\]\-\[0-9\._,:\\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ 
\ nextgroup=namedO_TkeyDhkeyId

hi link namedO_TkeyDhkey namedHL_Option
syn keyword namedO_TkeyDhkey contained skipwhite skipnl skipempty
\    tkey-dhkey
\ nextgroup=
\    namedO_TkeyDhkeyName

hi link namedO_TkeyDomainName namedHL_String
syn match namedO_TkeyDomainName contained skipwhite skipempty skipnl
\ /'[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ nextgroup=namedSemicolon
syn match namedO_TkeyDomainName contained skipwhite skipempty skipnl
\ /"[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ nextgroup=namedSemicolon
syn match namedO_TkeyDomainName contained skipwhite skipempty skipnl
\ /[a-zA-Z\]\-\[0-9\._,:\\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ 
\ nextgroup=namedSemicolon

hi link namedO_TkeyDomain namedHL_Option
syn keyword namedO_TkeyDomain contained skipwhite skipnl skipempty
\    tkey-domain
\ nextgroup=
\    namedO_TkeyDomainName

hi link namedO_TkeyGSSAPICredential namedHL_Option
syn keyword namedO_TkeyGSSAPICredential contained skipwhite skipnl skipempty
\    tkey-gssapi-credential
\ nextgroup=
\    namedO_TkeyDomainName

hi link namedO_TkeyGSSAPIKeytab namedHL_Option
syn keyword namedO_TkeyGSSAPIKeytab contained skipwhite skipnl skipempty
\    tkey-gssapi-keytab
\ nextgroup=
\    namedO_TkeyDomainName

hi link namedO_Version namedHL_Option
syn keyword namedO_Version contained skipwhite skipnl skipempty
\    version
\ nextgroup=
\    namedO_TkeyDomainName

syn match namedO_UUP_PortEnd contained /\d\{1,5}/ 
\ skipwhite skipnl skipempty
\ contains=named_Port
\ nextgroup=namedSemicolon

syn match namedO_UUP_PortStart contained /\d\{1,5}/ 
\ skipwhite skipnl skipempty
\ contains=named_Port
\ nextgroup=namedO_UUP_PortEnd

hi link namedO_UUP_Port namedHL_Clause
syn keyword namedO_UUP_Port contained range skipwhite skipnl skipempty
\ nextgroup=namedO_UUP_PortStart

syn region namedO_UseUdpPort_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=namedO_UUP_Port
\ nextgroup=namedSemicolon

hi link namedO_UseV6UdpPorts namedHL_Option
syn match namedO_UseV6UdpPorts contained /use\-v6\-udp\-ports/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_UseUdpPort_Section

hi link namedO_UseV4UdpPorts namedHL_Option
syn match namedO_UseV4UdpPorts contained /use\-v4\-udp\-ports/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_UseUdpPort_Section

" syn keyword namedO_Keywords filter-aaaa
" syn keyword namedO_Keywords filter-aaaa-on-v4
" syn keyword namedO_Keywords filter-aaaa-on-v6
" syn keyword namedO_Keywords multiple-cnames
" syn keyword namedO_Keywords nosit-udp-size
" syn keyword namedO_Keywords queryport-port-ports
" syn keyword namedO_Keywords queryport-port-updateinterval
" syn keyword namedO_Keywords response-policy
" syn keyword namedO_Keywords rfc2308-type1
" syn keyword namedO_Keywords sit-secret
" syn keyword namedO_Keywords support-ixfr
" syn keyword namedO_Keywords suppress-initial-notify
" syn keyword namedO_Keywords tkey-domain
" syn keyword namedO_Keywords tkey-gssapi-credential
" syn keyword namedO_Keywords tkey-gssapi-keytab
" syn keyword namedO_Keywords transfer-format
" syn keyword namedO_Keywords trusted-anchor-telemetry
" syn keyword namedO_Keywords version

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'plugin' statement
"
" plugin ( query ) <driver_library> [ 
"                                     { <driver-parameters>
"                                     } ]; // may occur multiple times
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedP_Parameter namedHL_String
syn match namedP_Parameter contained skipwhite skipnl skipempty
\ /"[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|'`~!@#$%\^&*\\(\\)=+\{\}]\{1,1024}"/hs=s+1,he=e-1
syn match namedP_Parameter contained skipwhite skipnl skipempty
\ /'[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)=+\{\}]\{1,1024}'/hs=s+1,he=e-1
syn match namedP_Parameter contained skipwhite skipnl skipempty
\ /[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)=+]\{1,1024}/

syn region namedP_ParametersSection start=+{+ end=+}+ contained 
\ skipwhite skipnl skipempty
\ contains=namedP_Parameter
\ nextgroup=namedSemicolon

hi link namedP_Filespec_SC namedHL_String
syn match namedP_Filespec_SC contained skipwhite skipnl skipempty 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ nextgroup=
\    namedP_ParametersSection,
\    namedSemicolon
syn match namedP_Filespec_SC contained skipwhite skipnl skipempty 
\ /"[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ nextgroup=
\    namedP_ParametersSection,
\    namedSemicolon
syn match namedP_Filespec_SC contained skipwhite skipnl skipempty
\ /[a-zA-Z\]\-\[0-9\._,:\\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ 
\ nextgroup=
\    namedP_ParametersSection,
\    namedSemicolon

hi link namedStmt_Plugin_QueryKeyword namedHL_Option
syn keyword namedStmt_Plugin_QueryKeyword contained query 
\ skipwhite skipnl skipempty
\ nextgroup=namedP_Filespec_SC


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'server' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server-statement-specific syntaxes
hi link namedS_Bool_Group namedHL_Option
syn keyword namedS_Bool_Group contained
\   bogus
\   edns
\   tcp-keepalive
\   tcp-only
\ nextgroup=@namedClusterBoolean_SC
\ skipwhite

hi link namedS_GroupNumber namedHL_Number
syn match namedS_GroupNumber contained /\d\{1,10}/ skipwhite
\ nextgroup=namedSemicolon

hi link namedS_NumberGroup namedHL_Option
syn keyword namedS_NumberGroup contained
\ skipwhite
\    edns-version
\    padding
\    transfers
\ nextgroup=namedS_GroupNumber

hi link namedS_Keys_Id namedHL_String
syn match namedS_Keys_Id contained /[a-zA-Z0-9_\-]\{1,63}/ skipwhite
\ nextgroup=namedSemicolon

hi link namedS_Keys namedHL_Option
syn keyword namedS_Keys contained keys skipwhite
\ nextgroup=namedS_Keys_Id

" syn keyword namedStmtServerKeywords support-ixfr


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'view' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedV_Plugin namedHL_Option
syn keyword namedV_Plugin contained plugin
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedStmt_Plugin_QueryKeyword
\ containsin=namedStmt_ViewSection

" view statement - minute_type
hi link namedV_MinuteGroup namedHL_Option
syn keyword namedV_MinuteGroup contained 
\    heartbeat-interval
\ skipwhite
\ nextgroup=
\    namedTypeMinutes,
\    namedComment,
\    namedError

hi link namedV_FilespecGroup namedHL_Option
syn keyword namedV_FilespecGroup contained
\ skipwhite
\    cache-file
\    managed-keys-directory
\ nextgroup=
\    named_String_QuoteForced_SC,
\    namedNotString

hi link namedV_Match namedHL_Option
syn keyword namedV_Match contained skipwhite
\    match-clients
\    match-destinations
\ nextgroup=
\    namedA_AML,
\    namedError

hi link namedV_Key namedHL_Option
syn  keyword namedV_Key  contained key skipwhite
\ nextgroup=
\    namedStmtKeyIdent,
\    namedStmtKeySection

hi link namedV_Boolean_Group namedHL_Option
syn  keyword namedV_Boolean_Group  contained skipwhite
\    match-recursive-only
\ nextgroup=@namedClusterBoolean_SC

" syn keyword namedV_Keywords filter-aaaa
" syn keyword namedV_Keywords filter-aaaa-on-v4
" syn keyword namedV_Keywords filter-aaaa-on-v6
" syn keyword namedV_Keywords multiple-cnames
" syn keyword namedV_Keywords nosit-udp-size
" syn keyword namedV_Keywords queryport-port-ports
" syn keyword namedV_Keywords queryport-port-updateinterval
" syn keyword namedV_Keywords rfc2308-type1
" syn keyword namedV_Keywords support-ixfr
" syn keyword namedV_Keywords suppress-initial-notify
" syn keyword namedV_Keywords transfer-format

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'zone' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedZ_Boolean_Group namedHL_Option
syn keyword namedZ_Boolean_Group contained skipwhite
\    delegation-only
\ nextgroup=@namedClusterBoolean_SC

hi link namedZ_File namedHL_Option
syn keyword namedZ_File contained file skipwhite
\ nextgroup=named_String_QuoteForced_SC,namedNotString

hi link namedZ_InView namedHL_Option
syn keyword namedZ_InView contained in-view 
\ skipwhite skipnl skipempty
\ nextgroup=named_E_ViewName_SC

hi link namedZ_Filespec_Group namedHL_Option
syn keyword namedZ_Filespec_Group contained journal 
\ skipwhite skipnl skipempty
\ nextgroup=named_E_Filespec_SC

hi link namedZ_Masters namedHL_Option
syn keyword namedZ_Masters contained masters skipwhite skipnl skipempty
\ nextgroup=
\    namedComment,
\    namedInclude,
\    namedM_Port,
\    namedM_Dscp,
\    namedM_MastersSection,
\    namedError

hi link namedOVZ_DefaultUnlimitedSize_Group namedHL_Option
syn keyword namedOVZ_DefaultUnlimitedSize_Group contained 
\    max-journal-size
\    max-ixfr-log-size
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

hi link namedZ_Database namedHL_Option
syn keyword namedZ_Database contained database skipwhite
\ nextgroup=named_E_Filespec_SC

hi link namedZ_ServerAddresses namedHL_Option
syn keyword namedZ_ServerAddresses contained skipwhite
\    server-addresses
\ nextgroup=namedA_AML

hi link namedZ_ServerNames namedHL_Option
syn keyword namedZ_ServerNames contained server-names skipwhite
\ nextgroup=namedA_AML

hi link namedZ_ZoneTypes namedHL_Builtin
syn keyword namedZ_ZoneTypes contained 
\    primary
\    master
\    secondary
\    slave
\    mirror
\    hint
\    stub
\    static-stub
\    forward
\    redirect
\    delegation-only
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedZ_ZoneType namedHL_Option
syn keyword namedZ_ZoneType contained type 
\ skipwhite skipnl skipempty
\ nextgroup=namedZ_ZoneTypes

hi link namedZ_DnssecPolicyName namedHL_String
syn match namedZ_DnssecPolicyName contained /\<[a-zA-Z0-9\.\-_]\{1,64}\>/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
hi link namedZ_DnssecPolicy namedHL_Option
syn keyword namedZ_DnssecPolicy contained dnssec-policy
\ skipwhite skipnl skipempty
\ nextgroup=named_E_Domain_SC

" update-policy local
" update-policy { ( deny | grant ) 
"                     <key_name>
"                     ( 6to4-self | external | krb5-self | krb5-selfsub | 
"                       krb5-subdomain | ms-self | ms-selfsub | ms-subdomain | 
"                       name | self | selfsub | selfwild | subdomain | 
"                       tcp-self | wildcard | zonesub ) 
"                     [ <domain_name> ]
"                     <rrtypelist>; 
"                  ... 
"                };
" Most broadest pattern first
hi link namedZ_UP_DomainName namedHL_DomainName
syn match namedZ_UP_DomainName contained /\<[0-9A-Za-z][_\-0-9A-Za-z\.]\{1,256}\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedZ_UP_RRTypeList

" From IANA DNS Assignment Parameter List
" https://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-4
hi link namedZ_UP_RRTypeList namedHL_Type
" Reordered from largest fixed to smallest fixed, then alphanumeric order
" 1-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<[A\*]\{1,1}\>/
\ nextgroup=namedSemicolon
" 2-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(A6\)\|\(DS\)\|\(KX\)\|\(LP\)\|\(MB\)\|\(MD\)\>/
\ nextgroup=namedSemicolon
" 2-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(MF\)\|\(MG\)\|\(MP\)\|\(MR\)\|\(MX\)\|\(NS\)\>/
\ nextgroup=namedSemicolon
" 2-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(PX\)\|\(RP\)\|\(RT\)\|\(TA\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(APL\)\|\(AVC\)\|\(CAA\)\|\(CDS\)\|\(DOA\)\|\(DLV\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(EID\)\|\(GID\)\|\(HIP\)\|\(L32\)\|\(L64\)\|\(LOC\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(KEY\)\|\(OPT\)\|\(NID\)\|\(NXT\)\|\(PTR\)\|\(SIG\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(SOA\)\|\(SPF\)\|\(SRV\)\|\(TXT\)\|\(UID\)\|\(URI\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(X25\)\|\(WKS\)\|\(ANY\)\>/
\ nextgroup=namedSemicolon
" 4-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(AAAA\)\|\(ATMA\)\|\(AXFR\)\|\(CERT\)\|\(GPOS\)\>/
\ nextgroup=namedSemicolon
" 4-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(ISDN\)\|\(IXFR\)\|\(NSAP\)\|\(NSEC\)\|\(NULL\)\>/
\ nextgroup=namedSemicolon
" 4-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(RKEY\)\|\(SINK\)\|\(TKEY\)\|\(TLSA\)\|\(TSIG\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(AFSDB\)\|\(CNAME\)\|\(CSYNC\)\|\(DHCID\)\|\(DNAME\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(EUI48\)\|\(EUI64\)\|\(HINFO\)\|\(MAILA\)\|\(MAILB\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(MINFO\)\|\(NAPTR\)\|\(NINFO\)\|\(NSEC3\)\|\(RRSIG\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(SSHFP\)\|\(UINFO\)\>/
\ nextgroup=namedSemicolon
" 6-char RRTYpe name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(DNSKEY\)\|\(NIMLOC\)\|\(SMIMEA\)\|\(TALINK\)\|\(UNSPEC\)\|\(ZONEMD\)\>/
\ nextgroup=namedSemicolon
" 7-char RRType name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(CDSKEY\)\>/
\ nextgroup=namedSemicolon
" 8-char RRType name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(AMTRELAY\)\|\(IPSECKEY\)\|\(NSAP\-PTR\)\>/
\ nextgroup=namedSemicolon
" 10 or more char RRType name
syn match namedZ_UP_RRTypeList contained
\    /\c\<\(NSEC3PARAM\)\|\(OPENPGPKEY\)\>/
\ nextgroup=namedSemicolon

hi link namedZ_UP_KeyType namedHL_Type
syn match namedZ_UP_KeyType contained skipwhite skipnl skipempty
\    /\<\(6to4\-self\)\|\(krb5\-self\)\|\(krb5\-selfsub\)\|\(krb5\-subdomain\)\>/
\ nextgroup=
\    namedZ_UP_RRTypeList,
\    namedZ_UP_DomainName,
syn keyword namedZ_UP_KeyType contained skipwhite skipnl skipempty
\    external
\    ms-self
\    ms-selfsub
\    ms-subdomain
\    name
\    self
\    selfsub
\    selfwild
\    subdomain
\    tcp-self wildcard zonesub
\ nextgroup=
\    namedZ_UP_RRTypeList,
\    namedZ_UP_DomainName,

hi link namedZ_UP_KeyName namedHL_KeyName
syn match namedZ_UP_KeyName contained 
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedZ_UP_KeyType

hi link namedZ_UP_Action namedHL_Builtin
syn keyword namedZ_UP_Action contained skipwhite skipnl skipempty
\    deny
\    grant
\ nextgroup=
\    namedZ_UP_KeyName

syn region namedZ_UP_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    namedZ_UP_Action,
\    namedComment,
\    namedInclude
\ nextgroup=
\    namedSemicolon

hi link namedZ_UP_Local namedHL_Builtin
syn keyword namedZ_UP_Local contained local skipwhite skipnl skipempty
\ nextgroup=
\    namedSemicolon

hi link namedZ_UpdatePolicy namedHL_Option
syn keyword namedZ_UpdatePolicy contained update-policy
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedZ_UP_Local,
\    namedZ_UP_Section,
\    namedComment,
\    namedInclude

" syn keyword namedZ_Keywords update-policy

" syn keyword namedO_KeywordsObsoleted acache-cleaning-interval
" syn keyword namedO_KeywordsObsoleted acache-enable
" syn keyword namedO_KeywordsObsoleted additional-from-auth
" syn keyword namedO_KeywordsObsoleted additional-from-cache
" syn keyword namedO_KeywordsObsoleted fake-iquery
" syn keyword namedO_KeywordsObsoleted max-acache-size
" syn keyword namedO_KeywordsObsoleted serial-queries
" syn keyword namedO_KeywordsObsoleted use-ixfr
" syn keyword namedO_KeywordsObsoleted use-queryport-pool
" syn keyword namedO_KeywordsObsoleted use-queryport-updateinterval

" syn keyword namedStmtServerKeywordsObsoleted edns-udp-size
" syn keyword namedStmtServerKeywordsObsoleted keys
" syn keyword namedStmtServerKeywordsObsoleted transfer-format
" syn keyword namedStmtServerKeywordsObsoleted transfer-source
" syn keyword namedStmtServerKeywordsObsoleted transfer-source-v6

" syn keyword namedV_KeywordsObsoleted max-acache-size
" syn keyword namedV_KeywordsObsoleted use-queryport-pool
" syn keyword namedV_KeywordsObsoleted use-queryport-updateinterval

" syn keyword namedZ_KeywordsObsoleted ixfr-base
" syn keyword namedZ_KeywordsObsoleted pubkey
" syn keyword namedZ_KeywordsObsoleted use-id-pool

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Both 'options' and 'servers' only.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOS_Boolean_Group namedHL_Option
syn match namedOS_Boolean_Group contained 
\ skipwhite skipnl skipempty
\    /tcp-keepalive/
\ nextgroup=@namedClusterBoolean_SC

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Had to break up namedOSV_Number_UdpSize  due to cross-branch 
" and overlapping REGEX contamination
hi link namedO_Number_UdpSize namedHL_Number
hi link namedS_Number_UdpSize namedHL_Number
hi link namedV_Number_UdpSize namedHL_Number
syn match namedO_Number_UdpSize contained 
\     /\(409[0-6]\)\|\(40[0-8][0-9]\)\|\([1-3][0-9][0-9][0-9]\)\|\([6-9][0-9][0-9]\)\|\(5[2-9][0-9]\)\|\(51[2-9]\)/
\ skipwhite 
\ containedin=namedO_UdpSize
\ nextgroup=namedSemicolon,namedError

syn match namedS_Number_UdpSize contained 
\     /\(409[0-6]\)\|\(40[0-8][0-9]\)\|\([1-3][0-9][0-9][0-9]\)\|\([6-9][0-9][0-9]\)\|\(5[2-9][0-9]\)\|\(51[2-9]\)/
\ skipwhite 
\ containedin=namedS_UdpSize
\ nextgroup=namedSemicolon,namedError

syn match namedV_Number_UdpSize contained 
\     /\%(409[0-6]\)\|\%(40[0-8][0-9]\)\|\%([1-3][0-9][0-9][0-9]\)\|\%([6-9][0-9][0-9]\)\|\%(5[2-9][0-9]\)\|\%(51[2-9]\)/
\ skipwhite 
\ containedin=namedV_UdpSize
\ nextgroup=namedSemicolon,namedError

hi link namedO_UdpSize namedHL_Option
syn match namedO_UdpSize contained 
\    /\(edns-udp-size\)\|\(max-udp-size\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedO_Number_UdpSize,namedError

hi link namedS_UdpSize namedHL_Option
syn match namedS_UdpSize contained 
\    /\(edns-udp-size\)\|\(max-udp-size\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedS_Number_UdpSize,namedError

hi link namedV_UdpSize namedHL_Option
syn match namedV_UdpSize contained 
\    /\(edns-udp-size\)\|\(max-udp-size\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedV_Number_UdpSize,namedError

" query-source [address] 
"              ( * | <ip4_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" query-source [ [ address ] 
"                ( * | <ip4_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];

hi link namedOSV_QuerySource_Dscp namedHL_Option
syn keyword namedOSV_QuerySource_Dscp contained dscp 
\ skipwhite skipnl skipempty
\ nextgroup=named_Dscp_SC

" Specifying port in query-source restricts port randomization, so error that
hi link namedOSV_QuerySource_PortValue namedHL_Number
syn match namedOSV_QuerySource_PortValue contained 
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Dscp,
\    namedSemicolon
hi link namedOSV_QuerySource_PortWild namedHL_Builtin
syn match namedOSV_QuerySource_PortWild contained 
\    /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Dscp,
\    namedSemicolon

hi link namedOSV_QuerySource_Port namedHL_Option
syn keyword namedOSV_QuerySource_Port contained port 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_PortWild,
\    namedOSV_QuerySource_PortValue

hi link namedOSV_QuerySource_IP4Addr namedHL_Number
syn match namedOSV_QuerySource_IP4Addr contained 
\ skipwhite skipnl skipempty
\     /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon

hi link namedOSV_QuerySource_Address namedHL_Option
syn keyword namedOSV_QuerySource_Address contained address 
\ skipwhite skipnl skipempty
\ nextgroup=namedOSV_QuerySource_IP4Addr

hi link namedOSV_QuerySource namedHL_Option
syn keyword namedOSV_QuerySource contained 
\ skipwhite skipnl skipempty
\    query-source
\ nextgroup=
\    namedOSV_QuerySource_Address,
\    namedOSV_QuerySource_IP4Addr,
\    namedOSV_QuerySource_Port

" query-source-v6 [address] 
"              ( * | <ip6_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" query-source-v6 [ [ address ] 
"                ( * | <ip6_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link namedOSV_QuerySource_IP6Addr namedHL_Number
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedOSV_QuerySource_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedOSV_QuerySource_IP6Addr contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedOSV_QuerySource_IP6Addr contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedOSV_QuerySource_IP6Addr contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSV_QuerySource_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSV_QuerySource_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedOSV_QuerySource_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSV_QuerySource_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon

hi link namedOSV_QuerySource_Address6 namedHL_Option
syn keyword namedOSV_QuerySource_Address6 contained address 
\ skipwhite skipnl skipempty
\ nextgroup=namedOSV_QuerySource_IP6Addr

hi link namedOSV_QuerySourceIP6 namedHL_Option
syn match namedOSV_QuerySourceIP6 contained 
\    /\<query\-source\-v6\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_QuerySource_Address6,
\    namedOSV_QuerySource_IP6Addr,
\    namedOSV_QuerySource_Port

hi link namedOSV_TransferFormat_Builtin namedHL_Builtin
syn keyword namedOSV_TransferFormat_Builtin contained 
\ skipwhite skipnl skipempty
\    many-answers
\    one-answer
\ nextgroup=namedSemicolon

hi link namedOSV_TransferFormat namedHL_Option
syn keyword namedOSV_TransferFormat contained transfer-format 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSV_TransferFormat_Builtin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOV_SizeSpec_Group namedHL_Option
syn keyword namedOV_SizeSpec_Group contained skipwhite skipnl skipempty
\    lmdb-mapsize
\ nextgroup=named_SizeSpec_SC

hi link namedOV_DefaultUnlimitedSize_Group namedHL_Option
syn keyword namedOV_DefaultUnlimitedSize_Group contained 
\ skipwhite skipnl skipempty
\    max-cache-size
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

" <0-30000> millisecond
hi link namedOV_Interval_Max30ms_Group namedHL_Option
syn keyword namedOV_Interval_Max30ms_Group contained 
\ skipwhite skipnl skipempty
\    resolver-query-timeout
\    resolver-retry-interval
\ nextgroup=named_Interval_Max30ms_SC

hi link namedOV_Ttl_Group namedHL_Option
syn keyword namedOV_Ttl_Group contained 
\ skipwhite skipnl skipempty
\    lame-ttl
\    servfail-ttl
\ nextgroup=named_Ttl_Max30min_SC

hi link namedOV_Ttl90sec_Group namedHL_Option
syn keyword namedOV_Ttl90sec_Group contained 
\ skipwhite skipnl skipempty
\    min-cache-ttl
\    min-ncache-ttl
\ nextgroup=named_Ttl_Max90sec_SC

hi link namedOV_Ttl_Max3h_Group namedHL_Option
syn keyword namedOV_Ttl_Max3h_Group contained skipwhite skipnl skipempty
\    max-ncache-ttl
\ nextgroup=named_Ttl_Max3hour_SC

hi link namedOV_Ttl_Max1week_Group namedHL_Option
syn keyword namedOV_Ttl_Max1week_Group contained skipwhite skipnl skipempty
\    nta-lifetime
\    nta-recheck
\    max-cache-ttl
\ nextgroup=named_Ttl_Max1week_SC

" view statement - hostname [ none | <domain_name> ];
hi link named_Builtin_None_SC namedHL_Builtin
syn match named_Builtin_None_SC contained /none/ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOV_Hostname namedHL_Option
syn keyword namedOV_Hostname contained hostname skipwhite skipnl skipempty
\ nextgroup=
\    named_Builtin_None_SC,
\    named_QuotedDomain_SC

hi link namedOV_DnssecLookasideOptKeyname namedHL_String
syn match namedOV_DnssecLookasideOptKeyname contained 
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ nextgroup=namedSemicolon
\ skipwhite skipnl skipempty

hi link namedOV_DnssecLookasideOptTD namedHL_Clause
syn keyword namedOV_DnssecLookasideOptTD contained 
\ skipwhite skipnl skipempty
\    trust-anchor
\ nextgroup=namedOV_DnssecLookasideOptKeyname

hi link namedOV_DnssecLookasideOptDomain namedHL_String
syn match namedOV_DnssecLookasideOptDomain contained 
\    /[0-9A-Za-z][-0-9A-Za-z\.\-_]\+/ 
\ nextgroup=namedOV_DnssecLookasideOptTD
\ skipwhite skipnl skipempty

hi link namedOV_DnssecLookasideOptAuto namedHL_Error
syn keyword namedOV_DnssecLookasideOptAuto contained auto
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOV_DnssecLookasideOpt namedHL_Type
syn keyword namedOV_DnssecLookasideOpt contained no
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

" dnssec-lookaside [ auto | no | <domain_name> trusted-anchor <key_name>];
hi link namedOV_DnssecLookasideKeyword namedHL_Option
syn keyword namedOV_DnssecLookasideKeyword contained
\    dnssec-lookaside
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_DnssecLookasideOpt,
\    namedOV_DnssecLookasideOptDomain,
\    namedOV_DnssecLookasideOptAuto

hi link namedOV_Boolean_Group namedHL_Option
syn match namedOV_Boolean_Group contained /rfc2308\-type1/
\ skipwhite skipnl skipempty
\ nextgroup=@namedClusterBoolean_SC

syn keyword namedOV_Boolean_Group contained
\ skipwhite skipnl skipempty
\    allow-new-zones
\    auth-nxdomain 
\    dnsrps-enable
\    dnssec-accept-expired
\    dnssec-enable
\    empty-zones-enable
\    fetch-glue
\    glue-cache
\    message-compression
\    minimal-any
\    recursion
\    require-server-cookie
\    root-key-sentinel
\    stale-answer-enable
\    suppress-initial-notify
\    synth-from-dnssec
\    trust-anchor-telemetry
\ nextgroup=@namedClusterBoolean_SC

hi link namedOV_Filespec namedHL_Option
syn keyword namedOV_Filespec contained
\    new-zones-directory
\ skipwhite skipnl skipempty
\ nextgroup=named_E_Filespec_SC

" allow-query-cache { <address_match_list>; };
" allow-query-cache-on { <address_match_list>; };
" allow-recursion { <address_match_list>; };
" allow-recursion-on { <address_match_list>; };

hi link namedOV_IP4Addr namedHL_Number
syn match namedOV_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/

syn region namedOV_AML_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    namedOV_IP4Addr_SC
\ nextgroup=
\    namedSemicolon,
\    namedParenError
\ containedin=
\    namedElementAMLSection,

hi link namedOV_AML_Group namedHL_Option
syn keyword namedOV_AML_Group contained skipwhite skipnl skipempty
\    allow-query-cache
\    allow-query-cache-on
\    allow-recursion
\    allow-recursion-on
\    no-case-compress
\    sortlist
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen

hi link namedOV_AttachCache namedHL_Option
syn keyword namedOV_AttachCache contained attach-cache skipwhite skipnl skipempty
\ nextgroup=
\    named_E_ViewName_SC,
\    namedError

hi link namedOV_Number_Group namedHL_Option
syn keyword namedOV_Number_Group contained
\    clients-per-query 
\    max-clients-per-query 
\    resolver-nonbackoff-tries
\    max-recursion-depth
\    max-recursion-queries
\    max-stale-ttl
\    min-roots
\    stale-answer-ttl
\    v6-bias
\ skipwhite skipnl skipempty
\ nextgroup=named_Number_SC
syn match namedOV_Number_Group contained
\    /v6\-bias/
\ skipwhite skipnl skipempty
\ nextgroup=named_Number_SC



hi link namedOV_DnsrpsElement namedHL_String
syn region namedOV_DnsrpsElement start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOV_DnsrpsOptionsSection

syn region namedOV_DnsrpsElement start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOV_DnsrpsOptionsSection

syn region namedOV_DnsrpsOptionsSection contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

hi link namedOV_DnsrpsOptions namedHL_Option
syn keyword namedOV_DnsrpsOptions contained
\    dnsrps-options
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_DnsrpsOptionsSection

" deny-answer-addresses { <address_match_element>; ... }
"                       [ except-from { <domain_name>; ... } ];

syn match namedOV_DenyAnswerElementDomainName /['"][_\-0-9A-Za-z\.]\{1,1024}['"]/
\ contained skipwhite skipnl skipempty 
\ contains=namedDomain
\ nextgroup=namedSemicolon

" deny-answer-addresses { <AML>; } [ except-from { <domain_name>; }; } ];
syn region namedOV_DenyAnswerExceptSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedOV_DenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedSemicolon

hi link namedOV_DenyAnswerExceptFromKeywords namedHL_Option
syn match namedOV_DenyAnswerExceptFromKeywords contained 
\    /\<except\-from\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_DenyAnswerExceptSection
 
hi link namedOV_DenyAnswerExceptFrom namedHL_Option
syn keyword namedOV_DenyAnswerExceptFrom contained from 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_DenyAnswerExceptSection

" deny-answer-addresses { <AML>; } [ except-from { ... }; } ];
hi link namedOV_DenyAnswerExceptKeyword namedHL_Option
syn keyword namedOV_DenyAnswerExceptKeyword contained except
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_DenyAnswerExceptFrom

" deny-answer-addresses { <AML>; } ...
syn region namedOV_DenyAnswerAddrSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedOV_DenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedOV_DenyAnswerExceptKeyword,
\    namedOV_DenyAnswerExceptFromKeywords,
\    namedSemicolon

" deny-answer-addresses { } ...
hi link namedOV_DenyAnswerAddresses namedHL_Option
syn keyword namedOV_DenyAnswerAddresses contained 
\    deny-answer-addresses
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DenyAnswerAddrSection

" deny-answer-aliases { <domain_name>; ... } 
"                     [ except-from { <domain_name>; ... } ];
syn region namedOV_DenyAnswerAliasSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    named_E_ACLName_SC,
\    namedOV_DenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedOV_DenyAnswerExceptKeyword,
\    namedOV_DenyAnswerExceptFromKeywords,
\    namedSemicolon

" deny-answer-aliases { } ...
hi link namedStmtOptionsViewDenyAnswerAliasKeyword namedHL_Option
syn keyword namedStmtOptionsViewDenyAnswerAliasKeyword contained 
\    deny-answer-aliases
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DenyAnswerAliasSection
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" disable-algorithms <name> { <algo_name>; ... };
hi link namedOV_DisableAlgosElementName namedHL_String
syn match namedOV_DisableAlgosElementName contained 
\   /['"]\?[a-zA-Z0-9\.\-_]\{1,64}['"]\?/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOV_DisableAlgosSection

" disable-algorithms <name> { ...; };
syn region namedOV_DisableAlgosSection contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

" disable-algorithms <name> { ... };
hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /[a-zA-Z0-9\.\-_]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DisableAlgosSection

hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /"[a-zA-Z0-9\.\-_]\{1,64}"/
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DisableAlgosSection

hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /'[a-zA-Z0-9\.\-_]\{1,64}'/
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DisableAlgosSection

" disable-algorithms <name> ...
hi link namedOV_DisableAlgorithms namedHL_Option
syn keyword namedOV_DisableAlgorithms contained 
\    disable-algorithms
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DisableAlgosIdent

" disable-ds-digests <name> ...
hi link namedOV_DisableDsDigests namedHL_Option
syn keyword namedOV_DisableDsDigests contained 
\    disable-ds-digests
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DisableAlgosIdent

hi link namedOV_DisableEmptyZone namedHL_Option
syn keyword namedOV_DisableEmptyZone contained skipwhite skipnl skipempty
\    disable-empty-zone 
\ nextgroup=
\    namedElementZoneName,
\    namedError

hi link namedOV_Dns64Element namedHL_Option
" dns64 <netprefix> { break-dnssec <boolean>; };
syn keyword namedOV_Dns64Element contained 
\    break-dnssec
\    recursive-only
\ skipwhite skipnl skipempty
\ nextgroup=@namedClusterBoolean_SC


" dns64 <netprefix> { clients { xxx; }; };
syn region namedOV_Dns64ClientsSection contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedInclude,
\    namedComment 
\ nextgroup=namedSemicolon

" dns64 <netprefix> { suffix <ip6_addr>; };
syn keyword namedOV_Dns64Element contained suffix
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_ACLName_SC
" \    named_E_IP4AddrPrefix_SC,  " 9.17 removed IPv4Prefix
" \    named_E_IP4Addr_SC,        " 9.17 removed IPv4

" dns64 <netprefix> { break-dnssec <bool>; };
syn match namedOV_Dns64Element contained 
\    /\(break-dnssec\)\|\(recursive-only\)/
\ skipwhite skipnl skipempty
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

" dns64 <netprefix> { mapped { ... }; };
syn keyword namedOV_Dns64Element contained 
\    clients
\    exclude
\    mapped
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_Dns64ClientsSection

" dns64 <netprefix> { <AML>; };
syn region namedOV_Dns64Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=namedOV_Dns64Element
\ nextgroup=namedSemicolon

" dns64 <netprefix> { 
hi link namedOV_Dns64Ident namedError
syn match namedOV_Dns64Ident contained /[0-9a-fA-F:%\.\/]\{7,48}/
\ contained skipwhite skipempty
\ contains=named_IP4AddrPrefix,named_IP6AddrPrefix
\ nextgroup=namedOV_Dns64Section

" dns64 <netprefix> 
hi link namedOV_Dns64 namedHL_Option
syn match namedOV_Dns64 contained /\<dns64\>/ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_Dns64Ident,
\    namedError
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" dns64-contact <string>
" dns64-server <string>
hi link namedOV_Dns64_Group namedHL_Option
syn match namedOV_Dns64_Group contained skipwhite skipnl skipempty
\    /\(\<dns64\-contact\>\)\|\(dns64\-server\)/
\ nextgroup=
\    named_QuotedDomain_SC,
\    namedError
syn keyword namedOV_Dns64_Group contained skipwhite skipnl skipempty
\    empty-server
\    empty-contact
\ nextgroup=
\    named_QuotedDomain_SC,
\    namedError

hi link named_Auto_SC namedHL_Builtin
syn match named_Auto_SC contained /auto/ skipwhite
\ nextgroup=namedSemicolon

" dnssec-validation [ yes | no | auto ];
hi link namedOV_DnssecValidation namedHL_Option
syn keyword namedOV_DnssecValidation contained 
\    dnssec-validation
\ skipwhite
\ nextgroup=
\    @namedClusterBoolean_SC,
\    named_Auto_SC

" dnstap { ... };
hi link namedOV_DnstapClauses namedHL_Builtin
syn keyword namedOV_DnstapClauses contained
\    query
\    response
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOV_DnstapOpts namedHL_Type
syn keyword namedOV_DnstapOpts contained 
\    all 
\    auth
\    client
\    forwarder
\    resolver
\    update
\ skipwhite
\ nextgroup=namedOV_DnstapClauses,namedSemicolon

syn region namedOV_DnstapSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ nextgroup=namedSemicolon
\ contains=namedOV_DnstapOpts

hi link namedOV_Dnstap namedHL_Option
syn keyword namedOV_Dnstap contained 
\    dnstap
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DnstapSection

hi link namedOV_FetchQuotaParamsHigh namedHL_Number
syn match namedOV_FetchQuotaParamsHigh contained /\d\{1,10}\.\d/ skipwhite nextgroup=namedSemicolon

hi link namedOV_FetchQuotaParamsMed namedHL_Number
syn match namedOV_FetchQuotaParamsMed contained
\    /\d\{1,10}\.\d/
\ skipwhite
\ nextgroup=namedOV_FetchQuotaParamsHigh

hi link namedOV_FetchQuotaParamsLow namedHL_Number
syn match namedOV_FetchQuotaParamsLow contained
\    /\d\{1,10}\.\d/
\ skipwhite
\ nextgroup=namedOV_FetchQuotaParamsMed

hi link namedOV_FetchQuotaParamsRecalPerQueries namedHL_Number
syn match namedOV_FetchQuotaParamsRecalPerQueries contained
\    /\d\{1,10}/
\ skipwhite
\ nextgroup=namedOV_FetchQuotaParamsLow

hi link namedOV_FetchQuotaParams namedHL_Option
syn keyword namedOV_FetchQuotaParams contained fetch-quota-params skipwhite
\ nextgroup=
\    namedOV_FetchQuotaParamsRecalPerQueries

hi link namedOV_FetchQuotaPersType namedHL_Builtin
syn keyword namedOV_FetchQuotaPersType contained
\    fail
\    drop
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_FetchQuotaPersValue namedHL_Number
syn match namedOV_FetchQuotaPersValue contained
\    /\d\{1,10}/
\ skipwhite
\ nextgroup=
\    namedOV_FetchQuotaPersType,
\    namedSemicolon

hi link namedOV_FetchPers namedHL_Option
syn keyword namedOV_FetchPers contained 
\    fetches-per-server
\    fetches-per-zone
\ skipwhite
\ nextgroup=
\    namedOV_FetchQuotaPersValue

" heartbeat-interval: range: 0-40320
hi link named_Number_Max28day_SC namedHL_Number
syn match named_Number_Max28day_SC contained
\ /\%(40320\)\|\%(403[0-1][0-9]\)\|\%(40[0-2][0-9][0-9]\)\|\%([1-3][0-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9]\)\|\%([1-9][0-9]\)\|\%([0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_HeartbeatInterval namedHL_Option
syn keyword namedOV_HeartbeatInterval contained skipwhite
\    heartbeat-interval
\ nextgroup=named_Number_Max28day_SC

"  dual-stack-servers [ port <pg_num> ] 
"                     { ( <domain_name> [port <p_num>] |
"                         <ipv4> [port <p_num>] | 
"                         <ipv6> [port <p_num>] ); ... };
"  /.\+/
"  /\is*;/
hi link namedOV_DualStack_E_Port namedHL_Option
syn match namedOV_DualStack_E_Port contained /port/
\ skipwhite skipnl skipempty
\ nextgroup=namedElementPortWild

syn match namedDSS_Element_DomainAddrPort 
\ /\<[0-9A-Za-z\._\-]\+\>/ 
\ contained skipwhite
\ contains=namedDomain
\ nextgroup=
\    namedOV_DualStack_E_Port,
\    namedSemicolon,
\    namedError

syn region namedOV_DualStack_Section start=+{+ end=/}/ contained 
\ contains=
\     namedDSS_Element_DomainAddrPort,
\     namedInclude,
\     namedComment
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_DualStack_PortValue namedHL_Number
syn match namedOV_DualStack_PortValue contained 
\ /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_DualStack_Section

hi link namedOV_DualStack_Port namedHL_Option
syn keyword namedOV_DualStack_Port contained port contained 
\ nextgroup=namedOV_DualStack_PortValue
\ skipwhite

hi link namedOV_DualStack namedHL_Option
syn keyword namedOV_DualStack contained dual-stack-servers skipwhite
\ nextgroup=
\    namedOV_DualStack_Port,
\    namedOV_DualStack_Section

" Gee whiz, ya think they could have used SEMICOLON within
" 'catalog-zone' ... ya know, out of consistency????
" Before I make convoluted syntaxes just for this corner 
" case.  I am going to build latest Bind9 9.17 and test 
" this assumption and pray that it is just a bad case of 
" documentation ... I thought it would be this:
"
" catalog-zones {
"     zone <zone_name> {
"         default-masters { <ip_addr>; ... };
"         in-memory no;
"         zone-directory <filespec>;
"         min-update-interval <seconds>;
"         };
"     ... 
"     };
" FUCK! Tested 9.17; zone is that must first keyword but 
" the rest can come in any order.  
" This means ALL needed syntaxes in here must be cloned 
" and used ONLY by and within 'catalog-zones'. 
" No reuse of prior existing syntax here possible.  
" Crap.  
" Could/should/would have introduced curly braces as
" I've thought and shown above earlier.
"
" catalog-zones {
"     zone <zone_name> default-masters { <ip_addr>; ... }
"         in-memory no  zone-directory <filespec>
"         min-update-interval <seconds>
"       ; ... };
" TODO: Implement 9.17
"         catalog-zones { zone <string> [ default-masters [ port <integer>
" ]
"             [ dscp <integer> ] { ( <masters> | <ipv4_address> [ port
"             <integer> ] | <ipv6_address> [ port <integer> ] ) [ key
"             <string> ]; ... } ] [ zone-directory <quoted_string> ] [
"             in-memory <boolean> ] [ min-update-interval <duration> ]; ...
"  };


hi link namedOV_CZ_Filespec namedHL_String
syn match namedOV_CZ_Filespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match namedOV_CZ_Filespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match namedOV_CZ_Filespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl

hi link  namedOV_CZ_ZoneDir namedHL_Option
syn keyword namedOV_CZ_ZoneDir contained zone-directory skipwhite
\ nextgroup=namedOV_CZ_Filespec
\ containedin=namedOV_CatalogZones_Section

hi link  namedOV_CZ_MinUpdate_Interval namedHL_Number
syn match namedOV_CZ_MinUpdate_Interval contained /\d\+/ skipwhite
\ nextgroup=
\    namedOV_CZ_InMemory,
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
\ containedin=namedOV_CatalogZones_Section

hi link  namedOV_CZ_MinUpdate namedHL_Option
syn keyword namedOV_CZ_MinUpdate contained min-update-interval skipwhite
\ nextgroup=namedOV_CZ_MinUpdate_Interval
\ containedin=namedOV_CatalogZones_Section

hi link namedOV_CZ_InMemory_Boolean namedHL_Type
syn match namedOV_CZ_InMemory_Boolean contained /\cyes/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn match namedOV_CZ_InMemory_Boolean contained /\cno/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn match namedOV_CZ_InMemory_Boolean contained /\ctrue/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn match namedOV_CZ_InMemory_Boolean contained /\cfalse/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn keyword namedOV_CZ_InMemory_Boolean contained 1 skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn keyword namedOV_CZ_InMemory_Boolean contained 0 skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon

hi link  namedOV_CZ_InMemory namedHL_Option
syn keyword namedOV_CZ_InMemory contained in-memory skipwhite
\ nextgroup=
\    namedOV_CZ_InMemory_Boolean
\ containedin=
\    namedOV_CatalogZones_Section

syn region namedOV_CZ_DefMasters_MML contained start=+{+ end=+}+ skipwhite skipempty
\ nextgroup=
\    namedOV_CZ_InMemory,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
\ contains=
\    namedOV_CZ_MasterName_SC,
\    namedInclude,
\    namedComment 

hi link  namedOV_CZ_DefMasters namedHL_Option
syn keyword namedOV_CZ_DefMasters contained default-masters skipwhite
\ nextgroup=namedOV_CZ_DefMasters_MML
\ containedin=namedOV_CatalogZones_Section

hi link namedOV_CZ_QuotedDomain namedHL_Identifier
syn match namedOV_CZ_QuotedDomain contained skipwhite
\ /[0-9A-Za-z\._\-]\{1,1023}\.\{0,1}/
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_InMemory,
\    namedSemicolon
syn match namedOV_CZ_QuotedDomain contained skipwhite
\ /'[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}'/hs=s+1,he=e-1
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_InMemory,
\    namedSemicolon
syn match namedOV_CZ_QuotedDomain contained skipwhite
\ /"[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}"/hs=s+1,he=e-1 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_InMemory,
\    namedSemicolon

hi link namedOV_CZ_Zone namedHL_Option
syn keyword namedOV_CZ_Zone contained zone skipwhite
\ nextgroup=namedOV_CZ_QuotedDomain
\ containedin=namedOV_CatalogZones_Section

syn region namedOV_CatalogZones_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOV_CatalogZones namedHL_Option
syn keyword namedOV_CatalogZones contained catalog-zones skipwhite
\ nextgroup=
\    namedOV_CatalogZones_Section

hi link namedOV_QnameMin namedHL_Option
syn keyword namedOV_QnameMin contained qname-minimization skipwhite
\ nextgroup=
\    named_StrictRelaxedDisabledOff

hi link namedOV_MinResponse_Opts namedHL_Builtin
syn keyword namedOV_MinResponse_Opts contained skipwhite skipnl skipempty
\    no-auth
\    no-auth-recursive
\ nextgroup=namedSemicolon

hi link namedOV_MinimalResponses namedHL_Option
syn keyword namedOV_MinimalResponses contained skipwhite skipnl skipempty
\    minimal-responses
\ nextgroup=
\    namedOV_MinResponse_Opts,
\    @namedClusterBoolean_SC

hi link namedOV_NxdomainRedirect namedHL_Option
syn keyword namedOV_NxdomainRedirect contained skipwhite skipnl skipempty
\    nxdomain-redirect
\ nextgroup=named_QuotedDomain_SC

hi link namedOV_RootDelegation_Domain namedHL_Domain
syn match namedOV_RootDelegation_Domain contained /"\<[0-9A-Za-z\._\-]\+\>"/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOV_RootDelegation_Section

syn region namedOV_RootDelegation_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=namedOV_RootDelegation_Domain
\ nextgroup=namedSemicolon

hi link namedOV_RootDelegation_Opts namedHL_Clause
syn match namedOV_RootDelegation_Opts contained /exclude/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RootDelegation_Section,
\    namedSemicolon

hi link namedOV_RootDelegation namedHL_Option
syn keyword namedOV_RootDelegation contained root-delegation-only
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RootDelegation_Opts,
\    namedSemicolon

hi link namedOV_AorAAAA_SC namedHL_Builtin
" syn match namedOV_AorAAAA_SC contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match namedOV_AorAAAA_SC /\ca/ contained skipwhite nextgroup=namedSemicolon
syn match namedOV_AorAAAA_SC /\caaaa/ contained skipwhite nextgroup=namedSemicolon

hi link namedOV_AorAAAA namedHL_Option
syn keyword namedOV_AorAAAA contained skipwhite
\    preferred-glue
\ nextgroup=namedOV_AorAAAA_SC 

hi link named_Number_Max10sec_SC namedHL_Number
syn match named_Number_Max10sec_SC contained skipwhite 
\     /\d\+/
\ nextgroup=
\    namedSemicolon

hi link namedOV_First_Number_Max10sec namedHL_Number
syn match namedOV_First_Number_Max10sec contained skipwhite 
\     /\d\+/
\ nextgroup=
\    namedSemicolon,
\    named_Number_Max10sec_SC

hi link namedOV_Prefetch namedHL_Option
syn keyword namedOV_Prefetch contained skipwhite
\    prefetch
\ nextgroup=
\    namedOV_First_Number_Max10sec

hi link namedOV_Key namedHL_Option
syn match namedOV_Key contained /\_^\_s*\<key\>/ skipwhite
\ nextgroup=namedStmtKeyIdent

hi link namedOV_RateLimit_AllPerSec namedHL_Clause
syn keyword namedOV_RateLimit_AllPerSec contained all-per-second skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_ErrorsPerSec namedHL_Clause
syn keyword namedOV_RateLimit_ErrorsPerSec contained skipwhite
\    errors-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

syn region namedOV_RateLimit_ExemptClientsSection contained start=/{/ end=/}/ skipwhite skipempty
\ contains=
\    named_AML_Not_Operator,
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_Bind_Builtins,
\    named_E_ACLName_SC,
\    namedParenError,
\    namedInclude,
\    namedComment 
\ nextgroup=namedSemicolon

hi link namedOV_RateLimit_ExemptClients namedHL_Clause
syn keyword namedOV_RateLimit_ExemptClients contained skipwhite
\    exempt-clients
\ nextgroup=namedOV_RateLimit_ExemptClientsSection
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_IP4PrefixLen namedHL_Clause
syn keyword namedOV_RateLimit_IP4PrefixLen contained skipwhite
\     ipv4-prefix-length 
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_IP6PrefixLen namedHL_Clause
syn keyword namedOV_RateLimit_IP6PrefixLen contained skipwhite
\     ipv6-prefix-length 
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_LogOnly namedHL_Clause
syn keyword namedOV_RateLimit_LogOnly contained skipwhite
\     log-only
\ nextgroup=@namedClusterBoolean_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_MaxTableSize namedHL_Clause
syn keyword namedOV_RateLimit_MaxTableSize contained max-table-size skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_MinTableSize namedHL_Clause
syn keyword namedOV_RateLimit_MinTableSize contained min-table-size skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_NoDataPerSec namedHL_Clause
syn keyword namedOV_RateLimit_NoDataPerSec contained skipwhite
\    nodata-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_NxdomainsPerSec namedHL_Clause
syn keyword namedOV_RateLimit_NxdomainsPerSec contained skipwhite
\    nxdomains-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_QpsScale namedHL_Clause
syn keyword namedOV_RateLimit_QpsScale contained qps-scale skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_ReferralsPerSec namedHL_Clause
syn keyword namedOV_RateLimit_ReferralsPerSec contained skipwhite
\     referrals-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_ResponsesPerSec namedHL_Clause
syn keyword namedOV_RateLimit_ResponsesPerSec contained skipwhite
\    responses-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_Slip namedHL_Clause
syn keyword namedOV_RateLimit_Slip contained skipwhite
\    slip
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_Window namedHL_Clause
syn keyword namedOV_RateLimit_Window contained skipwhite
\    window
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection


syn region namedOV_RateLimitSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon

hi link namedOV_RateLimit namedHL_Option
syn keyword namedOV_RateLimit contained rate-limit skipwhite skipempty
\ nextgroup=namedOV_RateLimitSection

hi link namedOV_ResponsePadding_BlockSize namedHL_Option
syn match namedOV_ResponsePadding_BlockSize contained /\<block\-size\>/
\ skipwhite skipnl skipempty
\ nextgroup=named_Number_SC

hi link namedOV_ResponsePadding_Not_Operator namedHL_Operator
syn match namedOV_ResponsePadding_Not_Operator contained /!/
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_Bind_Builtins,
\    namedSemicolon

syn region namedOV_ResponsePaddingSection contained start=/{/ end=/}/ 
\ skipwhite skipnl skipempty
\ contains=
\    namedOV_ResponsePadding_Not_Operator,
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_Bind_Builtins
\ nextgroup=
\     namedSemicolon,
\     namedOV_ResponsePadding_BlockSize

hi link namedOV_ResponsePadding namedHL_Option
syn keyword namedOV_ResponsePadding contained response-padding 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_ResponsePaddingSection

"""""""""""""""""""""""""""""""""""""""""""""""""""
" response-policy is now namedOV_RP_*
"""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOV_RP_Dnsrps_Element namedHL_String
syn region namedOV_RP_Dnsrps_Element start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOV_RP_Dnsrps_Section

syn region namedOV_RP_Dnsrps_Element start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOV_RP_Dnsrps_Section

syn region namedOV_RP_Dnsrps_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

hi link namedOV_RP_DnsrpsOption namedHL_Option
syn keyword namedOV_RP_DnsrpsOption contained
\    dnsrps-options
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RP_Dnsrps_Section

hi link namedOV_RP_DnsrpsEnable namedHL_Builtin
syn match namedOV_RP_DnsrpsEnable contained /\i\{1,16}/
\ contains=namedTypeBool
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicyTtl,
\    namedOV_RP_MinUpdateInterval,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_Dnsrps namedHL_Option
syn keyword namedOV_RP_Dnsrps contained dnsrps-enable
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_DnsrpsEnable

hi link namedOV_RP_NsdnameEnable namedHL_Builtin
syn match namedOV_RP_NsdnameEnable contained /\i\{1,16}/
\ contains=namedTypeBool
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicyTtl,
\    namedOV_RP_MinUpdateInterval,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_Nsdname namedHL_Option
syn keyword namedOV_RP_Nsdname contained nsdname-enable
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_NsdnameEnable

hi link namedOV_RP_NsipEnable namedHL_Builtin
syn match namedOV_RP_NsipEnable contained /\i\{1,16}/
\ contains=namedTypeBool
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicyTtl,
\    namedOV_RP_MinUpdateInterval,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_RecursiveOnly,
\    namedOV_RP_Nsip,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsdname,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_Nsip namedHL_Option
syn keyword namedOV_RP_Nsip contained nsip-enable
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_NsipEnable

hi link namedOV_RP_RecursiveOnly namedHL_Builtin
syn match namedOV_RP_RecursiveOnly contained /\i\{1,16}/
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinUpdate,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_Recursive namedHL_Option
syn keyword namedOV_RP_Recursive contained recursive-only 
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_RecursiveOnly

hi link namedOV_RP_QnameWaitRecurse namedHL_Number
syn match namedOV_RP_QnameWaitRecurse contained /\i\{1,11}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinNs,
\    namedOV_RP_MinUpdate,
\    namedOV_RP_NsipWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_QnameWait namedHL_Option
syn keyword namedOV_RP_QnameWait contained qname-wait-recurse
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_QnameWaitRecurse

hi link namedOV_RP_NsipWaitRecurse namedHL_Number
syn match namedOV_RP_NsipWaitRecurse contained /\i\{1,11}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinNs,
\    namedOV_RP_MinUpdate,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_NsipWait namedHL_Option
syn keyword namedOV_RP_NsipWait contained nsip-wait-recurse
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_NsipWaitRecurse

hi link namedOV_RP_MinNsDots namedHL_Number
syn match namedOV_RP_MinNsDots contained /\i\{1,11}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinNs,
\    namedOV_RP_MinUpdate,
\    namedOV_RP_NsipWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_MinNs namedHL_Option
syn keyword namedOV_RP_MinNs contained min-ns-dots
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_MinNsDots

hi link namedOV_RP_MinUpdateInterval namedHL_Number
syn match namedOV_RP_MinUpdateInterval contained /\d\{1,11}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_MinUpdate namedHL_Option
syn keyword namedOV_RP_MinUpdate contained min-update-interval
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_MinUpdateInterval

hi link namedOV_RP_MaxPolicyTtl namedHL_Number
syn match namedOV_RP_MaxPolicyTtl contained /\d\{1,10}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MinUpdate,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_MaxPolicy namedHL_Option
syn keyword namedOV_RP_MaxPolicy contained max-policy
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_MaxPolicyTtl

syn match namedOV_RP_AddSOA contained /\i\{1,16}/
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_BreakDnssecBool,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinUpdate,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

syn match namedOV_RP_BreakDnssecBool contained /\i\{1,16}/
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedOV_RPZone_Section,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinUpdate,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_AddSOA,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_QnameWait,
\    namedOV_RP_Recursive,
\    namedOV_RP_Nsip,
\    namedOV_RP_Nsdname,
\    namedOV_RP_Dnsrps,
\    namedOV_RP_DnsrpsOption,
\    namedSemicolon

hi link namedOV_RP_BreakDnssec namedHL_Option
syn keyword namedOV_RP_BreakDnssec contained break-dnssec
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RP_BreakDnssecBool

"""""""""
" namedOV_RPZone_* is within each response-policy's zone section
"""""""""
syn match namedOV_RPZone_NsdnameBool contained
\    /\i\{1,16}/
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Policy,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsip,
\    namedSemicolon

hi link namedOV_RPZone_Nsdname namedHL_Clause
syn keyword namedOV_RPZone_Nsdname contained
\    nsdname-enable
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_NsdnameBool

syn match namedOV_RPZone_NsipBool contained
\    /\i\{1,16}/
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Policy,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RPZone_Recursive namedHL_Clause

hi link namedOV_RPZone_Nsip namedHL_Clause
syn keyword namedOV_RPZone_Nsip nsip-enable contained
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_NsipBool

syn match namedOV_RPZone_RecursiveBool contained 
\    /\i\{1,16}/
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Policy,
\    namedOV_RPZone_Nsip,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RPZone_Recursive namedHL_Clause
syn keyword namedOV_RPZone_Recursive contained recursive-only
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_RecursiveBool

hi link namedOV_RPZone_PolicyTcpOnly namedHL_Clause
syn match namedOV_RPZone_PolicyTcpOnly contained
\    /\i\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsip,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RPZone_PolicyOptions namedHL_Builtin
syn keyword namedOV_RPZone_PolicyOptions contained
\    tcp-only
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_PolicyTcpOnly

hi link namedOV_RPZone_PolicyOptions namedHL_Builtin
syn keyword namedOV_RPZone_PolicyOptions contained
\    cname
\    disabled
\    drop
\    given
\    no-op
\    nodata
\    nxdomain
\    passthru
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsip,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RPZone_Policy namedHL_Clause
syn keyword namedOV_RPZone_Policy contained policy 
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_PolicyOptions

hi link namedOV_RPZone_MinUpdateTtl namedHL_Number
syn match namedOV_RPZone_MinUpdateTtl contained /\i\{1,11}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_Policy,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsip,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RPZone_MinUpdate namedHL_Clause
syn keyword namedOV_RPZone_MinUpdate contained min-update-interval
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_MinUpdateTtl

hi link namedOV_RPZone_MaxTtlFlag namedHL_Number
syn match namedOV_RPZone_MaxTtlFlag contained /\d\{1,11}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Policy,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsip,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RPZone_MaxTtl namedHL_Clause
syn keyword namedOV_RPZone_MaxTtl contained max-policy-ttl
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_MaxTtlFlag

syn match namedOV_RPZone_LogFlag contained /\i\{1,15}/
\ skipwhite skipnl skipempty
\ contains=namedTypeBool
\ nextgroup=
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Policy,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsip,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RPZone_Log namedHL_Clause
syn keyword namedOV_RPZone_Log contained log
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_RPZone_LogFlag

hi link namedOV_RP_ZoneName namedHL_Identifier
syn match namedOV_RP_ZoneName contained /[a-zA-Z0-9\_\.-\+~@$%^&*()=]\{1,63}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_AddSOA,
\    namedOV_RPZone_Log,
\    namedOV_RPZone_MaxTtl,
\    namedOV_RPZone_MinUpdate,
\    namedOV_RPZone_Policy,
\    namedOV_RPZone_Recursive,
\    namedOV_RPZone_Nsip,
\    namedOV_RPZone_Nsdname,
\    namedSemicolon

hi link namedOV_RP_Zone namedHL_Option
syn keyword namedOV_RP_Zone contained zone
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RP_ZoneName

syn region namedOV_RPZone_Section contained start=/{/ end=/}/ 
\ skipwhite skipnl skipempty
\ contains=
\    namedOV_RP_Zone
\ nextgroup=
\    namedOV_RP_AddSOA,
\    namedOV_RP_BreakDnssec,
\    namedOV_RP_MaxPolicy,
\    namedOV_RP_MinUpdateInterval,
\    namedOV_RP_MinNs,
\    namedOV_RP_NsipWait,
\    namedOV_RP_Nsdname,
\    namedOV_RP_NsdnameWait,
\    namedOV_RP_Nsip,
\    namedOV_RP_QnameWait,
\    namedOV_RP_RecursiveOnly,
\    namedSemicolon

hi link namedOV_ResponsePolicy namedHL_Option
syn keyword namedOV_ResponsePolicy contained response-policy
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_RPZone_Section

" valid-except { <domain_name>; ... };
hi link namedOV_ValidExcept_DomainName namedHL_Identifier
syn match namedOV_ValidExcept_DomainName contained /[0-9A-Za-z][_\-0-9A-Za-z.]\{1,1024}/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

syn region namedOV_ValidExcept_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=namedOV_ValidExcept_DomainName
\ nextgroup=namedSemicolon

hi link namedOV_ValidExcept namedHL_Option
syn keyword namedOV_ValidExcept contained validate-except
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_ValidExcept_Section

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" syn keyword namedOZ_Boolean_Group contained skipwhite
" \ nextgroup=named_Number_SC
" \ containedin=
" \    namedStmt_OptionsSection,
" \    namedStmt_ZoneSection

syn match namedOZ_DialupOptBoolean contained /\S\+/
\ skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

hi link namedOZ_DialupOptBuiltin namedHL_Builtin
syn match namedOZ_DialupOptBuiltin contained 
\     /\%(notify\)\|\%(notify-passive\)\|\%(passive\)\|\%(refresh\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_Dialup namedHL_Option
syn keyword namedOVZ_Dialup contained dialup
\ skipwhite
\ nextgroup=
\    namedOZ_DialupOptBuiltin,
\    namedOZ_DialupOptBoolean

hi link namedOptionsDnstapIdentityOpts namedHL_Builtin
syn keyword namedOptionsDnstapIdentityOpts contained
\    none
\    hostname
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOptionsDnstapIdentityDomain namedHL_String
syn match namedOptionsDnstapIdentityDomain contained
\    /\<[0-9A-Za-z\._\-]\{1,1023}\>/
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedOptionsDnstapIdentityDomain contained
\    /'[0-9A-Za-z\.\-_]\{1,1023}'/
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedOptionsDnstapIdentityDomain contained
\    /"[0-9A-Za-z\.\-_]\{1,1023}"/ 
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOZ_DnstapIdentity namedHL_Option
syn keyword namedOZ_DnstapIdentity contained 
\    dnstap-identity
\ skipwhite
\ nextgroup=
\    namedOptionsDnstapIdentityOpts,
\    namedOptionsDnstapIdentityDomain

hi link namedOZ_Files_Wildcard namedHL_Builtin
syn match namedOZ_Files_Wildcard /\*/ contained skipwhite

hi link namedOZ_Files namedHL_Option
syn keyword namedOZ_Files contained files skipwhite skipnl skipempty
\ nextgroup=
\    namedOZ_Files_Wildcard,
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

hi link namedOV_Rrset_DomainName namedHL_String
syn region namedOV_Rrset_DomainName contained 
\ start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_Rrset_Order,
\    namedOV_Rrset_Class,
\    namedOV_Rrset_Type,
\    namedSemicolon
syn region namedOV_Rrset_DomainName contained 
\ start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_Rrset_Order,
\    namedOV_Rrset_Class,
\    namedOV_Rrset_Type,
\    namedSemicolon

hi link namedOV_Rrset_Domain namedHL_Option
syn keyword namedOV_Rrset_Domain contained name
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_Rrset_DomainName

hi link namedMk_E_DomainName namedHL_Identifier
syn match namedMk_E_DomainName contained /[0-9A-Za-z][_\-0-9A-Za-z.]\{1,1024}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedMk_E_InitialKey,
\    namedError

hi link namedOV_Rrset_TypeOpt namedHL_Builtin
syn match namedOV_Rrset_TypeOpt contained /\<\c\%(CHAOS\)\|\%(HESIOD\)\|\%(IN\)\|\%(CH\)\|\%(HS\)\|\%(ANY\)\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_Rrset_Order,
\    namedOV_Rrset_Class,
\    namedOV_Rrset_Domain,
\    namedSemicolon

hi link namedOV_Rrset_Type namedHL_Type
" Reordered from largest fixed to smallest fixed, then alphanumeric order
" 1-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<[A\*]\{1,1}\>/
\ nextgroup=namedSemicolon
" 2-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(A6\)\|\(DS\)\|\(KX\)\|\(LP\)\|\(MB\)\|\(MD\)\>/
\ nextgroup=namedSemicolon
" 2-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(MF\)\|\(MG\)\|\(MP\)\|\(MR\)\|\(MX\)\|\(NS\)\>/
\ nextgroup=namedSemicolon
" 2-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(PX\)\|\(RP\)\|\(RT\)\|\(TA\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(APL\)\|\(AVC\)\|\(CAA\)\|\(CDS\)\|\(DOA\)\|\(DLV\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(EID\)\|\(GID\)\|\(HIP\)\|\(L32\)\|\(L64\)\|\(LOC\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(KEY\)\|\(OPT\)\|\(NID\)\|\(NXT\)\|\(PTR\)\|\(SIG\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(SOA\)\|\(SPF\)\|\(SRV\)\|\(TXT\)\|\(UID\)\|\(URI\)\>/
\ nextgroup=namedSemicolon
" 3-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(X25\)\|\(WKS\)\|\(ANY\)\>/
\ nextgroup=namedSemicolon
" 4-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(AAAA\)\|\(ATMA\)\|\(AXFR\)\|\(CERT\)\|\(GPOS\)\>/
\ nextgroup=namedSemicolon
" 4-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(ISDN\)\|\(IXFR\)\|\(NSAP\)\|\(NSEC\)\|\(NULL\)\>/
\ nextgroup=namedSemicolon
" 4-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(RKEY\)\|\(SINK\)\|\(TKEY\)\|\(TLSA\)\|\(TSIG\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(AFSDB\)\|\(CNAME\)\|\(CSYNC\)\|\(DHCID\)\|\(DNAME\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(EUI48\)\|\(EUI64\)\|\(HINFO\)\|\(MAILA\)\|\(MAILB\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(MINFO\)\|\(NAPTR\)\|\(NINFO\)\|\(NSEC3\)\|\(RRSIG\)\>/
\ nextgroup=namedSemicolon
" 5-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(SSHFP\)\|\(UINFO\)\>/
\ nextgroup=namedSemicolon
" 6-char RRTYpe name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(DNSKEY\)\|\(NIMLOC\)\|\(SMIMEA\)\|\(TALINK\)\|\(UNSPEC\)\|\(ZONEMD\)\>/
\ nextgroup=namedSemicolon
" 7-char RRType name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(CDSKEY\)\>/
\ nextgroup=namedSemicolon
" 8-char RRType name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(AMTRELAY\)\|\(IPSECKEY\)\|\(NSAP\-PTR\)\>/
\ nextgroup=namedSemicolon
" 10 or more char RRType name
syn match namedOV_Rrset_TypeOpt contained
\    /\c\<\(NSEC3PARAM\)\|\(OPENPGPKEY\)\>/
\ nextgroup=namedSemicolon

hi link namedOV_Rrset_Type namedHL_Statement
syn keyword namedOV_Rrset_Type contained type
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_Rrset_TypeOpt

hi link namedOV_Rrset_ClassOpt namedHL_Builtin
syn match namedOV_Rrset_ClassOpt contained /\<\c\%(CHAOS\)\|\%(HESIOD\)\|\%(IN\)\|\%(CH\)\|\%(HS\)\|\%(ANY\)\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_Rrset_Order,
\    namedOV_Rrset_Type,
\    namedOV_Rrset_Domain,
\    namedSemicolon

hi link namedOV_Rrset_Class namedHL_Option
syn keyword namedOV_Rrset_Class contained class
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_Rrset_ClassOpt

hi link namedOV_Rrset_OrderType namedHL_Builtin
syn match namedOV_Rrset_OrderType contained
\ /\(none\)\|\(fixed\)\|\(random\)\|\(cyclic\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOV_Rrset_Class,
\    namedOV_Rrset_Type,
\    namedOV_Rrset_Domain,
\    namedSemicolon
    
hi link namedOV_Rrset_Order namedHL_Option
syn keyword namedOV_Rrset_Order contained order skipwhite skipnl skipempty
\ nextgroup=namedOV_Rrset_OrderType

syn region namedOV_Rrset_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=
\    namedOV_Rrset_Order,
\    namedOV_Rrset_Class,
\    namedOV_Rrset_Type,
\    namedOV_Rrset_Domain
\ nextgroup=namedSemicolon

hi link namedOV_RrsetOrder namedHL_Option
syn keyword namedOV_RrsetOrder contained rrset-order
\ skipwhite skipnl skipempty
\ nextgroup=namedOV_Rrset_Section

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', and 'zone'  ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', 'server', and 'zone'  ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOVZ_Timestamp_Group namedHL_Builtin
syn keyword namedOVZ_Timestamp_Group contained skipwhite
\    date
\    unixtime
\    increment
\ nextgroup=namedSemicolon

hi link namedOVZ_SerialUpdateMethod namedHL_Option
syn keyword namedOVZ_SerialUpdateMethod contained skipwhite
\    serial-update-method
\ nextgroup=namedOVZ_Timestamp_Group

hi link namedOVZ_Number_Group namedHL_Option
syn keyword namedOVZ_Number_Group contained skipwhite
\    max-records
\    notify-delay
\    sig-signing-nodes
\    sig-signing-signatures
\    sig-signing-type
\ nextgroup=named_Number_SC

hi link namedOVZ_Boolean_Group namedHL_Option
syn keyword namedOVZ_Boolean_Group contained skipwhite
\    check-sibling
\    check-integrity
\    check-wildcard
\    dnssec-dnskey-kskonly
\    dnssec-secure-to-insecure
\    inline-signing
\    maintain-ixfr-base
\    multi-master
\    notify-to-soa
\    try-tcp-refresh
\    update-check-ksk
\    use-alt-transfer-source
\    zero-no-soa-ttl
\    zero-no-soa-ttl-cache
\ nextgroup=@namedClusterBoolean_SC

hi link namedOVZ_AML_Not_Operator namedHL_Operator
syn match namedOVZ_AML_Not_Operator contained /!/ skipwhite
\ nextgroup=named_E_AMLSection_SC


hi link namedOVZ_AML_Group namedHL_Option
syn keyword namedOVZ_AML_Group contained skipwhite skipempty
\    allow-notify
\    allow-query
\    allow-query-on
\    allow-transfer
\    allow-update
\    allow-update-forwarding
\    namedStmt_ZoneSection
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen


hi link namedOVZ_Number_Max28days namedHL_Option
syn keyword namedOVZ_Number_Max28days contained 
\    max-transfer-idle-in
\    max-transfer-idle-out
\    max-transfer-time-in
\    max-transfer-time-out
\ skipwhite skipnl skipempty
\ nextgroup=named_Number_Max28day_SC

hi link namedOptATSClauseDscp  namedHL_Clause
syn match namedOptATS_DSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/ 
\ skipwhite skipnl skipempty
\ contains=namedDSCP 
\ nextgroup=
\    namedOptATSClausePort,
\    namedSemicolon

hi link namedOptATS_PortWild namedHL_Number
syn match namedOptATS_PortWild contained /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOptATSClauseDscp,
\    namedSemicolon

hi link namedOptATSClausePort  namedHL_Clause
syn keyword namedOptATSClausePort contained port 
\ skipwhite skipnl skipempty
\ nextgroup=namedOptATS_PortWild 
\ containedin=namedOptATS_IPwild
syn keyword namedOptATSClauseDscp contained dscp
\ skipwhite skipnl skipempty
\ nextgroup=namedOptATS_DSCP
\ containedin=namedOptATS_IPwild
syn keyword namedOptATSClauses contained port 
\ skipwhite skipnl skipempty
\ nextgroup=namedOptATS_Port skipwhite
\ containedin=namedOptATS_IPwild
syn match namedOptATSClauses /dscp/ contained 
\ skipwhite skipnl skipempty
\ nextgroup=namedOptATS_DSCP skipwhite
\ containedin=namedOptATS_IPwild

hi link namedOptATS_IP4wild namedHLKeyword
syn match namedOptATS_IP4wild /\S\{1,48}/ contained
\ skipwhite skipnl skipempty
\ contains=
\    namedIPwild,
\    named_IP4Addr_SC
\ nextgroup=
\    namedOptATSClausePort,
\    namedOptATSClauseDscp,
\    namedSemicolon

hi link namedOptATS_IP6wild namedHLKeyword
syn match namedOptATS_IP6wild contained /\S\{1,48}/
\ skipwhite skipnl skipempty
\ contains=
\    namedIPwild,
\    named_IP6Addr_SC
\ nextgroup=
\    namedOptATSClausePort,
\    namedOptATSClauseDscp,
\    namedSemicolon

hi link namedOVZ_OptATS namedHL_Option
syn match namedOVZ_OptATS contained 
\    /\<alt\-transfer\-source\-v6\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOptATS_IP6wild 
syn keyword namedOVZ_OptATS contained
\    alt-transfer-source
\ skipwhite skipnl skipempty
\ nextgroup=namedOptATS_IP4wild 

hi link namedOVZ_AutoDNSSEC namedHL_Option
syn match namedOVZ_AutoDNSSEC contained /\<auto\-dnssec\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_AllowMaintainOff,
\    namedComment,
\    namedError 

hi link namedOVZ_IgnoreWarnFail namedHL_Option
syn keyword namedOVZ_IgnoreWarnFail contained 
\    check-mx-cname
\    check-mx
\    check-srv-cname
\    check-spf
\ skipwhite skipnl skipempty
\ nextgroup=named_IgnoreWarnFail_SC

hi link namedOVZ_IgnoreWarn namedHL_Option
syn keyword namedOVZ_IgnoreWarn contained check-dup-records
\ skipwhite skipnl skipempty
\ nextgroup=named_IgnoreWarn_SC

" <0-3660> days (dnskey-sig-validity)
hi link named_Number_Max3660days namedHL_Number
syn match named_Number_Max3660days contained 
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_DnskeyValidity namedHL_Option
syn keyword namedOVZ_DnskeyValidity contained dnskey-sig-validity
\ skipwhite skipnl skipempty
\ nextgroup=named_Number_Max3660days

" <0-1440> (dnssec-loadkeys-interval)
hi link namedOVZ_DnssecLoadkeysInterval namedHL_Number
syn match namedOVZ_DnssecLoadkeysInterval contained 
\ /\%(1440\)\|\%(14[0-3][0-9]\)\|\%(1[0-3][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_DnssecLoadkeys namedHL_Option
syn keyword namedOVZ_DnssecLoadkeys contained dnssec-loadkeys-interval
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_DnssecLoadkeysInterval

" cleaning-interval: range: 0-1440
hi link namedOVZ_CleaningValue namedHL_Number
syn match namedOVZ_CleaningValue contained
\    /\(1440\)\|\(14[0-3][0-9]\)\|\([1[0-3][0-9][0-9]\)\|\([0-9][0-9][0-9]\)\|\([0-9][0-9]\)\|\([0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_CleaningInterval namedHL_Option
syn keyword namedOVZ_CleaningInterval contained
\    cleaning-interval
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_CleaningValue

" dnssec-must-be-secure <domain_name> <boolean>; [ Opt View ]  # v9.3.0+
syn match namedDMBS_FQDN contained /\<[0-9A-Za-z\.\-_]\{1,1023}\>/
\ skipwhite skipnl skipempty
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite
syn match namedDMBS_FQDN contained /'[0-9A-Za-z\.\-_]\{1,1023}'/
\ skipwhite skipnl skipempty
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite
syn match namedDMBS_FQDN contained /"[0-9A-Za-z\.\-_]\{1,1023}"/
\ skipwhite skipnl skipempty
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite

hi link namedOVZ_DnssecMustBeSecure namedHL_Option
syn keyword namedOVZ_DnssecMustBeSecure contained 
\    dnssec-must-be-secure 
\ skipwhite skipnl skipempty
\ nextgroup=namedDMBS_FQDN

hi link namedOVZ_DnssecUpdateModeOpt namedHL_Builtin
syn keyword namedOVZ_DnssecUpdateModeOpt contained
\   maintain
\   no-resign
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_DnssecUpdateMode namedHL_Option
syn keyword namedOVZ_DnssecUpdateMode contained
\    dnssec-update-mode
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_DnssecUpdateModeOpt

hi link namedOVZ_ForwardOpt namedHL_Builtin
syn keyword namedOVZ_ForwardOpt contained
\    only
\    first
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_Forward namedHL_Option
syn keyword namedOVZ_Forward contained forward
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_ForwardOpt

hi link namedOVZ_Forwarders_Opt_PortNumber namedHL_Error
syn match namedOVZ_Forwarders_Opt_PortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ contains=named_Port
\ nextgroup=namedSemicolon

hi link namedOVZ_Forwarders_Opt_DscpNumber namedHL_Number
syn match namedOVZ_Forwarders_Opt_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_Forwarders_Opt_Dscp namedHL_Option
syn keyword namedOVZ_Forwarders_Opt_Dscp contained dscp
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_Forwarders_Opt_DscpNumber
\ containedin=namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_Opt_Port namedHL_Option
syn keyword namedOVZ_Forwarders_Opt_Port contained port
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOVZ_Forwarders_Opt_PortNumber,
\    namedError
\ containedin=namedOVZ_Forwarders_Section

" hi link namedOVZ_Forwarders_IP6 namedHL_Number
syn match namedOVZ_Forwarders_IP6 contained /[0-9a-fA-F:\.]\{6,48}/
\ skipwhite skipnl skipempty
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedOVZ_Forwarders_Opt_Port,
\   namedOVZ_Forwarders_Opt_Dscp,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_IP4 namedHL_Number
syn match namedOVZ_Forwarders_IP4 contained 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\   namedSemicolon,
\   namedOVZ_Forwarders_Opt_Port,
\   namedOVZ_Forwarders_Opt_Dscp,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOVZ_Forwarders_Section

syn region namedOVZ_Forwarders_Section contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=namedComment
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

hi link namedOVZ_Forwarders_DscpNumber namedHL_Number
syn match namedOVZ_Forwarders_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOVZ_Forwarders_Port,
\    namedOVZ_Forwarders_Section,
\    namedSemicolon

hi link namedOVZ_Forwarders_PortNumber namedHL_Number
syn match namedOVZ_Forwarders_PortNumber contained 
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOVZ_Forwarders_Dscp,
\    namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_Port  namedHL_Option
syn keyword namedOVZ_Forwarders_Port contained port skipwhite skipnl skipempty
\ nextgroup=namedOVZ_Forwarders_PortNumber

hi link namedOVZ_Forwarders_Dscp  namedHL_Option
syn keyword namedOVZ_Forwarders_Dscp contained dscp 
\ skipwhite skipempty skipnl
\ nextgroup=namedOVZ_Forwarders_DscpNumber

" forwarders [ port <integer> ] [ dscp <integer> ] { 
"      ( <ipv4_addr> | <ipv6_addr> ) [ port <integer> ] [ dscp <integer> ];
"      ...
"    };

hi link namedOVZ_Forwarders namedHL_Option
syn keyword namedOVZ_Forwarders contained forwarders
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedOVZ_Forwarders_Section,
\    namedOVZ_Forwarders_Port,
\    namedOVZ_Forwarders_Dscp,
\    namedComment, namedInclude,
\    namedError

hi link namedOVZ_MasterfileFormat_Opts namedHL_Builtin
syn keyword namedOVZ_MasterfileFormat_Opts contained
\    raw
\    text
\    map
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_MasterfileFormat namedHL_Option
syn keyword namedOVZ_MasterfileFormat contained
\    masterfile-format
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_MasterfileFormat_Opts

hi link namedOVZ_MasterfileStyles namedHL_Builtin
syn keyword namedOVZ_MasterfileStyles contained
\    full
\    relative
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_MasterfileStyle namedHL_Option
syn keyword namedOVZ_MasterfileStyle contained masterfile-style
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_MasterfileStyles


hi link namedOVZ_TtlUnlimited namedHL_Builtin
syn keyword namedOVZ_TtlUnlimited contained unlimited 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_Ttl namedHL_Number
syn match namedOVZ_Ttl contained /\d\{1,10}/ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_MaxZoneTtl namedHL_Option
syn keyword namedOVZ_MaxZoneTtl contained max-zone-ttl 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOVZ_TtlUnlimited,
\    namedOVZ_Ttl


" view statement - Filespec (directory, filename)
hi link namedOVZ_Filespec_Group namedHL_Option
syn keyword namedOVZ_Filespec_Group contained key-directory
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_String_QuoteForced_SC,
\    namedNotString

" max-refresh-time obsoleted in view and zone section

hi link namedOVZ_RefreshRetry namedHL_Option
syn keyword namedOVZ_RefreshRetry contained 
\    max-refresh-time
\    max-retry-time
\    min-refresh-time
\    min-retry-time
\ skipwhite skipnl skipempty
\ nextgroup=named_Number_Max24week_SC

hi link namedOVZ_ZoneStat_Opts namedHL_Builtin
syn keyword namedOVZ_ZoneStat_Opts contained 
\    full
\    terse
\    none
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_ZoneStat namedHL_Option
syn keyword namedOVZ_ZoneStat contained zone-statistics
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOVZ_ZoneStat_Opts,
\    @namedClusterBoolean

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', 'view', and 'zone' ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'server'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link named_A6orAAAA_SC namedHL_String
" syn match named_A6orAAAA_SC contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match named_A6orAAAA_SC contained /\caaaa/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
syn match named_A6orAAAA_SC contained /\ca6/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOSV_OptAV6S namedHL_Option
syn match namedOSV_OptAV6S contained /\<allow\-v6\-synthesis\>/
\ skipwhite skipnl skipempty
\ nextgroup=named_A6orAAAA_SC 

hi link namedOSV_Boolean_Group namedHL_Option
syn keyword namedOSV_Boolean_Group contained 
\ skipwhite skipnl skipempty
\    provide-ixfr
\    request-nsid
\    request-sit
\    send-cookie
\ nextgroup=@namedClusterBoolean_SC

" <0-3660> days (sig-validity-interval)
hi link namedOVZ_First_Number_Max3660days namedHL_Number
syn match namedOVZ_First_Number_Max3660days contained 
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=named_Number_Max3660days,namedSemicolon

hi link namedOVZ_SigSigning namedHL_Option
syn keyword namedOVZ_SigSigning contained sig-validity-interval
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOVZ_First_Number_Max3660days

hi link namedOVZ_Notify_Opts namedHL_Builtin
syn keyword namedOVZ_Notify_Opts contained 
\    explicit
\    master-only
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_Notify namedHL_Option
syn keyword namedOVZ_Notify contained notify
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOVZ_Notify_Opts,
\    @namedClusterBoolean_SC

hi link namedOVZ_Keyname_SC namedHL_String
syn match namedOVZ_Keyname_SC contained 
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOVZ_SessionKeyname namedHL_Option
syn keyword namedOVZ_SessionKeyname contained session-keyname 
\ skipwhite skipnl skipempty
\ nextgroup=namedOVZ_Keyname_SC

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOSVZ_Boolean_Group namedHL_Option
syn keyword namedOSVZ_Boolean_Group  contained 
\    notify-to-soa
\    request-expire
\    request-ixfr
\ skipwhite skipnl skipempty
\ nextgroup=@namedClusterBoolean_SC

" transfer-source ( * | <ip4_addr> )
"                 [ port ( * | <port_number> ) ]
"                 [ dscp <dscp> ];
"
hi link namedOSVZ_TransferSource_Dscp namedHL_Option
syn keyword namedOSVZ_TransferSource_Dscp contained dscp 
\ skipwhite skipnl skipempty
\ nextgroup=named_Dscp_SC

hi link namedOSVZ_TransferSource_PortValue namedHL_Number
syn match namedOSVZ_TransferSource_PortValue contained 
\ /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_TransferSource_PortWildcard namedHL_Builtin
syn match namedOSVZ_TransferSource_PortWildcard contained /\*/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_TransferSource_Port namedHL_Option
syn keyword namedOSVZ_TransferSource_Port contained port 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_PortValue,
\    namedOSVZ_TransferSource_PortWildcard

hi link namedOSVZ_TransferSource_IP4Addr namedHL_Number
syn match namedOSVZ_TransferSource_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=namedOSVZ_TransferSource_Port

" transfer-source [address] 
"              ( * | <ip4_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" transfer-source [ [ address ] 
"                ( * | <ip4_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link namedOSVZ_TransferSource_IP6Addr namedHL_Number
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedOSVZ_TransferSource_IP6Addr contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedOSVZ_TransferSource_IP6Addr contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedOSVZ_TransferSource_IP6Addr contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_TransferSource_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_TransferSource_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedOSVZ_TransferSource_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_TransferSource_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_TransferSource_IPWildcard namedHL_Builtin
syn match namedOSVZ_TransferSource_IPWildcard contained /\*/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp

hi link namedOSVZ_TransferSource namedHL_Option
syn keyword namedOSVZ_TransferSource contained transfer-source 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_IP4Addr,
\    namedOSVZ_TransferSource_IPWildcard

hi link namedOSVZ_TransferSourceIP6 namedHL_Option
syn match namedOSVZ_TransferSourceIP6 contained 
\    /\<transfer\-source\-v6\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_TransferSource_IP6Addr,
\    namedOSVZ_TransferSource_IPWildcard

syn match namedOptPortKeyval contained /port\s\+\d\\+/ms=s+5 contains=named_PortVal

syn region named_PortSection contained start=+{+ end=+}+ skipwhite
\ contains=
\    namedElementPortWild,
\    namedParenError,
\    namedComment,
\    namedInclude
\ nextgroup=namedSemicolon

hi link namedOSVZ_E_MasterName namedHL_Identifier
syn match namedOSVZ_E_MasterName contained skipwhite /[a-zA-Z][a-zA-Z0-9_\-]\+/
\ nextgroup=
\    namedM_E_KeyKeyword,
\    namedSemicolon,
\   namedComment, namedInclude,
\    namedError
\ containedin=namedOSVZ_Masters_MML

" hi link namedOSVZ_E_IP6addr namedHL_Number
syn match namedOSVZ_E_IP6addr contained skipwhite /[0-9a-fA-F:\.]\{6,48}/
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOSVZ_Masters_MML

hi link namedOSVZ_E_IP4addr namedHL_Number
syn match namedOSVZ_E_IP4addr contained skipwhite 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOSVZ_Masters_MML

syn region namedOSVZ_Masters_MML contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=namedComment
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

" 'dscp' added after `also-notify` at 9.9
hi link namedAlsoNotify_DscpNumber namedHL_Number
syn match namedAlsoNotify_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedAlsoNotify_Port,
\    namedOSVZ_Masters_MML

hi link namedAlsoNotify_Dscp namedHL_Option
syn match namedAlsoNotify_Dscp contained skipwhite skipnl skipempty
\    /\<dscp\>/
\ nextgroup=
\    namedAlsoNotify_DscpNumber

" 'port' added after `also-notify` at 9.9
hi link namedAlsoNotify_PortNumber namedHL_Number
syn match namedAlsoNotify_PortNumber contained 
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedAlsoNotify_Dscp,
\    namedOSVZ_Masters_MML

hi link namedAlsoNotify_Port namedHL_Option
syn match namedAlsoNotify_Port contained skipwhite skipnl skipempty
\    /\<port\>/
\ nextgroup=namedAlsoNotify_PortNumber

hi link namedOSVZ_AlsoNotify namedHL_Option
" In 'server', `also-notify` is no longer valid after 9.13
syn match namedOSVZ_AlsoNotify contained skipwhite
\    /\<also\-notify\>/
\ nextgroup=
\    namedAlsoNotify_Dscp,
\    namedAlsoNotify_Port,
\    namedOSVZ_Masters_MML,
\    namedInclude,
\    namedComment,
\    namedError

" notify-source [address] 
"              ( * | <ip4_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" notify-source [ [ address ] 
"                ( * | <ip4_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
hi link named_Dscp_SC namedHL_Number
syn match named_Dscp_SC contained /\d\+/ skipwhite
\ nextgroup=namedSemicolon

hi link namedOSVZ_NotifySource_Dscp namedHL_Option
syn keyword namedOSVZ_NotifySource_Dscp contained dscp skipwhite
\ nextgroup=named_Dscp_SC

hi link namedOSVZ_NotifySource_PortValue namedHL_Number
syn match namedOSVZ_NotifySource_PortValue contained 
\ /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Dscp,
\    namedSemicolon

hi link namedOSVZ_NotifySource_Port namedHL_Option
syn keyword namedOSVZ_NotifySource_Port contained port skipwhite
\ nextgroup=namedOSVZ_NotifySource_PortValue

hi link namedOSVZ_NotifySource_Wildcard namedHL_Builtin
syn match namedOSVZ_NotifySource_Wildcard contained "\*" skipwhite
\ nextgroup=namedOSVZ_NotifySource_Port

hi link namedOSVZ_NotifySource_IP4Addr namedHL_Number
syn match namedOSVZ_NotifySource_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedOSVZ_NoityfSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_NotifySource namedHL_Option
syn keyword namedOSVZ_NotifySource contained 
\    notify-source
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_IP4Addr,
\    namedOSVZ_NotifySource_IP6Addr,
\    namedOSVZ_NotifySource_Wildcard

" notify-source-v6 [address] 
"              ( * | <ip6_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" notify-source-v6 [ [ address ] 
"                ( * | <ip6_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link namedOSVZ_NotifySource_IP6Addr namedHL_Number
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedOSVZ_NotifySource_IP6Addr contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedOSVZ_NotifySource_IP6Addr contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedOSVZ_NotifySource_IP6Addr contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_NotifySource_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_NotifySource_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedOSVZ_NotifySource_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_NotifySource_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon

" Do both IPv4 and IPv6 for notify-source
hi link namedOSVZ_NotifySource namedHL_Option
syn match namedOSVZ_NotifySource contained 
\    /notify-source-v6/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedOSVZ_NotifySource_IP6Addr

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Not the same as 'check-names' in 'options' statement
hi link namedVZ_CheckNames namedHL_Option
syn keyword namedVZ_CheckNames contained 
\    check-names
\ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC

" not the same as ixfr-from-differences in 'options' statement
hi link namedVZ_Ixfr_From_Diff namedHL_Option
syn keyword namedVZ_Ixfr_From_Diff contained ixfr-from-differences skipwhite
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections ({ ... };) of statements go below here
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options { <options_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmt_OptionsSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedOV_AML_Group,
\    namedOVZ_AML_Group,
\    namedOV_AorAAAA,
\    namedOV_AttachCache,
\    namedOVZ_AutoDNSSEC,
\    namedO_Blackhole,
\    namedO_Boolean_Group,
\    namedOS_Boolean_Group,
\    namedOSV_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedOV_Boolean_Group,
\    namedOVZ_Boolean_Group,
\    namedOV_CatalogZones,
\    namedO_CheckNames,
\    namedOVZ_CleaningInterval,
\    namedO_CookieAlgs,
\    namedO_CookieSecret,
\    namedO_DefaultKey,
\    namedO_DefaultPort,
\    namedO_DefaultServer,
\    namedO_DefaultUnlimitedSize,
\    namedOV_DefaultUnlimitedSize_Group,
\    namedOVZ_DefaultUnlimitedSize_Group,
\    namedOV_DenyAnswerAddresses,
\    namedOVZ_Dialup,
\    namedOV_DisableAlgorithms,
\    namedOV_DisableDsDigests,
\    namedOV_DisableEmptyZone,
\    namedOV_Dns64,
\    namedOV_Dns64_Group,
\    namedOVZ_DnskeyValidity,
\    namedOV_DnsrpsOptions,
\    namedOVZ_DnssecLoadkeys,
\    namedOV_DnssecLookasideKeyword,
\    namedOV_DnssecLookasideOptTD,
\    namedOVZ_DnssecMustBeSecure,
\    namedOVZ_DnssecUpdateMode,
\    namedOV_DnssecValidation,
\    namedOV_Dnstap,
\    namedOZ_DnstapIdentity,
\    namedO_DnstapOutput,
\    namedO_DnstapVersion,
\    namedO_Dscp,
\    namedOV_DualStack,
\    namedOV_FetchPers,
\    namedOV_FetchQuotaParams,
\    namedOZ_Files,
\    namedO_Filespec_Group,
\    namedOV_Filespec,
\    namedOVZ_Filespec_Group,
\    namedO_Filespec_None_ForcedQuoted_Group,
\    namedOVZ_Forward,
\    namedOVZ_Forwarders,
\    namedO_Fstrm_Model,
\    namedOV_HeartbeatInterval,
\    namedOV_Hostname,
\    namedOVZ_IgnoreWarn,
\    namedOVZ_IgnoreWarnFail,
\    namedO_InterfaceInterval,
\    namedOV_Interval_Max30ms_Group,
\    namedO_Ixfr_From_Diff,
\    namedO_KeepResponseOrder,
\    namedOV_Key,
\    namedO_ListenOn,
\    namedOVZ_MasterFileFormat,
\    namedOVZ_MasterFileStyle,
\    namedOVZ_MaxZoneTtl,
\    namedOV_MinimalResponses,
\    namedOVZ_Notify,
\    namedOSVZ_NotifySource,
\    namedOSVZ_NotifySource_Dscp,
\    namedO_Number_Group,
\    namedOV_Number_Group,
\    namedOVZ_Number_Group,
\    namedOVZ_Number_Max28days,
\    namedOV_NxdomainRedirect,
\    namedOVZ_OptATS,
\    namedOSV_OptAV6S,
\    namedO_Port,
\    namedOV_Prefetch,
\    namedOV_QnameMin,
\    namedOSV_QuerySource,
\    namedOSV_QuerySourceIP6,
\    namedOV_RateLimit,
\    namedO_RecursingFile,
\    namedOVZ_RefreshRetry,
\    namedOV_ResponsePadding,
\    namedOV_ResponsePolicy,
\    namedOV_RootDelegation,
\    namedOV_RrsetOrder,
\    namedOVZ_SerialUpdateMethod,
\    namedO_ServerId,
\    namedO_SessionKeyAlg,
\    namedO_SessionKeyfile,
\    namedOVZ_SessionKeyname,
\    namedOVZ_SigSigning,
\    namedOV_SizeSpec_Group,
\    namedO_String_QuoteForced,
\    namedO_TkeyDhkey,
\    namedO_TkeyDomain,
\    namedO_TkeyGSSAPICredential,
\    namedO_TkeyGSSAPIKeytab,
\    namedOSV_TransferFormat,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedOV_Ttl_Group,
\    namedOV_Ttl_Max3h_Group,
\    namedOV_Ttl_Max1week_GRoup,
\    namedOV_Ttl90sec_Group,
\    namedO_UdpSize,
\    namedO_UdpPorts,
\    namedO_UseV4UdpPorts,
\    namedO_UseV6UdpPorts,
\    namedOV_ValidExcept,
\    namedO_Version,
\    namedOVZ_ZoneStat,
\    namedParenError

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmt_ServerNameIdentifier> { <namedStmtServerKeywords>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmt_ServerSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedS_Bool_Group,
\    namedOS_Boolean_Group,
\    namedOSV_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedS_Keys,
\    namedOSVZ_NotifySource,
\    namedOSVZ_NotifySource_Dscp,
\    namedS_NumberGroup,
\    namedOSV_OptAV6S,
\    namedOSV_QuerySource,
\    namedOSV_QuerySourceIP6,
\    namedOSV_TransferFormat,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedS_UdpSize,
\    namedInclude,
\    namedError


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmt_ServerNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmt_ServerNameIdentifier namedHL_Identifier
syn match namedStmt_ServerNameIdentifier contained
\ /[0-9]\{1,3}\(\.[0-9]\{1,3}\)\{0,3}\([\/][0-9]\{1,3}\)\{0,1}/
\ skipwhite
\ nextgroup=
\    namedComment,
\    namedInclude,
\    namedStmt_ServerSection,
\    namedError 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" statistics-channels {
"        inet ( <ipv4_address> | 
"               <ipv6_address> |
"               * )
"             [ port ( <integer> | * ) ] 
"             [ allow { 
"                 <address_match_element>; ...
"                     } ]; // may occur multiple times
"}; // may occur multiple times
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedSt_InetOptReadonlyBool namedHL_Option
syn match namedSt_InetOptReadonlyBool contained /\i/
\ skipwhite skipnl skipempty
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

hi link namedSt_InetOptReadonlyKeyword namedHL_Option
syn match namedSt_InetOptReadonlyKeyword contained /read\-only/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedSt_InetOptReadonlyBool

syn region namedSt_InetAMLSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    named_E_IP6Addr_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedSemicolon,
\    namedInclude,
\    namedComment
\ nextgroup=
\    namedSt_InetOptReadonlyKeyword,
\    namedSemicolon

hi link namedSt_InetOptAllowKeyword namedHL_Option
syn match namedSt_InetOptAllowKeyword contained /\<allow\>/
\ skipwhite skipnl skipempty
\ nextgroup=namedSt_InetAMLSection,namedComment

hi link namedSt_InetOptPortWild namedHL_Builtin
syn match namedSt_InetOptPortWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=namedSt_InetOptAllowKeyword

hi link namedSt_InetOptPortNumber namedHL_Number
syn match namedSt_InetOptPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedSt_InetOptAllowKeyword,
\    namedSemicolon

hi link namedSt_InetOptPortKeyword namedHL_Option
syn match namedSt_InetOptPortKeyword contained /port/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedSt_InetOptPortWild,
\    namedSt_InetOptPortNumber


hi link namedSt_InetOptIPaddrWild namedHL_Builtin
syn match namedSt_InetOptIPaddrWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedSt_InetOptPortKeyword,
\    namedSt_InetOptAllowKeyword

syn match namedSt_InetOptIPaddr contained /[0-9a-fA-F\.:]\{3,45}/ 
\ skipwhite skipnl skipempty
\ contains=named_IP6Addr,named_IP4Addr
\ nextgroup=
\    namedSt_InetOptPortKeyword,
\    namedSt_InetOptAllowKeyword

hi link namedSt_ClauseInet namedHL_Option
syn match namedSt_ClauseInet contained /inet/
\ skipnl skipempty skipwhite 
\ nextgroup=
\    namedSt_InetOptACLName,
\    namedSt_InetOptIPaddrWild,
\    namedSt_InetOptIPaddr

syn region namedStmt_StatisticsChannel contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ contains=namedSt_ClauseInet
\ nextgroup=namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" trust-anchors { <domain_name>
"                     ( initial-key | static-key )
"                         <flag_type> <protocol> <algorithm> <secret>;
"                  ... }; // may occur multiple times, deprecated
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedTa_Key namedHL_Builtin
syn keyword namedTa_Key contained skipwhite skipnl skipempty
\    initial-key
\    static-key
\    initial-ds
\    static-ds
\ nextgroup=namedTk_Flag

hi link namedTa_Domain namedHL_String
syn match namedTa_Domain  contained /\<\S\{1,256}\>/
\ skipwhite skipnl skipempty
\ nextgroup=namedTa_Key

syn region namedTa_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ contains=namedTa_Domain
\ nextgroup=namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" trusted-keys { <domain_name> <flag_type> <protocol> <algorithm> <secret>;
"                  ... }; // may occur multiple times, deprecated
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedTk_Secret namedHL_Number
syn match namedTk_Secret contained /\S\{1,4099}/
\ skipwhite skipnl skipempty
\ nextgroup=namedTk_Semicolon

hi link namedTk_Algorithm namedHL_Number
syn match namedTk_Algorithm contained /\d\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=namedTk_Secret

hi link namedTk_Protocol namedHL_Number
syn match namedTk_Protocol contained /\d\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=namedTk_Algorithm

hi link namedTk_Flag namedHL_Number
syn match namedTk_Flag contained /\d\{1,5}/
\ skipwhite skipnl skipempty
\ nextgroup=namedTk_Protocol

hi link namedTk_Domain namedHL_String
syn match namedTk_Domain contained /\i\{1,1024}/
\ skipwhite skipnl skipempty
\ contains=named_String_QuoteForced
\ containedin=namedStmt_TrustedKeys
\ nextgroup=namedTk_Flag

syn region namedStmt_TrustedKeys contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" view <namedStmt_ViewNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmt_ViewSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedOV_AML_Group,
\    namedOVZ_AML_Group,
\    namedOV_AorAAAA,
\    namedOV_AttachCache,
\    namedOVZ_AutoDNSSEC,
\    namedOSV_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedOV_Boolean_Group,
\    namedOVZ_Boolean_Group,
\    namedV_Boolean_Group,
\    namedOV_CatalogZones,
\    namedVZ_CheckNames,
\    namedOVZ_CleaningInterval,
\    namedOV_DefaultUnlimitedSize_Group,
\    namedOVZ_DefaultUnlimitedSize_Group,
\    namedOV_DenyAnswerAddresses,
\    namedOVZ_Dialup,
\    namedOV_DisableAlgorithms,
\    namedOV_DisableDsDigests,
\    namedOV_DisableEmptyZone,
\    namedOV_Dns64,
\    namedOV_Dns64_Group,
\    namedOVZ_DnskeyValidity,
\    namedOV_DnsrpsOptions,
\    namedOVZ_DnssecLoadkeys,
\    namedOV_DnssecLookasideKeyword,
\    namedOV_DnssecLookasideOptTD,
\    namedOVZ_DnssecMustBeSecure,
\    namedOVZ_DnssecUpdateMode,
\    namedOV_DnssecValidation,
\    namedOV_Dnstap,
\    namedOV_DualStack,
\    namedOV_Filespec,
\    namedOV_FetchPers,
\    namedOV_FetchQuotaParams,
\    namedOVZ_Filespec_Group,
\    namedV_FilespecGroup,
\    namedOVZ_Forward,
\    namedOVZ_Forwarders,
\    namedOV_HeartbeatInterval,
\    namedOV_Hostname,
\    namedVZ_Ixfr_From_Diff,
\    namedOVZ_IgnoreWarn,
\    namedOVZ_IgnoreWarnFail,
\    namedOV_Interval_Max30ms_Group,
\    namedOV_Key,
\    namedV_Key,
\    namedV_Match,
\    namedOVZ_MasterFileFormat,
\    namedOVZ_MasterFileStyle,
\    namedOVZ_MaxZoneTtl,
\    namedOV_MinimalResponses,
\    namedV_MinuteGroup,
\    namedOVZ_Notify,
\    namedOSVZ_NotifySource,
\    namedOV_Number_Group,
\    namedOVZ_Number_Group,
\    namedOVZ_Number_Max28days,
\    namedOV_NxdomainRedirect,
\    namedOVZ_OptATS,
\    namedOSV_OptAV6S,
\    namedOV_Prefetch,
\    namedV_Plugin,
\    namedOV_QnameMin,
\    namedOSV_QuerySource,
\    namedOSV_QuerySourceIP6,
\    namedOV_RateLimit,
\    namedOVZ_RefreshRetry,
\    namedOV_ResponsePadding,
\    namedOV_ResponsePolicy,
\    namedOV_RootDelegation,
\    namedOV_RrsetOrder,
\    namedOVZ_SerialUpdateMethod,
\    namedOVZ_SessionKeyname,
\    namedOVZ_SigSigning,
\    namedOV_SizeSpec_Group,
\    namedOV_Ttl_Group,
\    namedOV_Ttl_Max3h_Group,
\    namedOV_Ttl_Max1week_GRoup,
\    namedOV_Ttl90sec_Group,
\    namedOSV_TransferFormat,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedV_UdpSize,
\    namedOV_ValidExcept,
\    namedOVZ_ZoneStat,
\    namedParenError

" charset_view_name_base = alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed
"
hi link namedStmt_ViewClass namedHL_ClassName
syn match namedStmt_ViewClass contained 
\    /\<\c\%(CHAOS\)\|\%(HESIOD\)\|\%(IN\)\|\%(CH\)\|\%(HS\)\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedStmt_ViewSection,
\    namedInclude,
\    namedComment
hi link namedStmt_ViewNameIdentifier namedHL_ViewName
syn match namedStmt_ViewNameIdentifier contained /\S\{1,63}/ 
\ contains=namedViewName
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedStmt_ViewSection,
\    namedStmt_ViewClass,
\    namedInclude,
\    namedComment

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" zone <namedStmt_ZoneNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmt_ZoneSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedOVZ_AML_Group,
\    namedOVZ_AutoDNSSEC,
\    namedOVZ_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedZ_Boolean_Group,
\    namedVZ_CheckNames,
\    namedOVZ_CleaningInterval,
\    namedZ_Database,
\    namedOVZ_DefaultUnlimitedSize_Group,
\    namedOVZ_Dialup,
\    namedOVZ_DnskeyValidity,
\    namedOVZ_DnssecLoadkeys,
\    namedZ_DnssecPolicy,
\    namedOVZ_DnssecMustBeSecure,
\    namedOVZ_DnssecUpdateMode,
\    namedOZ_DnstapIdentity,
\    namedZ_File,
\    namedOZ_Files,
\    namedOVZ_Filespec_Group,
\    namedZ_Filespec_Group,
\    namedOVZ_Forward,
\    namedOVZ_Forwarders,
\    namedOVZ_IgnoreWarn,
\    namedOVZ_IgnoreWarnFail,
\    namedZ_InView,
\    namedVZ_Ixfr_From_Diff,
\    namedOVZ_MasterFileFormat,
\    namedOVZ_MasterFileStyle,
\    namedZ_Masters,
\    namedOVZ_MaxZoneTtl,
\    namedOVZ_Notify,
\    namedOSVZ_NotifySource,
\    namedOVZ_Number_Group,
\    namedOVZ_Number_Max28days,
\    namedOVZ_OptATS,
\    namedOVZ_RefreshRetry,
\    namedOVZ_SerialUpdateMethod,
\    namedZ_ServerAddresses,
\    namedZ_ServerNames,
\    namedOVZ_SessionKeyname,
\    namedOVZ_SigSigning,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedZ_UpdatePolicy,
\    namedOVZ_ZoneStat,
\    namedZ_ZoneType,
\    namedParenError

hi link namedStmtZoneClass namedHL_Identifier
syn match namedStmtZoneClass contained /\<\c\%(CHAOS\)\|\%(HESIOD\)\|\%(IN\)\|\%(CH\)\|\%(HS\)\>/
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedStmt_ZoneSection,
\    namedComment

hi link namedStmt_ZoneNameIdentifier namedHL_Identifier
syn match namedStmt_ZoneNameIdentifier contained /\S\{1,63}/ 
\ skipwhite skipempty skipnl
\ contains=named_QuotedDomain
\ nextgroup=
\    namedStmt_ZoneSection,
\    namedStmtZoneClass,
\    namedComment


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Top-level statment (formerly clause) keywords
" 'uncontained' statements are the ones used GLOBALLY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtKeyword namedHL_Statement
syn match namedStmtKeyword /\_^\s*\<acl\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_ACLIdentifier

syn match namedStmtKeyword /\_^\s*\<controls\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedC_ControlsSection

syn match namedStmtKeyword /\_^\s*\<dnssec-policy\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=
\    namedDp_DomainName,
\    namedDp_DomainNameBuiltin

syn match namedStmtKeyword /\_^\s*\<dlz\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=namedD_Identifier
\ containedin=
\    namedStmt_ViewSection,
\    namedStmt_ZoneSection

syn match namedStmtKeyword /\_^\s*\<dyndb\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedStmtDyndbIdent
\ containedin=namedStmt_ViewSection

syn match namedStmtKeyword /\_^\s*\<key\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedStmtKeyIdent 

syn match namedStmtKeyword /\_^\s*\<logging\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=namedL_LoggingSection 

syn match namedStmtKeyword /\_^\s*\<managed-keys\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedStmt_ManagedKeysSection 

syn match namedStmtKeyword /\_^\s*\<masters\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=
\    namedM_Identifier,
\    namedComment, 
\    namedInclude
" \ namedError prevents a linefeed between 'master' and '<master_name'

syn match namedStmtKeyword /\_^\s*\<options\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedStmt_OptionsSection 

syn match namedStmtKeyword /\_^\s*\<plugin\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedStmt_Plugin_QueryKeyword,
\    namedP_Filespec_SC

syn match  namedStmtKeyword /\_^\s*\<server\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=namedStmt_ServerNameIdentifier,namedComment 
\ containedin=namedStmt_ViewSection

syn match namedStmtKeyword /\_^\s*\<statistics-channels\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=namedStmt_StatisticsChannel

syn match namedStmtKeyword /\_^\s*\<trust-anchors\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=namedTa_Section
\ containedin=namedStmt_OptionsSection

syn match namedStmtKeyword /\_^\s*\<trusted-anchors\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=namedStmt_TrustedKeys
\ containedin=namedStmt_OptionsSection

syn match namedStmtKeyword /\_^\s*\<trusted-keys\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=namedStmt_TrustedKeys
\ containedin=namedStmt_OptionsSection

" view <namedStmt_ViewNameIdentifier> { ... };  
syn match namedStmtKeyword /\_^\s*\<view\>/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedStmt_ViewNameIdentifier,
\    namedInclude,
\    namedComment

" TODO: namedStmtError, how to get namedHL_Error to appear
" zone <namedStmt_ZoneNameIdentifier> { ... };
syn match namedStmtKeyword /\_^\_s*\<zone\>/ skipempty skipnl skipwhite
\ nextgroup=
\    namedStmt_ZoneNameIdentifier,
\    namedComment,
\    namedStmtError 
\ containedin=namedStmt_ViewSection

let &cpoptions = s:save_cpo
unlet s:save_cpo

let b:current_syntax = 'named'

if main_syntax ==# 'bind-named'
  unlet main_syntax
endif

" Google Vimscript style guide
" vim: ts=2 sts=2 ts=80
