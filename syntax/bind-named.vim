" Vim syntax file for ISC BIND named configuration file
" Language:     ISC BIND named configuration file
" Maintainer:   egberts <egberts@github.com>
" Last change:  2020-03-12
" Filenames:    named.conf, rndc.conf
" Filenames:    named[-_]*.conf, rndc[-_]*.conf
" Filenames:    *[-_]named.conf
" Location:     http://github.com/egberts/bind-named-vim-syntax
" License:      MIT license
" Remarks:
"	
"
" Inspired by Nick Hibma <nick@van-laarhoven.org> 'named.vim',
" also by glory hump <rnd@web-drive.ru>, and Marcin Dalecki.
"
" Jumpstarted to Bind 9.15 by Egberts <egberts@github.com>
"
" This file could do with a lot of improvements, so comments are welcome.
" Please submit the named.conf (segment) with any comments.
"
" Basic highlighting is covered for all Bind configuration 
" options.  Only normal (defaults is white) highlight gets 
" used to show 'undetected' Bind syntax.  
"
" Every valid keywords get colorized. Every character-valid 
" values get colorized, some range-checking here.
"
" New Bind 9.13+ terminologies here:
"    Stmt   - top-level keyword (formerly 'clause' from Bind 4 
"             to 9.11)
"    Opt    - an option keyword found within each of its 
"             top-level keywords.
"    Clause - very specific keywords used within each of its 
"             option statement
"
" Syntax Naming Convention: 
"    All macro names that are defined here start with 
"    'named' prefix. This is a Vim standard.
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
" simplistic IP address syntax processing here.
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
"           that 'nextgroup'.
"
" NOTE: DON'T put inline comment on continuation lines.  It hurts, badly.
"
" quit when a syntax file was already loaded
if !exists("main_syntax")
  if exists('b:current_syntax')
    finish
  endif
  let main_syntax='bind-named'
endif

syn case match

setlocal iskeyword=.,-,48-58,A-Z,a-z
setlocal isident=.,-,48-58,A-Z,a-z,_

" I've got the largest named.conf possible.
" it's a heavily commented named.cnf file containing every 
" valid statements, options, and clauses.
" sync is barely triggered here.
syn sync match namedSync grouphere NONE "^(zone|controls|acl|key)"

let s:save_cpo = &cpoptions
set cpoptions-=C

" First-level highlighting

hi link namedComment	Comment
hi link namedInclude	DiffAdd
hi link namedHL_Identifier 	Identifier

hi link namedHL_Statement	Keyword
hi link namedHL_Option	Label     " could use a 2nd color here
hi link namedHL_Clause	Keyword   " could use a 3rd color here
hi link namedHL_Type	Type
" Bind has only one operator '!'
hi default link namedHL_Operator Operator  

hi link namedHL_Number	Number
hi link namedHL_String	String
hi link namedHL_Builtin	Special " Bind's builtins: 'any', 'none', 'localhost'
hi link namedHL_Underlined	Underlined
" Do not use Vim's "Boolean" highlighter, we have our own syntax.

hi link namedHL_Error	Error


" Bind Statements (top-level)
hi link namedACLKeyword	namedHL_Statement
hi link namedC_Keyword	namedHL_Statement
hi link namedDLZKeyword	namedHL_Statement
hi link namedKeyKeyword	namedHL_Statement
hi link namedLoggingKeyword	namedHL_Statement
hi link namedManagedKeysKeyword	namedHL_Statement
hi link namedLWRESKeyword	namedHL_Statement  " gone in 9.13.0 
hi link namedMastersKeyword	namedHL_Statement
hi link namedStmtServerKeywords	namedHL_Statement
hi link namedStatisticsChannelsKeyword	namedHL_Statement
hi link namedTrustedKeysKeyword	namedHL_Statement
hi link namedStmtViewKeywords	namedHL_Statement

" Second-level highlighting

hi link namedACLIdent	namedHL_Identifier
hi link namedACLName	namedHL_Identifier
hi link namedChannelIdent	namedHL_Identifier
hi link namedChannelName	namedHL_Identifier
hi link namedKeyIdent	namedHL_Identifier
hi link namedKeyName	namedHL_Identifier
hi link namedStmt_MastersNameIdentifier	namedHL_Identifier
hi link namedMasterName	namedHL_Identifier
hi link namedElementMasterName	namedHL_Identifier
hi link namedStmt_ServerNameIdentifier namedHL_Identifier
hi link namedServerName	namedHL_Identifier
hi link namedViewName	namedHL_Identifier
hi link namedStmt_ZoneNameIdentifier	namedHL_Identifier
hi link namedZoneName	namedHL_Identifier
hi link namedElementZoneName	namedHL_Identifier
hi link namedHLDomain	namedHL_String 
hi link namedString	namedHL_String
hi link named_Number_GID	namedHL_Number
hi link namedUserID	namedHL_Number
hi link namedFilePerm   namedHL_Number
hi link namedWildcard   namedHL_Number

" Third-level highlighting
"   - Type
"   - Type
"   - Number
"   - Identifier
hi link namedDNSSECLookaside	namedHL_Number
hi link namedDSS_OptGlobalPort	namedKeyword
hi link namedWildcard	namedHL_Number
hi link namedFilesCount	namedHL_Number
hi link namedOK         21

hi link namedClauseKeyword	namedHL_Option
hi link namedKeyword	namedHL_Option
hi link namedIntKeyword	namedHL_Option

hi link namedTypeMinutes	namedHL_Number
hi link namedHexNumber	namedHL_Number
hi link named_IP4Addr	namedHL_Number
hi link namedIPwild	namedHL_Number
hi link namedNumber	namedHL_Number
hi link namedDSCP	namedHL_Number
hi link namedTypeBase64	namedHL_Identifier "  RFC 3548

hi link namedKeyAlgorithmName namedHL_Number
hi link namedKeySecretValue namedTypeBase64
hi link namedHexSecretValue namedHexNumber

hi link namedTypeBool	namedHL_Type
hi link namedQSKeywords	namedHL_Type
hi link namedCNKeywords	namedHL_Type
hi link namedLogCategory	namedHL_Type
hi link namedTypeZone	namedHL_Type

hi link namedC_Inet	namedHL_Clause
hi link namedC_Port	namedHL_Clause
hi link namedC_Allow	namedHL_Clause
hi link namedC_Key	namedHL_Clause

hi link named_String_QuoteForced	namedHL_String
hi link named_String_SQuoteForced	namedHL_String
hi link named_String_DQuoteForced	namedHL_String


hi link namedNotBool	namedHL_Error
hi link namedNotNumber	namedHL_Error
hi link namedNotSemicolon	namedHL_Error
hi link namedParenError	namedHL_Error
hi link namedNotParenError	namedHL_Error
hi link namedEParenError	namedHL_Error
hi link namedIllegalDom	namedHL_Error
hi link namedIPerror	namedHL_Error
hi link namedSpareDot	namedHL_Error
hi link namedError	namedHL_Error



" Down-Top syntax approach.
" Smallest granular definition starts here.
" Largest granular definition goes at the bottom.
" Pay attention to tighest-pattern-first ordering of syntax.
"
" Many Vim-match/region/keyword are mixed together here by
" reusing its same macro name, to attain that desired 
" First-match method.

" 'Vim-uncontained' statements are the ones used GLOBALLY

" Builtins are not Vim-'contained' as to prevent 
" its re-use as a Vim-String or Bind-identifier.
hi link namedBuiltinsKeyword namedHL_Builtin
syn keyword namedBuiltinsKeyword any none localhost localnets

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FIXED-LENGTH PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedToDo Todo
syn keyword namedToDo xxx contained XXX FIXME TODO TODO: FIXME:

hi link named_Builtin_None namedHL_Builtin
syn keyword named_Builtin_None contained none skipwhite
\ nextgroup=namedSemicolon


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variable-LENGTH static PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" --- Other variants of strings
hi link named_Filespec	namedHL_String
syn match named_Filespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match named_Filespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match named_Filespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl

hi link named_E_Filespec_SC namedHL_String
" TODO those curly braces and semicolon MUST be able to work within quotes.
syn match named_E_Filespec_SC contained /\'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)\+{}]\{1,1024}\'/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /"[ a-zA-Z\]\-\[0-9\._,:\;\/?<>|'`~!@#$%\^&*\\(\\)\+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl nextgroup=namedSemicolon

hi link namedSemicolon namedOK
syn match namedSemicolon contained /\(;\+\s*\)\+/ skipwhite
" We need a better NotSemicolon pattern here
syn match namedNotSemicolon contained /[^;]\+/he=e-1 skipwhite
syn match namedError /[^;{#]$/

syn match namedNotNumber contained "[^  0-9;]\+"
syn match namedNumber contained "\d\+"

hi link named_Number_SC	namedHL_Number
syn match named_Number_SC contained "\d\{1,10}" skipwhite nextgroup=namedSemicolon

" <0-30000> (resolver-query-timeout in millisecond)
hi link named_Interval_Max30ms_SC namedHL_Number
syn match named_Interval_Max30ms_SC contained /\d\+/ skipwhite
\ nextgroup=namedSemicolon

" <0-30> (servfail-ttl)
hi link named_Ttl_Max30sec_SC namedHL_Number
syn match named_Ttl_Max30sec_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" <0-90> (min-cache-ttl)
hi link named_Ttl_Max90sec_SC namedHL_Number
syn match named_Ttl_Max90sec_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" <0-1200> ([max-]clients-per-query)
hi link named_Number_Max20min_SC	namedHL_Number
syn match named_Number_Max20min_SC contained "\d\{1,10}" skipwhite nextgroup=namedSemicolon

" edns-udp-size: range: 512 to 4096 (default 4096)
hi link named_Number_UdpSize namedHL_Number
syn match named_Number_UdpSize contained skipwhite
\  /\(51[2-9]\)\|\(5[2-9][0-9]\)\|\([6-9][0-9][0-9]\)\|\([1-3][0-9][0-9][0-9]\)\|\(40[0-8][0-9]\)\|\(409[0-6]\)/
\ nextgroup=namedSemicolon

" TTL <0-10800> (max-ncache-ttl)
hi link named_Ttl_Max3hour_SC namedHL_Number
syn match named_Ttl_Max3hour_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" TTL <0-1800> (lame-ttl)
hi link named_Ttl_Max30min_SC namedHL_Number
syn match named_Ttl_Max30min_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" <0-3660> days (dnskey-sig-validity)
hi link named_Number_Max3660days namedHL_Number
syn match named_Number_Max3660days contained skipwhite
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ nextgroup=namedSemicolon

" <0-604800> (max-cache-ttl)
hi link named_Ttl_Max1week_SC namedHL_Number
syn match named_Ttl_Max1week_SC contained skipwhite
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
hi link named_Number_Max24week_SC	namedHL_Number
syn match named_Number_Max24week_SC contained "\d\{1,10}" skipwhite nextgroup=namedSemicolon


syn match named_Number_GID contained "[0-6]\{0,1}[0-9]\{1,4}"
syn match namedUserID contained "[0-6]\{0,1}[0-9]\{1,4}"
syn match namedFilePerm contained "[0-7]\{3,4}"
syn match namedDSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/

hi link named_Port	namedHL_Number
syn match named_Port contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link named_Port_SC	namedHL_Number
syn match named_Port_SC contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/ skipwhite nextgroup=namedSemicolon

hi link named_PortWild    	namedWildcard
syn match named_PortWild contained /\*/
syn match named_PortWild contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link namedElementPortWild namedHL_Number
syn match namedElementPortWild contained /\*\s*;/ skipwhite
"syn match namedElementPortWild contained /\d\{1,5}\s*;/hs=s,me=e-1
syn match namedElementPortWild contained /\%([1-9]\|[1-5]\?[0-9]\{2,4}\|6[1-4][0-9]\{3}\|65[1-4][0-9]\{2}\|655[1-2][0-9]\|6553[1-5]\)\s*;/he=e-1
\ contains=named_Port skipwhite

syn match namedWildcard contained /\*/

hi link named_Boolean_SC	namedTypeBool
syn match named_Boolean_SC contained /\cyes/ skipwhite nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\cno/ skipwhite nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\ctrue/ skipwhite nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\cfalse/ skipwhite nextgroup=namedSemicolon
syn keyword named_Boolean_SC contained 1 skipwhite nextgroup=namedSemicolon
syn keyword named_Boolean_SC contained 0 skipwhite nextgroup=namedSemicolon

syn match namedNotBool contained "[^  ;]\+"
syn match namedTypeBool contained /\cyes/
syn match namedTypeBool contained /\cno/
syn match namedTypeBool contained /\ctrue/
syn match namedTypeBool contained /\cfalse/
syn keyword namedTypeBool contained 1
syn keyword namedTypeBool contained 0

hi link named_IgnoreWarnFail_SC	namedHL_Type
syn match named_IgnoreWarnFail_SC contained /\cwarn/ skipwhite nextgroup=namedSemicolon
syn match named_IgnoreWarnFail_SC contained /\cfail/ skipwhite nextgroup=namedSemicolon
syn match named_IgnoreWarnFail_SC contained /\cignore/ skipwhite nextgroup=namedSemicolon

hi link named_StrictRelaxedDisabledOff namedHL_Type
syn match named_StrictRelaxedDisabledOff  contained /\cstrict/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\crelaxed/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\cdisabled/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\coff/ skipwhite nextgroup=namedSemicolon

syn match namedACLName contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ skipwhite
hi link named_E_ACLName_SC namedHL_Identifier
syn match named_E_ACLName_SC contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/
\ skipwhite
\ nextgroup=namedSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REGEX PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOV_CZ_MasterName_SC namedHL_Identifier
syn match namedOV_CZ_MasterName_SC contained /\<[0-9a-zA-Z\-_\.]\{1,63}/
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOV_CZ_DefMasters_MML

hi link named_IP6Addr namedHL_Number
hi link named_IP6AddrPrefix namedHL_Number

hi link named_IP4Addr namedHL_Number
syn match named_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ containedin=
\    namedOV_CZ_DefMasters_MML,
\    namedElementAMLSection

hi link named_IP4AddrPrefix namedHL_Number
syn match named_IP4AddrPrefix contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
\ containedin=
\    namedOV_CZ_DefMasters_MML,
\    namedElementAMLSection

hi link named_E_IP4Addr_SC namedHL_Number
syn match named_E_IP4Addr_SC contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon
\ containedin=
\    namedOV_CZ_DefMasters_MML,
\    namedElementAMLSection
hi link named_E_IP4AddrPrefix_SC namedHL_Number
syn match named_E_IP4AddrPrefix_SC contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
\ containedin=
\    namedOV_CZ_DefMasters_MML,
\    namedElementAMLSection

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
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ nextgroup=namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,7}:/ nextgroup=namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ nextgroup=namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/ nextgroup=namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/ nextgroup=namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/ nextgroup=namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/ nextgroup=namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_E_IP6Addr_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/ nextgroup=namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_E_IP6Addr_SC contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/ nextgroup=namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_E_IP6Addr_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/ nextgroup=namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_E_IP6Addr_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ nextgroup=namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_E_IP6Addr_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/ nextgroup=namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon

" Full IPv6 with Prefix with trailing semicolon
hi link named_E_IP6AddrPrefix_SC namedHL_Number
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_E_IP6AddrPrefix_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_E_IP6AddrPrefix_SC contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/ nextgroup=namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_E_IP6AddrPrefix_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}\/[0-9]\{1,3}%[a-zA-Z0-9]\{1,64}/ nextgroup=namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_E_IP6AddrPrefix_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_E_IP6AddrPrefix_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon

" Full IPv6 with Prefix (without semicolon)
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


hi link named_AllowMaintainOff_SC	namedHL_Type
syn match named_AllowMaintainOff_SC contained /\callow/ skipwhite nextgroup=namedSemicolon
syn match named_AllowMaintainOff_SC contained /\cmaintain/ skipwhite nextgroup=namedSemicolon
syn match named_AllowMaintainOff_SC contained /\coff/ skipwhite nextgroup=namedSemicolon


" --- string 
syn region namedString start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
syn region namedString start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
syn match namedString contained /\<[a-zA-Z0-9_\.\-]\{1,63}\>/
syn region named_String_DQuoteForced start=/"/ skip=/\\"/ end=/"/ contained
syn region named_String_SQuoteForced start=/'/ skip=/\\'/ end=/'/ contained
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
syn match namedTypeBase64 contained /\<[0-9a-zA-Z\/\-\_\,+=]\{1,4099}/
syn match namedKeySecretValue contained /\<[0-9a-zA-Z\+\=\/]\{1,4099}\s*;/he=e-1 skipwhite

syn match namedKeyName contained /\<[0-9a-zA-Z\-_]\{1,64}/ skipwhite
syn match namedKeyAlgorithmName contained /\<[0-9A-Za-z\-_]\{1,4096}/ skipwhite
syn match namedMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}/ skipwhite
syn match namedElementMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}\s*;/he=e-1 skipwhite
syn match namedHexSecretValue contained /\<'[0-9a-fA-F]\+'\>/ skipwhite
syn match namedHexSecretValue contained /\<"[0-9a-fA-F]\+"\>/ skipwhite

" syn match namedViewName contained /[a-zA-Z0-9_\-\.+~@$%\^&*()=\[\]\\|:<>`?]\{1,64}/ skipwhite
syn match namedViewName contained /[a-zA-Z0-9\-_\.]\{1,64}/ skipwhite

hi link named_E_ViewName_SC namedHL_Identifier
syn match named_E_ViewName_SC contained /[a-zA-Z0-9\-_\.]\{1,63}/ skipwhite
\ nextgroup=namedSemicolon

syn match namedZoneName contained /[a-zA-Z0-9]\{1,64}/ skipwhite
syn match namedElementZoneName contained /[a-zA-Z0-9]\{1,63}\s*;/he=e-1 skipwhite

hi link namedDlzName namedHL_Identifier
syn match namedDlzName contained /[a-zA-Z0-9_\.\-]\{1,63}/ skipwhite
hi link namedDyndbName namedHL_Identifier
syn match namedDyndbName contained /[a-zA-Z0-9_\.\-]\{1,63}/ skipwhite

syn match namedKRB5username contained /\i\+;/he=e-1 skipwhite
syn match namedKRB5realm contained /\i\+;/he=e-1 skipwhite
syn match namedKRB5principal contained /\i\+;/he=e-1 skipwhite

syn match namedTypeSeconds /\d\{1,11}\s*;/he=e-1 contained skipwhite
syn match namedTypeMinutes contained /\d\{1,11}\s*;/he=e-1 skipwhite
syn match namedTypeDays contained /\d\{1,11}\s*;/he=e-1 skipwhite
syn match namedTypeCacheSize contained /\d\{1,3}\s*;/he=e-1 skipwhite

" --- syntax errors
syn match namedIllegalDom contained /"\S*[^-A-Za-z0-9.[:space:]]\S*"/ms=s+1,me=e-1
syn match namedIPerror contained /\<\S*[^0-9.[:space:];]\S*/
syn match namedNotParenError contained +\([^{]\|$\)+ skipwhite
syn match namedEParenError contained +{+
syn match namedParenError +}\([^;]\|$\)+


" --- IPs & Domains


syn match namedIPwild contained /\*/
syn match namedSpareDot contained /\./
syn match namedSpareDot_SC contained /\.\s\+;/



" syn match namedDomain contained /"\."/ms=s+1,me=e-1 skipwhite
hi link namedDomain namedHLDomain
syn match namedDomain contained /\<[0-9A-Za-z\._\-]\+\>/ nextgroup=namedSpareDot
hi link named_QuotedDomain	namedHLDomain
syn match named_QuotedDomain contained /\<[0-9A-Za-z\._\-]\{1,1023}\>/ nextgroup=namedSpareDot
syn match named_QuotedDomain contained /'\<[0-9A-Za-z\.\-_]\{1,1023}'\>/hs=s+1,he=e-1 nextgroup=namedSpareDot
syn match named_QuotedDomain contained /"\<[0-9A-Za-z\.\-_]\{1,1023}"\>\"/ nextgroup=namedSpareDot
hi link named_QuotedDomain_SC	namedHLDomain
syn match named_QuotedDomain_SC contained /[0-9A-Za-z\._\-]\{1,1023}\.\{0,1}/ nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /'[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}'/hs=s+1,he=e-1 nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /"[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}"/hs=s+1,he=e-1 nextgroup=namedSemicolon skipwhite

hi link named_E_Domain_SC namedHLDomain
syn match named_E_Domain_SC contained /\<[0-9A-Za-z\._\-]\+\>/
\ nextgroup=namedSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nesting of PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn match namedComment "//.*" contains=namedToDo
syn match namedComment "#.*" contains=namedToDo
syn region namedComment start="/\*" end="\*/" contains=namedToDo
syn match namedInclude /\_s*include/ 
\ nextgroup=named_E_Filespec_SC
\ skipwhite skipnl skipempty


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -- Vim syntax clusters
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax cluster namedClusterCommonNext contains=namedComment,namedInclude,namedError
hi link namedClusterBoolean_SC namedHL_Error
syntax cluster namedClusterBoolean_SC contains=named_Boolean_SC
syntax cluster namedClusterBoolean contains=namedTypeBool,namedNotBool,@namedClusterCommonNext
syntax cluster namedDomainFQDNCluster contains=namedDomain,namedError
syn cluster namedCommentGroup contains=namedToDo


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


syn region named_E_IP4Addr_SCList contained start=+{+ end=+}\s*;+he=e-1
\ contains=named_E_IP4Addr_SC,namedIPerror,namedParenError,namedComment

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BIND builtins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" AML Section/Elements
syn region namedElementAMLSection contained start=+{+ end=+;+ skipwhite skipempty
\ contains=
\    namedInclude,
\    namedComment,
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC  " TODO find a way to show Builtins before ACLName
\ nextgroup=
\    namedSemicolon,
\    namedParenError

syn region named_E_AMLSection_SC contained start=/{/ end=/}/ skipwhite skipempty
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedParenError,
\    namedInclude,
\    namedComment 
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

syn match namedStmtACLIdent contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ 
\ skipwhite skipnl skipempty
\ nextgroup=namedElementAMLSection
\ contains=namedACLName

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
" Identifiers
" syn keyword namedC_Keyword contained inet containedin=namedClause
" syn keyword namedC_Keyword contained unix containedin=namedClause
" + these keywords are contained within `controls' section only
" syn keyword namedIntKeyword contained unix nextgroup=namedString skipwhite
" syn keyword namedIntKeyword contained port perm owner group nextgroup=namedNumber,namedNotNumber skipwhite
" syn keyword namedIntKeyword contained allow nextgroup=namedIntSection skipwhite

" hi link namedC_InetOptACLName namedHL_Number
" again, orderings matter 
" (you can't use nextgroup for ordering)
" (only line position of statements of those referenced by its 'nextgroup')
syn match namedC_InetOptACLName contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ 
\ skipwhite skipnl skipempty
\ contains=namedACLName
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

hi link namedC_ClauseInet namedHL_Option
syn match namedC_OptReadonlyBool /\i/ contained skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedC_OptReadonlyKeyword namedHL_Option
syn match namedC_OptReadonlyKeyword /read\-only/ contained skipwhite
\ nextgroup=
\    namedC_OptReadonlyBool,
\    namedError

syn match namedC_UnixOptKeysElement /[a-zA-Z0-9_\-\.]\+/
\ contained 
\ contains=namedKeyName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError
\ containedin=
\    namedC_UnixOptKeysSection

syn region namedC_UnixOptKeysSection start=+{+ end=+}+
\ contained skipwhite
\ contains=namedC_UnixOptKeysElement
\ nextgroup=
\    namedC_OptReadonlyKeyword,
\    namedSemicolon

hi link namedC_UnixOptKeysKeyword namedHL_Option
syn match namedC_UnixOptKeysKeyword /keys/ contained skipwhite
\ nextgroup=namedC_UnixOptKeysSection

syn match namedC_UnixOptGroupInteger /\d\+/ contained skipwhite
\ contains=named_Number_GID
\ nextgroup=
\     namedC_OptReadonlyKeyword,
\     namedC_UnixOptKeysKeyword,
\     namedSemicolon,
\     namedError

hi link namedC_UnixOptGroupKeyword namedHL_Option
syn match namedC_UnixOptGroupKeyword /group/ contained skipwhite
\ nextgroup=namedC_UnixOptGroupInteger,namedError

syn match namedC_UnixOptOwnerInteger /\d\+/ contained skipwhite
\ contains=namedUserID
\ nextgroup=namedC_UnixOptGroupKeyword,namedError

hi link namedC_UnixOptOwnerKeyword namedHL_Option
syn match namedC_UnixOptOwnerKeyword /owner/ contained skipwhite
\ nextgroup=namedC_UnixOptOwnerInteger,namedError

syn match namedC_UnixOptPermInteger /\d\+/ contained skipwhite
\ contains=namedFilePerm
\ nextgroup=namedC_UnixOptOwnerKeyword,namedError

hi link namedC_UnixOptPermKeyword namedHL_Option
syn match namedC_UnixOptPermKeyword /perm/ contained skipwhite
\ nextgroup=namedC_UnixOptPermInteger,namedError

syn match namedC_UnixOptSocketName contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/
\ skipwhite skipempty skipnl
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

" Dirty trick, use a single '"' char for a string match
hi link namedC_UnixOptSocketName namedHL_Number
syn match namedC_UnixOptSocketName contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

syn match namedC_UnixOptSocketName contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

hi link namedC_ClauseUnix namedHL_Option
syn keyword namedC_ClauseUnix contained unix
\ skipwhite skipnl skipempty
\ nextgroup=namedC_UnixOptSocketName
\ containedin=namedStmtControlSection

hi link namedC_InetOptReadonlyBool namedHL_Option
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

" hi link namedC_InetOptIPaddr namedHL_Number
syn match namedC_InetOptIPaddr contained /[0-9a-fA-F\.:]\{3,45}/ 
\ skipwhite skipnl skipempty
\ contains=named_IP6Addr,named_IP4Addr
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

hi link namedC_ClauseInet namedHL_Option
syn match namedC_ClauseInet contained /inet/
\ skipnl skipempty skipwhite 
\ containedin=namedStmtControlSection
\ nextgroup=
\    namedC_InetOptACLName,
\    namedC_InetOptIPaddrWild,
\    namedC_InetOptIPaddr

syn region namedStmtControlsSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ contains=
\    namedC_ClauseInet,
\    namedC_ClauseUnix,
\    namedComment,
\    namedInclude
\ nextgroup=
\    namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'dlz' statement
" 
" dlz <dlz_name> { database <string> search <boolean>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedDlzSearchBoolean namedHL_String
syn match namedDlzSearchBoolean contained /\i/
\ skipwhite
\ contains=namedTypeBool
\ nextgroup=namedSemicolon,namedDlzDatabaseKeyword

hi link namedDlzSearchKeyword namedHL_Option
syn match namedDlzSearchKeyword contained /\<search\>/
\ skipwhite
\ nextgroup=namedDlzSearchBoolean
\ containedin=namedStmtDlzSection

hi link namedDlzDatabaseString namedHL_String
syn region namedDlzDatabaseString start=/"/ skip=/\\"/ end=/"/ contained
syn region namedDlzDatabaseString start=/'/ skip=/\\'/ end=/'/ contained
\ skipwhite
\ containedin=namedStmtDlzSection
\ nextgroup=namedSemicolon,namedDlzSearchKeyword

hi link namedDlzDatabaseKeyword namedHL_Option
syn match namedDlzDatabaseKeyword contained /\<database\>/
\ skipwhite
\ nextgroup=namedDlzDatabaseString
\ containedin=namedStmtDlzSection

syn region namedStmtDlzSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

hi link namedStmtDlzIdent namedHL_Identifier
syn match namedStmtDlzIdent contained /[a-zA-Z0-9_\.\-]\{1,63}/ 
\ skipwhite 
\ nextgroup=namedStmtDlzSection
\ contains=namedDlzName

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'dyndb' statement
" 
" dyndb <dyndb_name> <device_driver_filename> { <arguments> };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link   namedDyndbDriverParameters namedHL_String
syn match namedDyndbDriverParameters contained /[<>\|:"'a-zA-Z0-9_\.\-\/\\]\+[^;]/ 
\ skipwhite skipempty skipnl
\ contains=named_String_QuoteForced
\ containedin=namedStmtDyndbSection
\ nextgroup=namedSemicolon

syn region namedStmtDyndbSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

syn match namedStmtDyndbDriverFilespec contained 
\ /[a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=namedStmtDyndbSection
\ contains=named_String_QuoteForced
syn match namedStmtDyndbDriverFilespec contained 
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=namedStmtDyndbSection
\ contains=named_String_QuoteForced
syn match namedStmtDyndbDriverFilespec contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=namedStmtDyndbSection
\ contains=named_String_QuoteForced

hi link namedStmtDyndbIdent namedHL_Identifier
syn match namedStmtDyndbIdent contained /[a-zA-Z0-9_\.\-]\{1,63}/ 
\ skipwhite 
\ nextgroup=namedStmtDyndbDriverFilespec
\ contains=namedDyndbName

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'key' statement
" 
" key <key_name> { algorithm <string>; secret <string>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedK_E_SecretValue namedTypeBase64
syn match namedK_E_SecretValue contained /["'0-9A-Za-z\+\=\/]\{1,4098}\s*;/
\ skipwhite
\ contains=namedTypeBase64
\ nextgroup=namedSemicolon,namedError

hi link namedK_E_SecretKeyword namedHL_Option
syn match namedK_E_SecretKeyword /secret/ contained skipwhite
\ nextgroup=namedK_E_SecretValue,namedError

syn match namedK_E_AlgorithmName contained /[a-zA-Z0-9\-_\.]\{1,128}\s*;/he=e-1
\ skipwhite
\ contains=namedKeyAlgorithmName
\ nextgroup=namedK_E_SecretKeyword,namedError

hi link namedK_E_AlgorithmKeyword namedHL_Option
syn match namedK_E_AlgorithmKeyword contained skipwhite /algorithm/
\ nextgroup=namedK_E_AlgorithmName,namedError

syn region namedStmtKeySection start=+{+ end=+}+
\ contained skipwhite skipempty
\ contains=
\    namedK_E_AlgorithmKeyword
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon
\ containedin=namedStmt_ViewSection

hi link namedStmtKeyIdent namedHL_Identifier
syn match namedStmtKeyIdent contained skipwhite /\i/
\ contains=namedKeyName
\ nextgroup=namedStmtKeySection,namedNotParem,namedError
\ containedin=namedStmt_ViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'logging' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # logging {
"    [ channel <channel_name> {
"        [ buffered <boolean>; ]
"        ( file <path_name>
"            [ version (<number> |unlimited) ]
"            [ size <size_spec> ]
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
hi link namedLoggingCategoryChannelName namedHL_Type
syn match namedLoggingCategoryChannelName contained /\i\+/ skipwhite
\ containedin=namedLoggingCategorySection

syn region namedLoggingCategorySection contained start=+{+ end=+}+ 
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedLoggingCategoryBuiltins namedHL_Builtin
syn keyword namedLoggingCategoryBuiltins contained skipwhite 
\    client cname config database default delegation-only dnssec dispatch
\    dnstap edns-disabled general lame-servers
\    network notify nsid queries query-errors rate-limit resolver
\    rate-limit resolver rpz security serve-stale spill 
\    trust-anchor-telemetry unmatched update update-security
\    xfer-in xfer-out zoneload 
\ nextgroup=namedLoggingCategorySection
\ containedin=namedStmtLoggingSection

hi link namedLoggingCategoryCustom Identifier
syn match namedLoggingCategoryCustom contained skipwhite /\i\+/
\ containedin=namedStmtLoggingSection

hi link namedLoggingCategoryIdent Identifier
syn match namedLoggingCategoryIdent /\i\+/ skipwhite contained
\ contains=namedLoggingCategoryBuiltins
\ nextgroup=namedLoggingCategorySection,namedError
\ containedin=namedStmtLoggingSection

hi link namedLoggingOptCategoryKeyword namedHL_Option
syn match namedLoggingOptCategoryKeyword contained skipwhite /category/
\ nextgroup=namedLoggingCategoryIdent,namedError skipwhite
\ containedin=namedStmtLoggingSection

" logging { channel xxxxx { ... }; };

hi link namedLoggingChannelSeverityDebugValue namedHL_Number
syn match namedLoggingChannelSeverityDebugValue /[0-9]\{1,5}/ 
\ contained skipwhite 
\ nextgroup=namedComment,namedSemicolon,namedNotSemicolon,namedError

hi link namedLoggingChannelSeverityDebug namedHL_Builtin
syn match namedLoggingChannelSeverityDebug contained /debug\s*[^;]/me=e-1
\ nextgroup=
\    namedLoggingChannelSeverityDebugValue,
\    namedComment,
\    namedSemicolon,
\    namedNotSemicolon_SC,
\    namedNotComment,
\    namedError
syn match namedLoggingChannelSeverityDebug contained /debug\s*;/he=e-1

hi link namedLoggingChannelSeverityType namedHL_Builtin
syn keyword namedLoggingChannelSeverityType contained
\    info
\    notice
\    warning
\    error
\    critical
\    dynamic
\ skipwhite
\ nextgroup=namedSemicolon,namedError

hi link namedLoggingChannelOptNull namedHL_Clause
syn keyword namedLoggingChannelOptNull null contained skipwhite
\ nextgroup=namedComment,namedSemicolon,namedNotSemicolon,namedError
syn keyword namedLoggingChannelOptNull stderr contained skipwhite
\ nextgroup=namedSemicolon,namedNotSemicolon,namedComment,namedError

hi link namedLoggingChannelOpts namedHL_Option
syn keyword namedLoggingChannelOpts contained skipwhite 
\    buffered
\    print-category
\    print-severity
\ nextgroup=@namedClusterBoolean_SC,namedError
" \    /\(buffered\)\|\(print\-category\)\|\(print\-severity\)/

" BUG: You can specify 'severity' twice on same line before semicolon
hi link namedLoggingChannelOptSeverity namedHL_Option
syn keyword namedLoggingChannelOptSeverity contained severity skipwhite skipempty
\ nextgroup=
\    namedLoggingChannelSeverityType,
\    namedLoggingChannelSeverityDebug,
\    namedComment,
\    namedError

" hi link namedLoggingChannelSyslogFacilityKern namedHL_Builtin
" syn keyword namedLoggingChannelSyslogFacilityKern kern contained skipwhite
" \ nextgroup=namedSemicolon,namedNotSemicolon,namedComment,namedError

hi link namedLoggingChannelSyslogFacility namedHL_Builtin
syn keyword namedLoggingChannelSyslogFacility contained
\    user kern mail daemon
\    auth syslog lpr news
\    uucp cron authpriv
\    local0 local1 local2 local3 local4
\    local5 local6 local7 local8 local9
\ nextgroup=namedSemicolon,namedComment,namedParenError,namedError

hi link namedLoggingChannelOptSyslog namedHL_Option
sy keyword namedLoggingChannelOptSyslog syslog contained skipwhite 
\ nextgroup=
\    namedLoggingChannelSyslogFacilityKern,
\    namedLoggingChannelSyslogFacilityUser,
\    namedLoggingChannelSyslogFacility,
\    namedParenError,
\    @namedClusterCommonNext,

hi link namedLoggingChannelOptPrinttimeISOs namedHL_Builtin
syn keyword namedLoggingChannelOptPrinttimeISOs contained skipwhite
\    iso8601
\    iso8601-utc
\    local
\ nextgroup=
\    namedSemicolon,
\    namedComment,
\    namedError

hi link namedLoggingChannelOptPrintTime namedHL_Option
syn match namedLoggingChannelOptPrintTime /print\-time/ contained skipwhite
\ nextgroup=
\    namedLoggingChannelOptPrinttimeISOs,
\    @namedClusterBoolean_SC,
\    namedParenError,
\    @namedClusterCommonNext,
\    namedError,

hi link namedLoggingChannelFileVersionOptUnlimited namedHL_Builtin
syn match namedLoggingChannelFileVersionOptUnlimited /unlimited/
\ contained skipwhite
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptSize,
\           namedSemicolon
syn match namedLoggingChannelFileVersionOptInteger contained skipwhite
\    /[0-9]\{1,11}/
\    contains=namedNumber
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptSize,
\           namedSemicolon
hi link namedLoggingChannelFileOptVersions namedHL_Option
syn match namedLoggingChannelFileOptVersions contained skipwhite /versions/
\ nextgroup=
\    namedLoggingChannelFileVersionOptInteger,
\    namedLoggingChannelFileVersionOptUnlimited,

hi link namedLoggingChannelFileSizeOpt namedHL_Number
" [0-9]\{1,12}\([BbKkMmGgPp]\{1}\)/
syn match namedLoggingChannelFileSizeOpt 
\ /[0-9]\{1,11}\([BbKkMmGgPp]\)\{0,1}/
\ contains=named_SizeSpec
\ contained skipwhite
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptVersions,
\           namedSemicolon

hi link namedLoggingChannelFileOptSize namedHL_Option
syn match namedLoggingChannelFileOptSize /size/
\ contained  skipwhite
\ nextgroup=namedLoggingChannelFileSizeOpt

hi link namedLoggingChannelFileSuffixOpt namedHL_Builtin
syn match namedLoggingChannelFileSuffixOpt /\(\(increment\)\|\(timestamp\)\)/
\ contained 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

hi link namedLoggingChannelFileOptSuffix namedHL_Option
syn match namedLoggingChannelFileOptSuffix contained /suffix/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileSuffixOpt,
\    namedEParenError

syn match namedLoggingChannelFileIdent contained 
\ /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/
\ contained
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileOptSuffix,
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

hi link namedLoggingChannelFileIdent namedHL_String
syn match namedLoggingChannelFileIdent contained 
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ contained
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileOptSuffix,
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

syn match namedLoggingChannelFileIdent contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ contained
\ skipwhite skipnl skipempty
\ contains=named_Filespec
\ nextgroup=
\    namedLoggingChannelFileOptSuffix,
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

" file <namedLoggingChannelOptFile> [ ... ];
hi link namedLoggingChannelOptFile namedHL_Option
syn match namedLoggingChannelOptFile /file/ contained 
\ skipwhite skipempty
\ nextgroup=
\    namedLoggingChannelFileIdent,
\    namedParenError

syn region namedLoggingChannelSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ contains=
\    namedLoggingChannelOpts,
\    namedLoggingChannelOptFile,
\    namedLoggingChannelOptPrintTime,
\    namedLoggingChannelOptSyslog,
\    namedLoggingChannelOptNull,
\    namedLoggingChannelOptSeverity,
\    namedComment,
\    namedInclude,
\    namedParenError
\ nextgroup=namedSemicolon

hi link namedLoggingChannelIdent namedHL_Identifier
syn match namedLoggingChannelIdent /\S\+/ contained skipwhite
\ nextgroup=namedLoggingChannelSection

hi link namedLoggingOptChannelKeyword namedHL_Option
syn match namedLoggingOptChannelKeyword contained skipwhite /channel/
\ nextgroup=namedLoggingChannelIdent,namedError
\ containedin=namedStmtLoggingSection

syn region namedStmtLoggingSection contained start=+{+ end=+}+ 
\ contains=
\    namedLoggingOptCategoryKeyword,
\    namedLoggingOptChannelKeyword,
\    namedComment,namedInclude,namedParenError
\ nextgroup=namedSemicolon
\ skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'managed-keys' statement
"
" managed-keys { string string integer integer integer quoted_string; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedMk_E_KeySecret namedKeySecretValue
syn match namedMk_E_KeySecret contained /["'0-9A-Za-z\+\=\/]\{1,4098}/ 
\ skipwhite skipempty
\ contains=namedKeySecretValue
\ nextgroup=namedSemicolon,namedNotSemicolon,namedError

hi link namedMk_E_AlgorithmType namedHL_Number
syn match namedMk_E_AlgorithmType contained skipwhite /\d\{1,3}/ skipempty
\ nextgroup=namedMk_E_KeySecret,namedError

hi link namedMk_E_ProtocolType namedHL_Number
syn match namedMk_E_ProtocolType contained skipwhite /\d\{1,3}/ skipempty
\ nextgroup=namedMk_E_AlgorithmType,namedError

hi link namedMk_E_FlagType namedHL_Number
syn match namedMk_E_FlagType contained skipwhite /\d\{1,3}/ skipempty
\ nextgroup=namedMk_E_ProtocolType,namedError

hi link namedMk_E_InitialKey namedHL_Number
syn match namedMk_E_InitialKey contained /[0-9A-Za-z][-0-9A-Za-z.]\{1,4096}/ 
\ skipwhite skipempty
\ contains=namedString
\ nextgroup=namedMk_E_FlagType,namedError

hi link namedMk_E_DomainName namedHL_Identifier
syn match namedMk_E_DomainName contained /[0-9A-Za-z][_\-0-9A-Za-z.]\{1,1024}/
\ skipwhite skipempty 
\ nextgroup=namedMk_E_InitialKey,namedError

syn region namedStmt_ManagedKeysSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ contains=namedMk_E_DomainName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" masters <masterIdentifier> { <masters_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedM_E_MasterKeyName namedHL_Identifier
syn match namedM_E_MasterKeyName contained /[a-zA-Z][0-9a-zA-Z\-_]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedM_E_KeyKeyword namedHL_Option
syn match namedM_E_KeyKeyword contained skipwhite /key/
\ nextgroup=
\    namedM_E_MasterKeyName,
\    namedError

hi link namedM_E_IPaddrPortNumber namedHL_Error
syn match namedM_E_IPaddrPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ contains=named_Port
\ nextgroup=
\    namedM_E_KeyKeyword,

hi link namedM_E_IPaddrPortKeyword namedHL_Option
syn match namedM_E_IPaddrPortKeyword contained skipwhite /port/
\ nextgroup=
\    namedM_E_IPaddrPortNumber,
\    namedError

hi link namedM_E_MasterName namedHL_Identifier
syn match namedM_E_MasterName contained skipwhite /[a-zA-Z][a-zA-Z0-9_\-]\+/
\ nextgroup=
\    namedM_E_KeyKeyword,
\    namedSemicolon,
\   namedComment, namedInclude,
\    namedError
\ containedin=namedStmtMastersSection

" hi link namedM_E_IP6addr namedHL_Number
syn match namedM_E_IP6addr contained skipwhite /[0-9a-fA-F:\.]\{6,48}/
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedStmtMastersSection

hi link namedM_E_IP4addr namedHL_Number
syn match namedM_E_IP4addr contained skipwhite 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedStmtMastersSection

syn region namedStmtMastersSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=namedComment
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

hi link namedM_Dscp_Number namedHL_Number
syn match namedM_Dscp_Number contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=namedM_Port,namedStmtMastersSection,namedSemicolon

hi link namedM_Port_Number namedHL_Number
syn match namedM_Port_Number contained skipwhite
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ nextgroup=namedM_Dscp,namedStmtMastersSection,namedSemicolon

hi link namedM_Port  namedHL_Option
syn match namedM_Port /port/ contained skipwhite
\ nextgroup=namedM_Port_Number

hi link namedM_Dscp  namedHL_Option
syn match namedM_Dscp /dscp/ contained skipwhite
\ nextgroup=namedM_Dscp_Number

syn match namedStmt_MastersNameIdentifier contained /\<[0-9a-zA-Z\-_\.]\{1,64}/
\ contains=namedMasterName
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedStmtMastersSection,
\    namedM_Port,
\    namedM_Dscp,
\    namedComment, namedInclude,
\    namedError

" End of Masters section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'options' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedO_Boolean_Group namedHL_Option
syn keyword namedO_Boolean_Group contained 
\     automatic-interface-scan 
\     answer-cookie
\     flush-zones-on-shutdown
\     match-mapped-addresses
\     memstatistics
\     querylog
\ nextgroup=@namedClusterBoolean_SC
\ skipwhite
\ containedin=namedStmt_OptionsSection

hi link namedO_UdpPorts namedHL_Option
syn keyword namedO_UdpPorts contained skipwhite
\    avoid-v4-udp-ports
\    avoid-v6-udp-ports
\ nextgroup=named_PortSection,namedInclude,namedComment,namedError
\ containedin=namedStmt_OptionsSection

hi link named_Hostname_SC namedHL_Builtin
syn keyword named_Hostname_SC contained skipwhite
\    hostname
\ nextgroup=namedSemicolon

hi link namedO_Domain namedHL_Option
syn keyword namedO_Domain contained skipwhite
\    server-id
\ nextgroup=
\    named_Builtin_None_SC,
\    named_Hostname_SC,
\    named_QuotedDomain_SC
\ containedin=
\    namedStmt_OptionsSection

hi link namedO_String_QuoteForced namedHL_Option
syn keyword namedO_String_QuoteForced contained skipwhite
\    bindkeys-file
\    cache-file
\    directory
\    dump-file
\    geoip-directory
\    managed-keys-directory
\    memstatistics-file
\    named-xfer
\    pid-file
\ nextgroup=named_String_QuoteForced_SC,namedNotString
\ containedin=namedStmt_OptionsSection

hi link namedO_AMLSection namedHL_Option
syn keyword namedO_AMLSection contained skipwhite
\    blackhole
\    listen-on
\ nextgroup=named_E_AMLSection_SC,namedInclude,namedComment
\ containedin=namedStmt_OptionsSection

hi link namedO_CheckNamesType namedHL_Builtin
syn match namedO_CheckNamesType contained /primary/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /secondary/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /response/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /master/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /slave/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC 

" not the same as 'check-names' in View or Zone
hi link namedO_CheckNames namedHL_Option
syn keyword namedO_CheckNames contained check-names skipwhite
\ nextgroup=namedO_CheckNamesType,namedError
\ containedin=namedStmt_OptionsSection

hi link namedO_CookieAlgorithmChoices namedHL_Type
syn match namedO_CookieAlgorithmChoices contained skipwhite
\ /\%(aes\)\|\%(sha256\)\|\%(sha1\)/
\ nextgroup=namedSemicolon,namedError

hi link namedO_CookieAlgs namedHL_Option
syn keyword namedO_CookieAlgs contained cookie-algorithm
\ skipwhite
\ nextgroup=namedO_CookieAlgorithmChoices
\ containedin=namedStmt_OptionsSection

hi link namedO_CookieSecretValue namedHL_Identifier
syn match namedO_CookieSecretValue contained 
\ /\c['"][0-9a-f]\{32}['"]/
\ contains=namedHexSecretValue
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedO_CookieSecretValue contained 
\ /\c['"][0-9a-f]\{20}['"]/
\ contains=namedHexSecretValue
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedO_CookieSecretValue contained 
\ /\c['"][0-9a-f]\{16}['"]/
\ contains=namedHexSecretValue
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_CookieSecret namedHL_Option
syn keyword namedO_CookieSecret contained cookie-secret
\ skipwhite
\ nextgroup=namedO_CookieSecretValue
\ containedin=namedStmt_OptionsSection

hi link named_NumberSize_SC namedHL_Number
syn match named_NumberSize_SC contained
\ /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/he=e-1
\ nextgroup=namedSemicolon

hi link namedO_DefaultUnlimitedSize namedHL_Option
syn keyword namedO_DefaultUnlimitedSize contained 
\     coresize
\     datasize
\     stacksize
\ skipwhite
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC
\ containedin=namedStmt_OptionsSection

hi link namedO_DnstapOutputSuffix namedHL_Builtin
syn keyword namedO_DnstapOutputSuffix contained 
\    increment
\    timestamp
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputSize namedHL_Number
syn match namedO_DnstapOutputSize contained /[0-9]\+/
\ skipwhite
\ nextgroup=namedSemicolon
    
hi link namedO_DnstapOutputSizeBuiltin namedHL_Builtin
syn keyword namedO_DnstapOutputSizeBuiltin contained 
\    unlimited
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputVersionBuiltin namedHL_Builtin
syn keyword namedO_DnstapOutputVersionBuiltin contained 
\    unlimited
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputVersion namedHL_Number
syn match namedO_DnstapOutputVersion contained /\d\+/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputKywdVersion namedHL_Option
syn keyword namedO_DnstapOutputKywdVersion contained version 
\ skipwhite
\ nextgroup=
\    namedO_DnstapOutputVersionBuiltin
\    namedO_DnstapOutputVersion
\ containedin=
\    namedO_DnstapOutputSection

hi link namedO_DnstapOutputKywdSize namedHL_Option
syn keyword namedO_DnstapOutputKywdSize contained size 
\ skipwhite
\ nextgroup=
\    namedO_DnstapOutputSizeBuiltin,
\    namedO_DnstapOutputSize
\ containedin=
\    namedO_DnstapOutputSection

hi link namedO_DnstapOutputKywdSuffix namedHL_Option
syn keyword namedO_DnstapOutputKywdSuffix contained suffix 
\ skipwhite
\ nextgroup=namedO_DnstapOutputSuffix
\ containedin=
\    namedO_DnstapOutputSection

syn region namedO_DnstapOutputSection contained start=/\zs\S\ze/ end=/;/me=e-1
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputFilespec namedHL_String
syn match namedO_DnstapOutputFilespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl  nextgroup=namedO_DnstapOutputSection
syn match namedO_DnstapOutputFilespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedO_DnstapOutputSection
syn match namedO_DnstapOutputFilespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedO_DnstapOutputSection

hi link namedO_DnstapOutputType namedHL_Type
syn keyword namedO_DnstapOutputType contained skipwhite
\    file
\    unix
\ nextgroup=namedO_DnstapOutputFilespec

hi link namedO_DnstapOutputKeyword namedHL_Option
syn keyword namedO_DnstapOutputKeyword contained dnstap-output skipwhite
\ nextgroup=namedO_DnstapOutputType,namedO_DnstapOutputFilespec
\ containedin=namedStmt_OptionsSection

hi link namedO_DnstapVersion namedHL_Option
syn keyword namedO_DnstapVersion contained
\    dnstap-version
\ skipwhite
\ nextgroup=
\    named_Builtin_None,
\    named_E_Filespec_SC
\ containedin=namedStmt_OptionsSection

hi link namedO_DscpNumber namedHL_Number
syn match namedO_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_Dscp namedHL_Option
syn keyword namedO_Dscp contained dscp skipwhite
\ nextgroup=namedO_DscpNumber
\ containedin=namedStmt_OptionsSection

hi link namedO_Fstrm_ModelValue namedHL_Builtin
syn keyword namedO_Fstrm_ModelValue contained
\    mpsc
\    spsc
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_Fstrm_Model namedHL_Option
syn keyword namedO_Fstrm_Model contained
\    fstrm-set-output-queue-model
\ skipwhite
\ nextgroup=namedO_Fstrm_ModelValue
\ containedin=namedStmt_OptionsSection

hi link namedO_InterfaceInterval namedHL_Option
syn keyword namedO_InterfaceInterval contained skipwhite
\    interface-interval
\ nextgroup=named_Number_Max28day_SC
\ containedin=namedStmt_OptionsSection

hi link namedO_Number_Group namedHL_Option
syn keyword namedO_Number_Group contained
\    fstrm-set-buffer-hint
\    fstrm-set-flush-timeout
\    fstrm-set-input-queue-size
\    fstrm-set-output-notify-threshold
\    fstrm-set-output-queue-size
\    fstrm-set-reopen-interval
\    max-cache-size
\    max-rsa-exponent-size
\    nocookie-udp-size
\    notify-rate
\    recursive-clients
\    reserved-sockets
\    serial-query-rate
\    stacksize
\    startup-notify-rate
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
\ skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedStmt_OptionsSection

hi link namedO_Ixfr_From_Diff_Opts namedHL_Builtin
syn keyword namedO_Ixfr_From_Diff_Opts contained
\    primary
\    master
\    secondary
\    slave
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_Ixfr_From_Diff namedHL_Option
syn keyword namedO_Ixfr_From_Diff contained ixfr-from-differences skipwhite
\ nextgroup=namedO_Ixfr_From_Diff_Opts
\ containedin=namedStmt_OptionsSection

hi link namedO_KeepResponseOrder namedHL_Option
syn keyword namedO_KeepResponseOrder contained keep-response-order skipwhite
\ nextgroup=named_E_AMLSection_SC
\ containedin=namedStmt_OptionsSection

hi link namedO_KeepResponseOrder namedHL_Option
syn keyword namedO_KeepResponseOrder contained skipwhite
\    recursing-file
\ nextgroup=named_E_Filespec_SC
\ containedin=namedStmt_OptionsSection

hi link namedO_Filespec_Quoted_None_Group namedHL_Option
syn keyword namedO_Filespec_Quoted_None_Group contained skipwhite
\    random-device
\ nextgroup=
\    named_E_Filespec_SC,
\    named_Builtin_None
\ containedin=namedStmt_OptionsSection


" syn keyword namedO_Keywords deallocate-on-exit
" syn keyword namedO_Keywords filter-aaaa
" syn keyword namedO_Keywords filter-aaaa-on-v4
" syn keyword namedO_Keywords filter-aaaa-on-v6
" syn keyword namedO_Keywords host-statistics
" syn keyword namedO_Keywords host-statistics-max
" syn keyword namedO_Keywords listen-on-v6
" syn keyword namedO_Keywords lock-file
" syn keyword namedO_Keywords max-cache-size
" syn keyword namedO_Keywords max-rsa-exponent-size
" syn keyword namedO_Keywords max-transfer-idle-in
" syn keyword namedO_Keywords max-transfer-idle-out
" syn keyword namedO_Keywords max-transfer-time-in
" syn keyword namedO_Keywords max-transfer-time-out
" syn keyword namedO_Keywords max-zone-ttl
" syn keyword namedO_Keywords min-roots
" syn keyword namedO_Keywords minimal-responses
" syn keyword namedO_Keywords multiple-cnames
" syn keyword namedO_Keywords mult-master
" syn keyword namedO_Keywords no-case-compress
" syn keyword namedO_Keywords nosit-udp-size
" syn keyword namedO_Keywords notify
" syn keyword namedO_Keywords notify-delay
" syn keyword namedO_Keywords notify-source
" syn keyword namedO_Keywords notify-source-v6
" syn keyword namedO_Keywords provide-ixfr
" syn keyword namedO_Keywords queryport-port-ports
" syn keyword namedO_Keywords queryport-port-updateinterval
" syn keyword namedO_Keywords querylog
" syn keyword namedO_Keywords random-device
" syn keyword namedO_Keywords rate-limit
" syn keyword namedO_Keywords recursing-file
" syn keyword namedO_Keywords request-nsid
" syn keyword namedO_Keywords request-sit
" syn keyword namedO_Keywords response-policy
" syn keyword namedO_Keywords rfc2308-type1
" syn keyword namedO_Keywords rrset-order
" syn keyword namedO_Keywords secroots-file
" syn keyword namedO_Keywords serial-query-rate
" syn keyword namedO_Keywords serial-update-method
" syn keyword namedO_Keywords session-keyfile
" syn keyword namedO_Keywords session-keyalg
" syn keyword namedO_Keywords session-keyname
" syn keyword namedO_Keywords sit-secret
" syn keyword namedO_Keywords sortlist
" syn keyword namedO_Keywords statistics-file
" syn keyword namedO_Keywords statistics-interval
" syn keyword namedO_Keywords support-ixfr
" syn keyword namedO_Keywords suppress-initial-notify
" syn keyword namedO_Keywords tcp-clients
" syn keyword namedO_Keywords tcp-listen-queue
" syn keyword namedO_Keywords tkey-dhkey
" syn keyword namedO_Keywords tkey-domain
" syn keyword namedO_Keywords tkey-gssapi-credential
" syn keyword namedO_Keywords tkey-gssapi-keytab
" syn keyword namedO_Keywords transfers
" syn keyword namedO_Keywords transfers-format
" syn keyword namedO_Keywords transfers-in
" syn keyword namedO_Keywords transfers-out
" syn keyword namedO_Keywords transfers-per-ns
" syn keyword namedO_Keywords transfers-source
" syn keyword namedO_Keywords transfers-source-v6
" syn keyword namedO_Keywords trusted-anchor-telemetry
" syn keyword namedO_Keywords use-v4-udp-ports
" syn keyword namedO_Keywords use-v6-udp-ports
" syn keyword namedO_Keywords version
" syn keyword namedO_Keywords zero-no-soa-ttl

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'server' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server-statement-specific syntaxes
hi link namedS_Bool_Group namedHL_Option
syn keyword namedS_Bool_Group contained
\   bogus
\   edns
\   provide-ixfr
\   request-nsid
\   tcp-keepalive
\   tcp-only
\ nextgroup=@namedClusterBoolean_SC
\ containedin=namedStmtServerSection skipwhite

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
\ containedin=namedStmtServerSection

hi link namedS_Keys_Id namedHL_String
syn match namedS_Keys_Id contained /[a-zA-Z0-9_\-]\{1,63}/ skipwhite
\ nextgroup=namedSemicolon

hi link namedS_Keys namedHL_Option
syn keyword namedS_Keys contained keys skipwhite
\ nextgroup=namedS_Keys_Id
\ containedin=namedStmtServerSection

" syn keyword namedStmtServerKeywords notify-source
" syn keyword namedStmtServerKeywords notify-source-v6
" syn keyword namedStmtServerKeywords request-sit
" syn keyword namedStmtServerKeywords support-ixfr


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'view' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" view statement - minute_type
hi link namedV_MinuteGroup namedHL_Statement
syn keyword namedV_MinuteGroup contained 
\    heartbeat-interval
\ nextgroup=namedTypeMinutes,namedComment,namedError
\ containedin=namedStmt_ViewSection skipwhite

" List of Port numbers

" view statement - 'check_options': warn/fail/ignore operators
" view statement - Filespec (directory, filename)
hi link namedV_FilespecGroup namedHL_Option
syn keyword namedV_FilespecGroup contained
\    cache-file
\    managed-keys-directory
\    nextgroup=named_String_QuoteForced,namedNotString
\    containedin=namedStmt_ViewSection skipwhite

" view statement - SizeSpec options
hi link namedV_SizeSpec_Group namedHL_Statement
syn keyword namedV_SizeSpec_Group contained 
\    max-cache-size
\ nextgroup=named_SizeSpec,namedComment,namedError
\ containedin=namedStmt_ViewSection skipwhite


" view statement - AML
syn keyword namedV_Keywords contained skipwhite
\    match-clients
\    match-destinations
\ nextgroup=named_E_AMLSection_SC,namedError
\ containedin=namedStmt_ViewSection

" TODO: Old days, keys ere defined inside views
" I can't remember if keyname or key section came first
hi link namedV_Key namedHL_Option
syn  keyword namedV_Key  contained key skipwhite
\ nextgroup=namedStmtKeyIdent,namedStmtKeySection
\ containedin=namedStmt_ViewSection

hi link namedV_Boolean_Group namedHL_Option
syn  keyword namedV_Boolean_Group  contained skipwhite
\    match-recursive-only
\ nextgroup=@namedClusterBoolean
\ containedin=namedStmt_ViewSection



" syn keyword namedV_Keywords class
" syn keyword namedV_Keywords filter-aaaa
" syn keyword namedV_Keywords filter-aaaa-on-v4
" syn keyword namedV_Keywords filter-aaaa-on-v6
" syn keyword namedV_Keywords match-clients
" syn keyword namedV_Keywords match-destination
" syn keyword namedV_Keywords max-transfer-idle-in
" syn keyword namedV_Keywords max-transfer-idle-out
" syn keyword namedV_Keywords max-transfer-time-in
" syn keyword namedV_Keywords max-transfer-time-out
" syn keyword namedV_Keywords max-zone-ttl
" syn keyword namedV_Keywords min-roots
" syn keyword namedV_Keywords minimal-responses
" syn keyword namedV_Keywords multiple-cnames
" syn keyword namedV_Keywords mult-master
" syn keyword namedV_Keywords no-case-compress
" syn keyword namedV_Keywords nosit-udp-size
" syn keyword namedV_Keywords notify
" syn keyword namedV_Keywords notify-delay
" syn keyword namedV_Keywords notify-source
" syn keyword namedV_Keywords notify-source-v6
" syn keyword namedV_Keywords provide-ixfr
" syn keyword namedV_Keywords queryport-port-ports
" syn keyword namedV_Keywords queryport-port-updateinterval
" syn keyword namedV_Keywords rate-limit
" syn keyword namedV_Keywords request-nsid
" syn keyword namedV_Keywords request-sit
" syn keyword namedV_Keywords response-policy
" syn keyword namedV_Keywords rfc2308-type1
" syn keyword namedV_Keywords serial-update-method
" syn keyword namedV_Keywords session-keyname
" syn keyword namedV_Keywords sortlist
" syn keyword namedV_Keywords support-ixfr
" syn keyword namedV_Keywords suppress-initial-notify
" syn keyword namedV_Keywords transfers
" syn keyword namedV_Keywords transfers-format
" syn keyword namedV_Keywords transfers-source
" syn keyword namedV_Keywords transfers-source-v6
" syn keyword namedV_Keywords zero-no-soa-ttl

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'zone' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedZ_Boolean_Group namedHL_Option
syn keyword namedZ_Boolean_Group contained skipwhite
\    delegation-only
\ nextgroup=@namedClusterBoolean_SC
\ containedin=namedStmtZoneSection

hi link namedZ_File namedHL_Option
syn keyword namedZ_File contained file skipwhite
\ nextgroup=named_String_QuoteForced
\ containedin=namedStmtZoneSection

hi link namedZ_InView namedHL_Option
syn keyword namedZ_InView contained in-view skipwhite
\ nextgroup=named_E_ViewName_SC
\ containedin=namedStmtZoneSection

hi link namedZ_Filespec_Group namedHL_Option
syn keyword namedZ_Filespec_Group contained journal skipwhite
\ nextgroup=named_E_Filespec_SC
\ containedin=namedStmtZoneSection

hi link namedZ_Masters namedHL_Option
syn keyword namedZ_Masters contained masters skipwhite
\ nextgroup=
\    namedStmtMastersSection,
\    namedM_Port,
\    namedM_Dscp,
\    namedComment, namedInclude,
\    namedError
\ containedin=namedStmtZoneSection

hi link namedZ_DefaultUnlimitedSize_Group namedHL_Option
syn match namedZ_DefaultUnlimitedSize_Group contained /max-journal-size/
\ skipwhite
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

" syn keyword namedStmtZoneKeywords class
" syn keyword namedStmtZoneKeywords client-per-query
" syn keyword namedStmtZoneKeywords database
" syn keyword namedStmtZoneKeywords inline-signing
" syn keyword namedStmtZoneKeywords max-transfer-idle-in
" syn keyword namedStmtZoneKeywords max-transfer-idle-out
" syn keyword namedStmtZoneKeywords max-transfer-time-in
" syn keyword namedStmtZoneKeywords max-transfer-time-out
" syn keyword namedStmtZoneKeywords max-zone-ttl
" syn keyword namedStmtZoneKeywords mult-master
" syn keyword namedStmtZoneKeywords notify
" syn keyword namedStmtZoneKeywords notify-delay
" syn keyword namedStmtZoneKeywords notify-source
" syn keyword namedStmtZoneKeywords notify-source-v6
" syn keyword namedStmtZoneKeywords rrset-order
" syn keyword namedStmtZoneKeywords serial-update-method
" syn keyword namedStmtZoneKeywords server-addresses
" syn keyword namedStmtZoneKeywords server-names
" syn keyword namedStmtZoneKeywords session-keyname
" syn keyword namedStmtZoneKeywords transfers-source
" syn keyword namedStmtZoneKeywords transfers-source-v6
" syn keyword namedStmtZoneKeywords type
" syn keyword namedStmtZoneKeywords update-policy
" syn keyword namedStmtZoneKeywords zero-no-soa-ttl

" syn keyword namedO_KeywordsObsoleted acache-cleaning-interval
" syn keyword namedO_KeywordsObsoleted acache-enable
" syn keyword namedO_KeywordsObsoleted additional-from-auth
" syn keyword namedO_KeywordsObsoleted additional-from-cache
" syn keyword namedO_KeywordsObsoleted alt-transfer-source
" syn keyword namedO_KeywordsObsoleted alt-transfer-source-v6
" syn keyword namedO_KeywordsObsoleted fake-iquery
" syn keyword namedO_KeywordsObsoleted fetch-glue
" syn keyword namedO_KeywordsObsoleted has-old-clients
" syn keyword namedO_KeywordsObsoleted maintain-ixfr-base
" syn keyword namedO_KeywordsObsoleted max-acache-size
" syn keyword namedO_KeywordsObsoleted named-xfer
" syn keyword namedO_KeywordsObsoleted serial-queries
" syn keyword namedO_KeywordsObsoleted treat-cr-as-space
" syn keyword namedO_KeywordsObsoleted use-ixfr
" syn keyword namedO_KeywordsObsoleted use-queryport-pool
" syn keyword namedO_KeywordsObsoleted use-queryport-updateinterval

" syn keyword namedStmtServerKeywordsObsoleted edns-udp-size
" syn keyword namedStmtServerKeywordsObsoleted keys
" syn keyword namedStmtServerKeywordsObsoleted provide-ixfr
" syn keyword namedStmtServerKeywordsObsoleted transfers
" syn keyword namedStmtServerKeywordsObsoleted transfers-format
" syn keyword namedStmtServerKeywordsObsoleted transfers-source
" syn keyword namedStmtServerKeywordsObsoleted transfers-source-v6

" syn keyword namedV_KeywordsObsoleted alt-transfer-source
" syn keyword namedV_KeywordsObsoleted alt-transfer-source-v6
" syn keyword namedV_KeywordsObsoleted fetch-glue
" syn keyword namedV_KeywordsObsoleted maintain-ixfr-base
" syn keyword namedV_KeywordsObsoleted max-acache-size
" syn keyword namedV_KeywordsObsoleted use-queryport-pool
" syn keyword namedV_KeywordsObsoleted use-queryport-updateinterval

" syn keyword namedStmtZoneKeywordsObsoleted alt-transfer-source
" syn keyword namedStmtZoneKeywordsObsoleted alt-transfer-source-v6
" syn keyword namedStmtZoneKeywordsObsoleted ixfr-base
" syn keyword namedStmtZoneKeywordsObsoleted maintain-ixfr-base
" syn keyword namedStmtZoneKeywordsObsoleted pubkey
" syn keyword namedStmtZoneKeywordsObsoleted use-id-pool

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOSV_UdpSize namedHL_Option
syn keyword namedOSV_UdpSize contained skipwhite
\    edns-udp-size
\    max-udp-size
\ nextgroup=named_Number_UdpSize
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmtServerSection,
\    namedStmt_ViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOV_SizeSpec_Group namedHL_Option
syn keyword namedOV_SizeSpec_Group contained skipwhite
\    lmdb-mapsize
\ nextgroup=named_SizeSpec
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmtOptionsView

hi link namedOV_DefaultUnlimitedSize_Group namedHL_Option
syn keyword namedOV_DefaultUnlimitedSize_Group contained skipwhite
\    max-cache-size
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" <0-30000> millisecond
hi link namedOV_Interval_Max30ms_Group namedHL_Option
syn keyword namedOV_Interval_Max30ms_Group contained skipwhite
\    resolver-query-timeout
\    resolver-retry-interval
\ nextgroup=named_Interval_Max30ms_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_Ttl_Group namedHL_Option
syn keyword namedOV_Ttl_Group contained skipwhite
\    lame-ttl
\    servfail-ttl
\ nextgroup=named_Ttl_Max30min_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_Ttl90sec_Group namedHL_Option
syn keyword namedOV_Ttl90sec_Group contained skipwhite
\    min-cache-ttl
\    min-ncache-ttl
\ nextgroup=named_Ttl_Max90sec_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_Ttl_Max3h_Group namedHL_Option
syn keyword namedOV_Ttl_Max3h_Group contained skipwhite
\    max-ncache-ttl
\ nextgroup=named_Ttl_Max3hour_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_Ttl_Max1week_Group namedHL_Option
syn keyword namedOV_Ttl_Max1week_Group contained skipwhite
\    nta-lifetime
\    nta-recheck
\    max-cache-ttl
\ nextgroup=named_Ttl_Max1week_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" view statement - hostname [ none | <domain_name> ];
hi link named_Builtin_None_SC namedHL_Builtin
syn match named_Builtin_None_SC contained /none/ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_Hostname namedHL_Option
syn keyword namedOV_Hostname contained hostname skipwhite
\ nextgroup=
\    named_Builtin_None_SC,
\    named_QuotedDomain_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_DnssecLookasideOptKeyname namedHL_String
syn match namedOV_DnssecLookasideOptKeyname contained 
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOV_DnssecLookasideOptTD namedHL_Clause
syn keyword namedOV_DnssecLookasideOptTD contained trust-anchor
\ nextgroup=namedOV_DnssecLookasideOptKeyname
\ skipwhite

hi link namedOV_DnssecLookasideOptDomain namedHL_String
syn match namedOV_DnssecLookasideOptDomain contained 
\    /[0-9A-Za-z][-0-9A-Za-z\.\-_]\+/ 
\ nextgroup=namedOV_DnssecLookasideOptTD
\ skipwhite

hi link namedOV_DnssecLookasideOptAuto namedHL_Error
syn keyword namedOV_DnssecLookasideOptAuto contained auto
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_DnssecLookasideOpt namedHL_Type
syn keyword namedOV_DnssecLookasideOpt contained no
\ skipwhite
\ nextgroup=namedSemicolon

" dnssec-lookaside [ auto | no | <domain_name> trusted-anchor <key_name>];
hi link namedOV_DnssecLookasideKeyword namedHL_Option
syn keyword namedOV_DnssecLookasideKeyword contained
\    dnssec-lookaside
\ skipwhite
\ nextgroup=
\    namedOV_DnssecLookasideOpt,
\    namedOV_DnssecLookasideOptDomain,
\    namedOV_DnssecLookasideOptAuto
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection 

hi link namedOV_Boolean_Group namedHL_Option
syn keyword namedOV_Boolean_Group contained
\    allow-new-zones
\    auth-nxdomain 
\    dnsrps-enable
\    dnssec-accept-expired
\    dnssec-enable
\    empty-zone-enable
\    fetch-glue
\    glue-cache
\    message-compression
\    minimal-any
\    recursion
\    require-server-cookie
\    root-key-sentinel
\    stale-answer-enable
\    synth-from-dnssec
\    trust-anchor-telemetry
\ nextgroup=@namedClusterBoolean_SC
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection 

hi link namedOV_Filespec namedHL_Option
syn keyword namedOV_Filespec contained
\    new-zones-directory
\ skipwhite
\ nextgroup=named_E_Filespec_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_AML_Group namedHL_Option
syn keyword namedOV_AML_Group contained
\    allow-query-cache
\    allow-query-cache-on
\    allow-recursion
\    allow-recursion-on
\ skipwhite
\ nextgroup=named_E_AMLSection_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_AttachCache namedHL_Option
syn keyword namedOV_AttachCache contained attach-cache skipwhite
\ nextgroup=named_E_ViewName_SC,namedError
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_Number_Group namedHL_Option
syn keyword namedOV_Number_Group contained
\    clients-per-query 
\    max-clients-per-query 
\    resolver-nonbackoff-tries
\    max-recursion-depth
\    max-recursion-queries
\    max-stale-ttl
\    stale-answer-ttl
\    v6-bias
\    zero-no-soa-ttl-cache
\ skipwhite
\ nextgroup=named_Number_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_DnsrpsElement namedHL_String
syn region namedOV_DnsrpsElement start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOV_DnsrpsOptionsSection

syn region namedOV_DnsrpsElement start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOV_DnsrpsOptionsSection

syn region namedOV_DnsrpsOptionsSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

hi link namedStmtOptionsViewDnsrpsOptions namedHL_Option
syn keyword namedStmtOptionsViewDnsrpsOptions contained
\    dnsrps-options
\ skipwhite
\ nextgroup=namedOV_DnsrpsOptionsSection
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

syn match namedOV_DenyAnswerElementDomainName /['"][_\-0-9A-Za-z\.]\{1,1024}['"]/
\ contained skipwhite skipempty 
\ contains=namedDomain
\ nextgroup=namedSemicolon

" deny-answer-addresses { <AML>; } [ except from { <domain_name>; }; } ];
syn region namedOV_DenyAnswerExceptSection contained start=/{/ end=/}/
\ skipwhite skipempty
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

" deny-answer-addresses { <AML>; } [ except from { ... }; } ];
hi link namedOV_DenyAnswerExceptKeyword namedHL_Option
syn match namedOV_DenyAnswerExceptKeyword contained
\    /\(except\)\s\+\(from\)/
\ skipwhite
\ nextgroup=
\    namedOV_DenyAnswerExceptSection,
\    namedSemicolon
 
" deny-answer-addresses { <AML>; } ...
syn region namedOV_DenyAnswerAddrSection contained start=/{/ end=/}/
\ skipwhite skipempty
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
\    namedSemicolon

" deny-answer-addresses { } ...
hi link namedStmtOptionsViewDenyAnswerAddrKeyword namedHL_Option
syn keyword namedStmtOptionsViewDenyAnswerAddrKeyword contained 
\    deny-answer-addresses
\ skipwhite
\ nextgroup=namedOV_DenyAnswerAddrSection
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" deny-answer-aliases { <AML>; } ...
syn region namedOV_DenyAnswerAliasSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=
\    named_E_ACLName_SC,
\    namedOV_DenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedOV_DenyAnswerExceptKeyword,
\    namedSemicolon

" deny-answer-aliases { } ...
hi link namedStmtOptionsViewDenyAnswerAliasKeyword namedHL_Option
syn keyword namedStmtOptionsViewDenyAnswerAliasKeyword contained 
\    deny-answer-aliases
\ skipwhite
\ nextgroup=namedOV_DenyAnswerAliasSection
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" disable-algorithms <name> { <algo_name>; ... };
hi link namedOV_DisableAlgosElementName namedHL_String
syn match namedOV_DisableAlgosElementName contained 
\   /['"]\?[a-zA-Z0-9\.\-_]\{1,64}['"]\?/
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOV_DisableAlgosSection

" disable-algorithms <name> { ...; };
syn region namedOV_DisableAlgosSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon

" disable-algorithms <name> { ... };
hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /[a-zA-Z0-9\.\-_]\{1,64}/
\ skipwhite
\ nextgroup=namedOV_DisableAlgosSection

hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /"[a-zA-Z0-9\.\-_]\{1,64}"/
\ skipwhite
\ nextgroup=namedOV_DisableAlgosSection

hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /'[a-zA-Z0-9\.\-_]\{1,64}'/
\ skipwhite
\ nextgroup=namedOV_DisableAlgosSection

" disable-algorithms <name> ...
hi link namedStmtOptionsViewDisableAlgosKeyword namedHL_Option
syn keyword namedStmtOptionsViewDisableAlgosKeyword contained 
\    disable-algorithms
\ skipwhite skipempty
\ nextgroup=namedOV_DisableAlgosIdent
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" disable-ds-digests <name> ...
hi link namedStmtOptionsViewDisableDsDigestKywd namedHL_Option
syn keyword namedStmtOptionsViewDisableDsDigestKywd contained 
\    disable-ds-digests
\ skipwhite skipempty
\ nextgroup=namedOV_DisableAlgosIdent
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedStmtOptionsViewDisEmptyZone namedHL_Option
syn keyword namedStmtOptionsViewDisEmptyZone contained 
\    disable-empty-zone 
\ nextgroup=namedElementZoneName,namedError
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_Dns64Element namedHL_Option
" dns64 <netprefix> { break-dnssec <boolean>; };
syn keyword namedOV_Dns64Element contained 
\    break-dnssec
\    recursive-only
\ skipwhite
\ nextgroup=@namedClusterBoolean


" dns64 <netprefix> { clients { xxx; }; };
syn region namedOV_Dns64ClientsSection contained start=+{+ end=+}+
\ skipwhite
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedInclude,
\    namedComment 
\ nextgroup=namedSemicolon

" dns64 <netprefix> { suffix <ip_addr>; };
syn keyword namedOV_Dns64Element contained suffix
\ skipwhite
\ nextgroup=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC

" dns64 <netprefix> { break-dnssec <bool>; };
syn match namedOV_Dns64Element contained 
\    /\(break-dnssec\)\|\(recursive-only\)/
\ skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

" dns64 <netprefix> { mapped { ... }; };
syn keyword namedOV_Dns64Element contained 
\    clients
\    exclude
\    mapped
\ skipwhite
\ nextgroup=namedOV_Dns64ClientsSection

" dns64 <netprefix> { <AML>; };
syn region namedOV_Dns64Section contained start=+{+ end=+}+
\ skipwhite skipempty
\ contains=namedOV_Dns64Element
\ nextgroup=namedSemicolon

" dns64 <netprefix> { 
hi link namedOV_Dns64Ident namedError
syn match namedOV_Dns64Ident contained /[0-9a-fA-F:%\.\/]\{7,48}/
\ contained skipwhite skipempty
\ contains=named_IP4AddrPrefix,named_IP6AddrPrefix
\ nextgroup=namedOV_Dns64Section

" dns64 <netprefix> 
hi link namedStmtOptionsViewDns64 namedHL_Option
syn keyword namedStmtOptionsViewDns64 contained dns64
\ nextgroup=namedOV_Dns64Ident,namedError skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" dns64-contact <string>
" dns64-server <string>
hi link namedStmtOptionsViewDns64Contact namedHL_Option
syn keyword namedStmtOptionsViewDns64Contact contained 
\    dns64-contact
\    dns64-server
\    empty-server
\    empty-contact
\ nextgroup=named_QuotedDomain_SC,namedError
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link named_Auto_SC namedHL_Builtin
syn match named_Auto_SC contained /auto/ skipwhite
\ nextgroup=namedSemicolon

" dnssec-validation [ yes | no | auto ];
hi link namedOV_DnssecValidation namedHL_Option
syn keyword namedOV_DnssecValidation contained 
\    dnssec-validation
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC,named_Auto_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" dnstap { ... };
hi link namedOV_DnstapClauses namedHL_Builtin
syn keyword namedOV_DnstapClauses contained
\    query
\    response
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOV_DnstapOpts namedHL_Builtin
syn keyword namedOV_DnstapOpts contained 
\    all 
\    auth
\    client
\    forwarder
\    resolver
\    update
\ skipwhite
\ nextgroup=namedOV_DnstapClauses

syn region namedOV_DnstapSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ nextgroup=namedSemicolon
\ contains=namedOV_DnstapOpts

hi link namedOV_DnstapKeyword namedHL_Option
syn keyword namedOV_DnstapKeyword contained 
\    dnstap
\ skipwhite
\ nextgroup=namedOV_DnstapSection
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

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
\ nextgroup=namedOV_FetchQuotaParamsRecalPerQueries
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

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
\ nextgroup=namedOV_FetchQuotaPersType

hi link namedOV_FetchPers namedHL_Option
syn keyword namedOV_FetchPers contained 
\    fetches-per-server
\    fetches-per-zone
\ skipwhite
\ nextgroup=namedOV_FetchQuotaPersValue
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" heartbeat-interval: range: 0-40320
hi link named_Number_Max28day_SC namedHL_Number
syn match named_Number_Max28day_SC contained
\ /\%(40320\)\|\%(403[0-1][0-9]\)\|\%(40[0-2][0-9][0-9]\)\|\%([1-3][0-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9]\)\|\%([1-9][0-9]\)\|\%([0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_HeartbeatInterval namedHL_Option
syn keyword namedOV_HeartbeatInterval contained
\    heartbeat-interval
\ skipwhite
\ nextgroup=named_Number_Max28day_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

"  dual-stack-servers [ port <pg_num> ] 
"                     { ( <domain_name> [port <p_num>] |
"                         <ipv4> [port <p_num>] | 
"                         <ipv6> [port <p_num>] ); ... };
"  /.\+/
"  /\is*;/
hi link namedOV_DualStack_E_Port	namedKeyword
syn match namedOV_DualStack_E_Port /port/
\ contained skipwhite
\ nextgroup=named_Port,namedWildcard
syn match namedDSS_Element_DomainAddrPort 
\ /\<[0-9A-Za-z\._\-]\+\>/ 
\ contained skipwhite
\ contains=namedDomain
\ nextgroup=namedOV_DualStack_E_Port,namedSemicolon,namedError

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
\ skipwhite
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
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

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

hi link namedOV_CZ_Filespec	namedHL_String
syn match namedOV_CZ_Filespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match namedOV_CZ_Filespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match namedOV_CZ_Filespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl

hi link  namedOV_CZ_ZoneDir namedHL_Clause
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

hi link  namedOV_CZ_MinUpdate namedHL_Clause
syn keyword namedOV_CZ_MinUpdate contained min-update-interval skipwhite
\ nextgroup=namedOV_CZ_MinUpdate_Interval
\ containedin=namedOV_CatalogZones_Section

hi link namedOV_CZ_InMemory_Boolean	namedHL_Type
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

hi link  namedOV_CZ_InMemory namedHL_Clause
syn keyword namedOV_CZ_InMemory contained in-memory skipwhite
\ nextgroup=namedOV_CZ_InMemory_Boolean
\ containedin=namedOV_CatalogZones_Section

syn region namedOV_CZ_DefMasters_MML contained start=+{+ end=+}+ skipwhite skipempty
\ nextgroup=
\    namedOV_CZ_InMemory,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
\ contains=
\    namedInclude,
\    namedComment 

hi link  namedOV_CZ_DefMasters namedHL_Clause
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

hi link namedOV_CZ_Zone namedHL_Clause
syn keyword namedOV_CZ_Zone contained zone skipwhite
\ nextgroup=namedOV_CZ_QuotedDomain
\ containedin=namedOV_CatalogZones_Section

syn region namedOV_CatalogZones_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOV_CatalogZones namedHL_Option
syn keyword namedOV_CatalogZones contained catalog-zones skipwhite
\ nextgroup=namedOV_CatalogZones_Section
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_QnameMin namedHL_Option
syn keyword namedOV_QnameMin contained qname-minimization skipwhite
\ nextgroup=named_StrictRelaxedDisabledOff
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_MinResponse_Opts namedHL_Builtin
syn keyword namedOV_MinResponse_Opts contained skipwhite
\    no-auth
\    no-auth-recursive
\ nextgroup=namedSemicolon

hi link namedOV_MinResponse namedHL_Option
syn keyword namedOV_MinResponse contained skipwhite
\    minimal-responses
\ nextgroup=namedOV_MinResponse_Opts,@namedClusterBoolean
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_NxdomainRedirect namedHL_Option
syn keyword namedOV_NxdomainRedirect contained skipwhite
\    nxdomain-redirect
\ nextgroup=named_E_Domain_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_RootDelegation_Domain namedHLDomain
syn match namedOV_RootDelegation_Domain contained /\<[0-9A-Za-z\._\-]\+\>/
\ nextgroup=namedSemicolon
\ containedin=namedOV_RootDelegation_Section

syn region namedOV_RootDelegation_Section contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon

hi link namedOV_RootDelegation_Opts namedHL_Clause
syn match namedOV_RootDelegation_Opts contained /exclude/ skipwhite
\ nextgroup=namedOV_RootDelegation_Section

hi link namedOV_RootDelegation namedHL_Option
syn keyword namedOV_RootDelegation contained skipwhite
\    root-delegation-only
\ nextgroup=
\    namedOV_RootDelegation_Opts
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_AorAAAA_SC namedHL_String
" syn match namedOV_AorAAAA_SC contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match namedOV_AorAAAA_SC /\ca/ contained skipwhite nextgroup=namedSemicolon
syn match namedOV_AorAAAA_SC /\caaaa/ contained skipwhite nextgroup=namedSemicolon

hi link namedOV_AorAAAA namedHL_Option
syn keyword namedOV_AorAAAA contained skipwhite
\    preferred-glue
\ nextgroup=namedOV_AorAAAA_SC 
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

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
\ nextgroup=namedOV_First_Number_Max10sec
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

hi link namedOV_QuerySource namedHL_Option
syn keyword namedOV_QuerySource contained skipwhite
\    query-source
\    query-source-v6
\ nextgroup=named_E_AMLSection_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

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
" \    namedStmtZoneSection

syn match namedOZ_DialupOptBoolean contained /\S\+/
\ skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

hi link namedOZ_DialupOptBuiltin namedHL_Builtin
syn match namedOZ_DialupOptBuiltin contained 
\     /\%(notify\)\|\%(notify-passive\)\|\%(passive\)\|\%(refresh\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOZ_Dialup namedHL_Option
syn keyword namedOZ_Dialup contained dialup
\ skipwhite
\ nextgroup=
\    namedOZ_DialupOptBuiltin,
\    namedOZ_DialupOptBoolean
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

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
\ containedin=
\    namedStmt_OptionsSection

hi link namedOZ_Files_Wildcard namedHL_Builtin
syn match namedOZ_Files_Wildcard /\*/ contained skipwhite

hi link namedOZ_Files namedHL_Option
syn keyword namedOZ_Files contained files skipwhite
\ nextgroup=
\    namedOZ_Files_Wildcard,
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmtZoneSection

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

hi link namedOVZ_Number_Group namedHL_Option
syn keyword namedOVZ_Number_Group contained skipwhite
\    max-records
\    notify-delay
\    sig-signing-nodes
\    sig-signing-signatures
\    sig-signing-type
\ nextgroup=named_Number_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOVZ_Boolean_Group namedHL_Option
syn keyword namedOVZ_Boolean_Group contained 
\    check-sibling
\    check-integrity
\    check-wildcard
\    dnssec-dnskey-kskonly
\    dnssec-secure-to-insecure
\    inline-signing
\    multi-master
\    notify-to-soa
\    try-tcp-refresh
\    update-check-ksk
\    use-alt-transfer-source
\    zero-no-soa-ttl
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC
\ containedin=
\    namedStmt_ViewSection,
\    namedStmt_OptionsSection,
\    namedStmtZoneSection

hi link namedOVZ_AML_Group namedHL_Option
syn keyword namedOVZ_AML_Group contained skipwhite
\    allow-notify
\    allow-query
\    allow-query-on
\    allow-transfer
\    allow-update
\    allow-update-forwarding
\ nextgroup=named_E_AMLSection_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOVZ_Number_Max28days namedHL_Option
syn keyword namedOVZ_Number_Max28days contained skipwhite
\    max-transfer-idle-in
\    max-transfer-idle-out
\    max-transfer-time-in
\    max-transfer-time-out
\ nextgroup=named_Number_Max28day_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOptATSClauseDscp  namedHL_Clause
syn match namedOptATS_DSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ contains=namedDSCP skipwhite
\ nextgroup=namedOptATSClausePort,namedSemicolon

hi link namedOptATS_PortWild namedHL_Number
syn match namedOptATS_PortWild contained /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=namedOptATSClauseDscp,namedSemicolon

hi link namedOptATSClausePort  namedHL_Clause
syn keyword namedOptATSClausePort port contained 
\ nextgroup=namedOptATS_PortWild skipwhite
\ containedin=namedOptATS_IPwild
syn match namedOptATSClauseDscp /dscp/ contained 
\ nextgroup=namedOptATS_DSCP skipwhite
\ containedin=namedOptATS_IPwild
syn match namedOptATSClauses /port/ contained 
\ nextgroup=namedOptATS_Port skipwhite
\ containedin=namedOptATS_IPwild
syn match namedOptATSClauses /dscp/ contained 
\ nextgroup=namedOptATS_DSCP skipwhite
\ containedin=namedOptATS_IPwild

hi link namedOptATS_IP4wild namedHLKeyword
hi link namedOptATS_IP6wild namedHLKeyword
syn match namedOptATS_IP4wild /\S\+/ contained
\ contains=namedIPwild,named_IP4Addr
\ nextgroup=
\    namedOptATSClausePort,
\    namedOptATSClauseDscp,
\    namedSemicolon
\ skipwhite

syn match namedOptATS_IP6wild /\S\+/ contained
\ contains=namedIPwild,named_IP6Addr
\ nextgroup=
\    namedOptATSClausePort,
\    namedOptATSClauseDscp,
\    namedSemicolon
\ skipwhite

hi link namedOVZ_OptATS namedHL_Option
syn keyword namedOVZ_OptATS contained
\    alt-transfer-source-v6
\ nextgroup=namedOptATS_IP6wild skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection
syn keyword namedOVZ_OptATS contained
\    alt-transfer-source
\ nextgroup=namedOptATS_IP4wild skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOVZ_AutoDNSSEC namedHL_Option
syn keyword namedOVZ_AutoDNSSEC contained auto-dnssec skipwhite
\ nextgroup=named_AllowMaintainOff_SC,namedComment,namedError 
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection 

hi link namedStmtOVZ_IgnoreWarnFail namedHL_Option
syn keyword namedStmtOVZ_IgnoreWarnFail contained 
\    check-dup-records
\    check-mx-cname
\    check-mx
\    check-srv-cnames
\    check-spf
\ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection,

" <0-3660> days (dnskey-sig-validity)
hi link named_Number_Max3660days namedHL_Number
syn match named_Number_Max3660days contained skipwhite
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ nextgroup=namedSemicolon

hi link namedStmtOVZ_DnskeyValidity namedHL_Option
syn keyword namedStmtOVZ_DnskeyValidity contained skipwhite
\    dnskey-sig-validity
\ nextgroup=named_Number_Max3660days
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection 

" <0-1440> (dnssec-loadkeys-interval)
hi link namedOVZ_DnssecLoadkeysInterval namedHL_Number
syn match namedOVZ_DnssecLoadkeysInterval contained 
\ /\%(1440\)\|\%(14[0-3][0-9]\)\|\%(1[0-3][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedStmtOVZ_DnssecLoadkeys namedHL_Option
syn keyword namedStmtOVZ_DnssecLoadkeys contained 
\    dnssec-loadkeys-interval
\ skipwhite
\ nextgroup=namedOVZ_DnssecLoadkeysInterval
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection 

" cleaning-interval: range: 0-1440
hi link namedOVZ_CleaningValue namedHL_Number
syn match namedOVZ_CleaningValue contained
\    /\(1440\)\|\(14[0-3][0-9]\)\|\([1[0-3][0-9][0-9]\)\|\([0-9][0-9][0-9]\)\|\([0-9][0-9]\)\|\([0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedStmtOVZ_Cleaning namedHL_Option
syn keyword namedStmtOVZ_Cleaning contained
\    cleaning-interval
\ nextgroup=namedOVZ_CleaningValue
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

" dnssec-must-be-secure <domain_name> <boolean>; [ Opt View ]  # v9.3.0+
syn match namedDMBS_FQDN contained /\<[0-9A-Za-z\.\-_]\{1,1023}\>/
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite
syn match namedDMBS_FQDN contained /'[0-9A-Za-z\.\-_]\{1,1023}'/
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite
syn match namedDMBS_FQDN contained /"[0-9A-Za-z\.\-_]\{1,1023}"/
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite

hi link namedStmtOptionsViewDnssecMustBeSecure namedHL_Option
syn keyword namedStmtOptionsViewDnssecMustBeSecure contained 
\    dnssec-must-be-secure 
\ nextgroup=namedDMBS_FQDN
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection  " only if its zone is inside 'view'

hi link namedOVZ_DnssecUpdateModeOpt namedHL_Builtin
syn keyword namedOVZ_DnssecUpdateModeOpt contained
\   maintain
\   no-resign
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_DnssecUpdateMode namedHL_Option
syn keyword namedOVZ_DnssecUpdateMode contained
\    dnssec-update-mode
\ nextgroup=namedOVZ_DnssecUpdateModeOpt
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOVZ_ForwardOpt namedHL_Builtin
syn keyword namedOVZ_ForwardOpt contained
\    only
\    first
\ nextgroup=namedSemicolon

hi link namedOVZ_Forward namedHL_Option
syn keyword namedOVZ_Forward contained forward
\ skipwhite
\ nextgroup=namedOVZ_ForwardOpt
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection
" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx

hi link namedOVZ_Forwarders_Opt_PortNumber namedHL_Error
syn match namedOVZ_Forwarders_Opt_PortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ contains=named_Port
\ nextgroup=namedSemicolon

hi link namedOVZ_Forwarders_Opt_DscpNumber namedHL_Number
syn match namedOVZ_Forwarders_Opt_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_Forwarders_Opt_Dscp namedHL_Option
syn keyword namedOVZ_Forwarders_Opt_Dscp contained dscp
\ skipwhite
\ nextgroup=namedOVZ_Forwarders_Opt_DscpNumber
\ containedin=namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_Opt_Port namedHL_Option
syn keyword namedOVZ_Forwarders_Opt_Port contained skipwhite port
\ nextgroup=
\    namedOVZ_Forwarders_Opt_PortNumber,
\    namedError
\ containedin=namedOVZ_Forwarders_Section

" hi link namedOVZ_Forwarders_IP6 namedHL_Number
syn match namedOVZ_Forwarders_IP6 contained skipwhite /[0-9a-fA-F:\.]\{6,48}/
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedOVZ_Forwarders_Opt_Port,
\   namedOVZ_Forwarders_Opt_Dscp,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_IP4 namedHL_Number
syn match namedOVZ_Forwarders_IP4 contained skipwhite 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\   namedSemicolon,
\   namedOVZ_Forwarders_Opt_Port,
\   namedOVZ_Forwarders_Opt_Dscp,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOVZ_Forwarders_Section

syn region namedOVZ_Forwarders_Section contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=namedComment
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

hi link namedOVZ_Forwarders_DscpNumber namedHL_Number
syn match namedOVZ_Forwarders_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=
\    namedOVZ_Forwarders_Port,
\    namedOVZ_Forwarders_Section,
\    namedSemicolon

hi link namedOVZ_Forwarders_PortNumber namedHL_Number
syn match namedOVZ_Forwarders_PortNumber contained skipwhite
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ nextgroup=
\    namedOVZ_Forwarders_Dscp,
\    namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_Port  namedHL_Option
syn match namedOVZ_Forwarders_Port /port/ contained skipwhite
\ nextgroup=namedOVZ_Forwarders_PortNumber

hi link namedOVZ_Forwarders_Dscp  namedHL_Option
syn match namedOVZ_Forwarders_Dscp /dscp/ contained skipwhite
\ nextgroup=namedOVZ_Forwarders_DscpNumber


hi link namedOVZ_Forwarders namedHL_Option
syn keyword namedOVZ_Forwarders contained 
\    forwarders
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedOVZ_Forwarders_Section,
\    namedOVZ_Forwarders_Port,
\    namedOVZ_Forwarders_Dscp,
\    namedComment, namedInclude,
\    namedError
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOVZ_MasterfileFormat_Opts namedHL_Builtin
syn keyword namedOVZ_MasterfileFormat_Opts contained
\    raw
\    text
\    map
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_MasterfileFormat namedHL_Option
syn keyword namedOVZ_MasterfileFormat contained
\    masterfile-format
\ nextgroup=namedOVZ_MasterfileFormat_Opts
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOVZ_MasterfileStyles namedHL_Builtin
syn keyword namedOVZ_MasterfileStyles contained
\    full
\    relative
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_MasterfileStyle namedHL_Option
syn keyword namedOVZ_MasterfileStyle contained
\    masterfile-style
\ nextgroup=namedOVZ_MasterfileStyles
\ skipwhite
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection


hi link namedOVZ_TtlUnlimited namedHL_Builtin
syn keyword namedOVZ_TtlUnlimited contained unlimited skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_Ttl namedHL_Number
syn match namedOVZ_Ttl contained skipwhite
\ /\d\{1,10}/
\ nextgroup=namedSemicolon

hi link namedOVZ_MaxZoneTtl namedHL_Option
syn keyword namedOVZ_MaxZoneTtl contained max-zone-ttl skipwhite
\ nextgroup=namedOVZ_TtlUnlimited,namedOVZ_Ttl
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection


" view statement - Filespec (directory, filename)
hi link namedOVZ_Filespec_Group namedHL_Option
syn keyword namedOVZ_Filespec_Group contained skipwhite
\    key-directory
\ nextgroup=named_String_QuoteForced_SC,namedNotString
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection 

hi link namedOVZ_DefaultUnlimitedSize_Group namedHL_Option
syn keyword namedOVZ_DefaultUnlimitedSize_Group contained skipwhite
\    max-ixfr-log-size
\ nextgroup=
\    named_SizeSpec_SC,
\    named_DefaultUnlimited_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection 

" max-refresh-time obsoleted in view and zone section

hi link namedOVZ_RefreshRetry namedHL_Option
syn keyword namedOVZ_RefreshRetry contained skipwhite
\    max-refresh-time
\    max-retry-time
\    min-refresh-time
\    min-retry-time
\ nextgroup=named_Number_Max24week_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

hi link namedOVZ_ZoneStat_Opts namedHL_Builtin
syn keyword namedOVZ_ZoneStat_Opts contained skipwhite
\    full
\    terse
\    none
\ nextgroup=namedSemicolon

hi link namedOVZ_ZoneStat namedHL_Option
syn keyword namedOVZ_ZoneStat contained skipwhite
\    zone-statistics
\ nextgroup=namedOVZ_ZoneStat_Opts,@namedClusterBoolean
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', 'view', and 'zone' ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'server'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link named_A6orAAAA_SC namedHL_String
" syn match named_A6orAAAA_SC contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match named_A6orAAAA_SC /\caaaa/ contained skipwhite nextgroup=namedSemicolon
syn match named_A6orAAAA_SC /\ca6/ contained skipwhite nextgroup=namedSemicolon

hi link namedOSV_OptAV6S namedHL_Option
syn keyword namedOSV_OptAV6S contained skipwhite
\    allow-v6-synthesis
\ nextgroup=named_A6orAAAA_SC 
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmtServerSection,
\    namedStmt_ViewSection

hi link namedOSV_Boolean_Group namedHL_Option
syn keyword namedOSV_Boolean_Group contained skipwhite
\    provide-ixfr
\    request-nsid
\    send-cookie
\ nextgroup=@namedClusterBoolean 
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmtServerSection,
\    namedStmt_ViewSection

" <0-3660> days (sig-validity-interval)
hi link namedOVZ_First_Number_Max3660days namedHL_Number
syn match namedOVZ_First_Number_Max3660days contained skipwhite
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ nextgroup=named_Number_Max3660days,namedSemicolon

hi link namedOVZ_SigSigning namedHL_Option
syn keyword namedOVZ_SigSigning contained skipwhite
\    sig-validity-interval
\ nextgroup=namedOVZ_First_Number_Max3660days
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection 

hi link namedOVZ_Notify_Opts namedHL_Builtin
syn keyword namedOVZ_Notify_Opts contained skipwhite
\    explicit
\    master-only
\ nextgroup=namedSemicolon

hi link namedOVZ_Notify namedHL_Option
syn keyword namedOVZ_Notify contained skipwhite
\    notify
\ nextgroup=namedOVZ_Notify_Opts,@namedClusterBoolean
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtZoneSection 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOSVZ_Boolean_Group namedHL_Option
syn keyword namedOSVZ_Boolean_Group  contained skipwhite
\    notify-to-soa
\    request-expire
\    request-ixfr
\ nextgroup=@namedClusterBoolean_SC
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtServerSection,
\    namedStmtZoneSection


" + these keywords are contained within `update-policy' section only
" syn keyword namedIntKeyword contained grant nextgroup=namedString skipwhite
" syn keyword namedIntKeyword contained name self subdomain wildcard nextgroup=namedString skipwhite
" syn keyword namedIntKeyword TXT A PTR NS SOA A6 CNAME MX ANY skipwhite
" 
" syn keyword namedZoneOpt contained update-policy
" \  nextgroup=namedIntSection skipwhite

" syn match namedAMElement contained /.*\s*;/ 
" \ contains=namedACLName,namedComment,namedError skipwhite

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

hi link namedOSVZ_AlsoNotify namedHL_Option
" In 'server', `also-notify` is no longer valid after 9.13
syn keyword namedOSVZ_AlsoNotify contained skipwhite
\    also-notify
\ nextgroup=namedOSVZ_Masters_MML,namedInclude,namedComment,namedError
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection,
\    namedStmtServerSection,
\    namedStmtZoneSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Not the same as 'check-names' in 'options' statement
hi link namedVZ_CheckNames namedHL_Option
syn keyword namedVZ_CheckNames contained 
\    check-names
\ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
\ containedin=
\    namedStmt_ViewSection,
\    namedStmtZoneSection

" not the same as ixfr-from-differences in 'options' statement
hi link namedVZ_Ixfr_From_Diff namedHL_Option
syn keyword namedVZ_Ixfr_From_Diff contained ixfr-from-differences skipwhite
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC
\ containedin=
\    namedStmt_ViewSection,
\    namedStmtZoneSection

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections ({ ... };) of statements go below here
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options { <options_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmt_OptionsSection contained start=+{+ end=+}+ 
\ skipwhite
\ contains=
\    namedInclude,
\    namedComment,
\    namedParenError
\ nextgroup=namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmt_ServerNameIdentifier> { <namedStmtServerKeywords>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmtServerSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ contains=
\    namedComment,
\    namedInclude
\ nextgroup=namedSemicolon


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmt_ServerNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn match namedStmt_ServerNameIdentifier contained
\ /[0-9]\{1,3}\(\.[0-9]\{1,3}\)\{0,3}\([\/][0-9]\{1,3}\)\{0,1}/
\ skipwhite
\ nextgroup=
\    namedStmtServerSection,
\    namedComment,
\    namedInclude,
\    namedError 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" view <namedStmt_ViewNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmt_ViewSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,namedComment,namedParenError

hi link namedStmt_ViewNameIdentifier	namedHL_Identifier
syn match namedStmt_ViewNameIdentifier contained /\i\+/ skipwhite
\ nextgroup=namedStmt_ViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" zone <namedStmt_ZoneNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmtZoneSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,
\    namedComment,
\    namedParenError

hi link namedStmtZoneClass namedHL_Identifier
syn match namedStmtZoneClass contained /\<\c\%(CHAOS\)\|\%(HESIOD\)\|\%(IN\)\|\%(CH\)\|\%(HS\)\>/
\ skipwhite skipempty
\ nextgroup=
\    namedStmtZoneSection,
\    namedComment,
\    namedError 

hi link namedStmt_ZoneNameIdentifier namedHL_Identifier
syn match namedStmt_ZoneNameIdentifier contained /\S\+/ 
\ skipwhite skipempty
\ contains=named_QuotedDomain
\ nextgroup=
\    namedStmtZoneSection,
\    namedStmtZoneClass,
\    namedComment


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Top-level statment (formerly clause) keywords
" 'uncontained' statements are the ones used GLOBALLY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtKeyword namedHL_Statement
syn match namedStmtKeyword /\_^\s*\<acl\>/ skipempty skipnl skipwhite
\ nextgroup=namedStmtACLIdent

syn match namedStmtKeyword /\_^\s*\<controls\>/ skipempty skipnl skipwhite
\ nextgroup=namedStmtControlsSection

syn match namedStmtKeyword /\_^\s*\<dlz\>/ skipempty skipnl skipwhite
\ nextgroup=namedStmtDlzIdent

syn match namedStmtKeyword /\_^\s*\<dyndb\>/ skipempty skipnl skipwhite
\ nextgroup=namedStmtDyndbIdent
\ containedin=namedStmt_ViewSection

syn match namedStmtKeyword /\_^\s*\<key\>/ skipwhite skipempty
\ nextgroup=namedStmtKeyIdent 

syn match namedStmtKeyword /\_^\s*\<logging\>/ skipempty skipwhite
\ nextgroup=namedStmtLoggingSection 

syn match namedStmtKeyword /\_^\s*\<managed-keys\>/ skipempty skipwhite
\ nextgroup=namedStmt_ManagedKeysSection 

syn match namedStmtKeyword /\_^\s*\<masters\>/ skipwhite skipnl skipempty 
\ nextgroup=
\    namedStmt_MastersNameIdentifier,
\    namedComment, 
\    namedInclude,
" \ namedError prevents a linefeed between 'master' and '<master_name'

syn match namedStmtKeyword /\_^\s*\<options\>/ skipempty skipwhite
\ nextgroup=namedStmt_OptionsSection 

syn match  namedStmtKeyword /\_^\s*\<server\>/ skipempty skipwhite
\ nextgroup=namedStmt_ServerNameIdentifier,namedComment 
\ containedin=namedStmt_ViewSection

syn match namedStmtKeyword /\_^\s*\<statistics-channels\>/ skipempty skipwhite
\ nextgroup=namedIntIdent 

syn match namedStmtKeyword /\_^\s*\<trusted-keys\>/ skipempty skipwhite
\ nextgroup=namedIntSection 

" view <namedStmt_ViewNameIdentifier> { ... };  
syn match namedStmtKeyword /\_^\s*\<view\>/ skipwhite skipempty
\ nextgroup=namedStmt_ViewNameIdentifier 

" TODO: namedStmtError, how to get namedHL_Error to appear
" zone <namedStmt_ZoneNameIdentifier> { ... };
syn match namedStmtKeyword /\_^\_s*\<zone\>/ skipempty skipwhite
\ nextgroup=
\    namedStmt_ZoneNameIdentifier,
\    namedComment,
\    namedStmtError 
\ containedin=namedStmt_ViewSection

let &cpoptions = s:save_cpo
unlet s:save_cpo

let b:current_syntax = 'named'

if main_syntax == 'bind-named'
  unlet main_syntax
endif

" vim: ts=4
