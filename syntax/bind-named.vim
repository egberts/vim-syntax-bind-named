" Vim syntax file
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
hi link namedInclude	Include
hi link namedHL_Identifier 	Identifier
hi link namedHL_Statement	Statement
hi link namedHL_Option	Label
hi link namedHL_Type	Type
hi link namedHL_Clause	Keyword   " could use a 3rd color here
hi link namedHL_Number	Number
hi link namedHL_String	String
hi link namedHL_Underlined	Underlined
hi link namedHL_Error	Error
hi link namedHL_Builtin	Special


" Bind Statements (top-level)
hi link namedACLKeyword	namedHL_Statement
hi link namedC_Keyword	namedHL_Statement
hi link namedDLZKeyword	namedHL_Statement
hi link namedKeyKeyword	namedHL_Statement
hi link namedLoggingKeyword	namedHL_Statement
hi link namedManagedKeysKeyword	namedHL_Statement
hi link namedLWRESKeyword	namedHL_Statement  " gone in 9.13.0 
hi link namedMastersKeyword	namedHL_Statement
hi link namedO_Keywords	namedHL_Statement
hi link namedStmtServerKeywords	namedHL_Statement
hi link namedStatisticsChannelsKeyword	namedHL_Statement
hi link namedTrustedKeysKeyword	namedHL_Statement
hi link namedStmtViewKeywords	namedHL_Statement
hi link namedStmtZoneKeywords	namedHL_Statement

" Second-level highlighting

hi link namedACLIdent	namedHL_Identifier
hi link namedACLName	namedHL_Identifier
hi link namedChannelIdent	namedHL_Identifier
hi link namedChannelName	namedHL_Identifier
hi link namedKeyIdent	namedHL_Identifier
hi link namedKeyName	namedHL_Identifier
hi link namedStmtMastersIdent	namedHL_Identifier
hi link namedMasterName	namedHL_Identifier
hi link namedElementMasterName	namedHL_Identifier
hi link namedStmtServerIdent namedHL_Identifier
hi link namedServerName	namedHL_Identifier
hi link namedViewIdent	namedHL_Identifier
hi link namedViewName	namedHL_Identifier
hi link namedZoneIdent	namedHL_Identifier
hi link namedZoneName	namedHL_Identifier
hi link namedElementZoneName	namedHL_Identifier
hi link namedHLDomain	namedHL_String 
hi link namedString	namedHL_String
hi link namedGroupID	namedHL_Number
hi link namedUserID	namedHL_Number
hi link namedFilePerm   namedHL_Number
hi link namedWildcard   namedHL_Number

" Third-level highlighting
"   - Type
"   - Type
"   - Number
"   - Identifier
hi link named_QuotedDomain	namedHLDomain
hi link namedDNSSECLookaside	namedHL_Number
hi link namedDSS_OptGlobalPort	namedKeyword
hi link namedPortKeyword	namedKeyword
hi link namedPortWild    	namedWildcard
hi link namedWildcard	namedHL_Number
hi link namedFilesCount	namedHL_Number
hi link namedOK         21

hi link namedClauseKeyword	namedHL_Option
hi link namedKeyword	namedHL_Option
hi link namedIntKeyword	namedHL_Option

hi link namedTypeMinutes	namedHL_Number
hi link namedPort	namedHL_Number
hi link namedHexNumber	namedHL_Number
hi link namedIP4Addr	namedHL_Number
hi link namedIPwild	namedHL_Number
hi link namedNumber	namedHL_Number
hi link named_Number_SC	namedHL_Number
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
hi link namedIgnoreWarnFail	namedHL_Type
hi link namedAllowMaintainOff	namedHL_Type

hi link namedC_Inet	namedHL_Clause
hi link namedC_Port	namedHL_Clause
hi link namedC_Allow	namedHL_Clause
hi link namedC_Key	namedHL_Clause

hi link named_String_QuoteForced	namedHL_String
hi link named_String_SQuoteForced	namedHL_String
hi link named_String_DQuoteForced	namedHL_String
hi link named_Filespec	namedHL_String


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


" --- Other variants of strings
syn match named_Filespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match named_Filespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match named_Filespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl

hi link named_E_Filespec_SC namedHL_Identifier
" TODO those curly braces and semicolon MUST be able to work within quotes.
syn match named_E_Filespec_SC contained /\'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)\+{}]\{1,1024}\'/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /"[ a-zA-Z\]\-\[0-9\._,:\;\/?<>|'`~!@#$%\^&*\\(\\)\+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl nextgroup=namedSemicolon


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

hi link namedToDo Todo
syn keyword namedToDo xxx contained XXX FIXME TODO TODO: FIXME:

syn match namedComment "//.*" contains=namedToDo
syn match namedComment "#.*" contains=namedToDo
syn region namedComment start="/\*" end="\*/" contains=namedToDo
syn match namedInclude /\_s*include/ 
\ nextgroup=named_E_Filespec_SC
\ skipwhite skipnl skipempty

" 'contained' statements are confined to within their parent's region

hi link namedSemicolon namedOK
syn match namedSemicolon contained /\(;\+\s*\)\+/ skipwhite
" We need a better NotSemicolon pattern here
syn match namedNotSemicolon contained /[^;]\+/he=e-1 skipwhite
syn match namedError /[^;{#]$/

syn match namedNotNumber contained "[^  0-9;]\+"
syn match namedNumber contained "\d\+"
syn match named_Number_SC contained "\d\{1,10}\s*;"he=e-1
syn match namedGroupID contained "[0-6]\{0,1}[0-9]\{1,4}"
syn match namedUserID contained "[0-6]\{0,1}[0-9]\{1,4}"
syn match namedFilePerm contained "[0-7]\{3,4}"
syn match namedDSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/

syn match namedPort contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
syn match namedPortWild contained /\*/
syn match namedPortWild contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link namedElementPortWild namedHL_Number
syn match namedElementPortWild contained /\*\s*;/ skipwhite
"syn match namedElementPortWild contained /\d\{1,5}\s*;/hs=s,me=e-1
syn match namedElementPortWild contained /\%([1-9]\|[1-5]\?[0-9]\{2,4}\|6[1-4][0-9]\{3}\|65[1-4][0-9]\{2}\|655[1-2][0-9]\|6553[1-5]\)\s*;/he=e-1
\ contains=namedPort skipwhite

syn match namedWildcard contained /\*/

hi link named_TypeBool_SC	namedTypeBool
syn match named_TypeBool_SC contained /\cyes/ skipwhite nextgroup=namedSemicolon
syn match named_TypeBool_SC contained /\cno/ skipwhite nextgroup=namedSemicolon
syn match named_TypeBool_SC contained /\ctrue/ skipwhite nextgroup=namedSemicolon
syn match named_TypeBool_SC contained /\cfalse/ skipwhite nextgroup=namedSemicolon
syn keyword named_TypeBool_SC contained 1 skipwhite nextgroup=namedSemicolon
syn keyword named_TypeBool_SC contained 0 skipwhite nextgroup=namedSemicolon

syn match namedNotBool contained "[^  ;]\+"
syn match namedTypeBool contained /\cyes/
syn match namedTypeBool contained /\cno/
syn match namedTypeBool contained /\ctrue/
syn match namedTypeBool contained /\cfalse/
syn keyword namedTypeBool contained 1
syn keyword namedTypeBool contained 0

hi link namedIP4Addr namedHL_Number
hi link namedIP4AddrPrefix namedHL_Number
hi link namedElementIP4Addr namedHL_Number
hi link namedElementIP4AddrPrefix namedHL_Number
hi link namedIP6Addr namedHL_Number
hi link namedIP6AddrPrefix namedHL_Number
hi link namedElementIP6Addr namedHL_Number
hi link namedElementIP6AddrPrefix namedHL_Number

syn match namedIP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
syn match namedIP4AddrPrefix contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
syn match namedElementIP4Addr contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\s*;/he=e-1
syn match namedElementIP4AddrPrefix contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}\s*;/he=e-1

" namedIP6Addr  should match:
"  IPv6 addresses
"    zero compressed IPv6 addresses (section 2.2 of rfc5952)
"    link-local IPv6 addresses with zone index (section 11 of rfc4007)
"    IPv4-Embedded IPv6 Address (section 2 of rfc6052)
"    IPv4-mapped IPv6 addresses (section 2.1 of rfc2765)
"    IPv4-translated addresses (section 2.1 of rfc2765)
"  IPv4 addresses
"
" Full IPv6 with Prefix with trailing semicolon
syn match namedElementIP6AddrPrefix /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}\s*;/he=e-1 contained
" 1::                              1:2:3:4:5:6:7::
syn match namedElementIP6AddrPrefix /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}\s*;/he=e-1 contained
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedElementIP6AddrPrefix /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}\s*;/he=e-1 contained
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedElementIP6AddrPrefix /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}\s*;/he=e-1 contained
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedElementIP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}\s*;/he=e-1
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedElementIP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}\s*;/he=e-1
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedElementIP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}\s*;/he=e-1
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedElementIP6AddrPrefix contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}\s*;/he=e-1
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedElementIP6AddrPrefix contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}\s*;/he=e-1
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedElementIP6AddrPrefix contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}\/[0-9]\{1,3}%[a-zA-Z0-9]\{1,64}\s*;/he=e-1
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedElementIP6AddrPrefix contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}\s*;/he=e-1
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedElementIP6AddrPrefix contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}\s*;/he=e-1
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedElementIP6AddrPrefix contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}\s*;/he=e-1
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedElementIP6AddrPrefix contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}\s*;/he=e-1
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedElementIP6AddrPrefix contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}\s*;/he=e-1

" Full IPv6 (without the trailing '/') with trailing semicolon
syn match namedElementIP6Addr /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\s*;/he=e-1 contained
" 1::                              1:2:3:4:5:6:7::
syn match namedElementIP6Addr /\%(\x\{1,4}:\)\{1,7}:\s*;/he=e-1 contained
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedElementIP6Addr /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\s*;/he=e-1 contained
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedElementIP6Addr /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\s*;/he=e-1 contained
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedElementIP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\s*;/he=e-1
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedElementIP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\s*;/he=e-1
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedElementIP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\s*;/he=e-1
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedElementIP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\s*;/he=e-1
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedElementIP6Addr contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}\s*;/he=e-1
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedElementIP6Addr contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}\s*;/
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedElementIP6Addr /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\s*;/he=e-1 contained
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedElementIP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\s*;/
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedElementIP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\s*;/
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedElementIP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\s*;/he=e-1
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedElementIP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\s*;/he=e-1

" Full IPv6 with Prefix (without semicolon)
syn match namedIP6AddrPrefix /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/ contained
" 1::                              1:2:3:4:5:6:7::
syn match namedIP6AddrPrefix /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/ contained
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedIP6AddrPrefix /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/ contained
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedIP6AddrPrefix /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/ contained
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedIP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedIP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedIP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedIP6AddrPrefix contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedIP6AddrPrefix contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedIP6AddrPrefix contained /fe80:\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedIP6AddrPrefix contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedIP6AddrPrefix contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedIP6AddrPrefix contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedIP6AddrPrefix contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedIP6AddrPrefix contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/

" Full IPv6 (without the trailing '/') (without semicolon)
syn match namedIP6Addr /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ contained
" 1::                              1:2:3:4:5:6:7::
syn match namedIP6Addr /\%(\x\{1,4}:\)\{1,7}:/ contained
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedIP6Addr /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ contained
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedIP6Addr /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/ contained
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedIP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedIP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedIP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedIP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedIP6Addr contained /fe80%[a-zA-Z0-9\-_\.]\{1,64}/
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedIP6Addr contained /fe80:\%(:\x\{1,4}\)\{1,2}%[a-zA-Z0-9\-_\.]\{1,64}/
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedIP6Addr /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ contained
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedIP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedIP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedIP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedIP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/


syn match namedIgnoreWarnFail contained /\cwarn/ skipwhite
syn match namedIgnoreWarnFail contained /\cfail/ skipwhite
syn match namedIgnoreWarnFail contained /\cignore/ skipwhite

syn match namedAllowMaintainOff contained /\callow/ skipwhite
syn match namedAllowMaintainOff contained /\cmaintain/ skipwhite
syn match namedAllowMaintainOff contained /\coff/ skipwhite


" --- string 
syn region namedString start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
syn region namedString start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
syn match namedString contained /\<[a-zA-Z0-9_\.\-]\{1,63}\>/
syn region named_String_DQuoteForced start=/"/ skip=/\\"/ end=/"/ contained
syn region named_String_SQuoteForced start=/'/ skip=/\\'/ end=/'/ contained
syn region named_String_QuoteForced start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
syn region named_String_QuoteForced start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
hi link named_String_DQuoteForced_SC namedHL_Identifier
syn region named_String_DQuoteForced_SC start=/"/ skip=/\\"/ end=/"/ contained nextgroup=namedSemicolon
hi link named_String_SQuoteForced_SC namedHL_Identifier
syn region named_String_SQuoteForced_SC start=/'/ skip=/\\'/ end=/'/ contained nextgroup=namedSemicolon
hi link named_String_QuoteForced_SC namedHL_Identifier
syn region named_String_QuoteForced_SC start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained nextgroup=namedSemicolon
syn region named_String_QuoteForced_SC start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained nextgroup=namedSemicolon

" -- Identifier
syn match namedACLName contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ skipwhite
hi link named_E_ACLName_SC namedHL_Identifier
syn match named_E_ACLName_SC contained /\<[0-9a-zA-Z\-_\[\]\<\>]\{1,63}\>/
\ skipwhite
\ nextgroup=namedSemicolon

syn match namedTypeBase64 contained /\<[0-9a-zA-Z\/\-\_\,+=]\{1,4099}/
syn match namedKeySecretValue contained /\<[0-9a-zA-Z\+\=\/]\{1,4099}\s*;/he=e-1 skipwhite

syn match namedKeyName contained /\<[0-9a-zA-Z\-_]\{1,64}/ skipwhite
syn match namedKeyAlgorithmName contained /\<[0-9A-Za-z\-_]\{1,4096}/ skipwhite
syn match namedMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}/ skipwhite
syn match namedElementMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}\s*;/he=e-1 skipwhite
syn match namedHexSecretValue contained /\<'[0-9a-fA-F]\+'\>/ skipwhite
syn match namedHexSecretValue contained /\<"[0-9a-fA-F]\+"\>/ skipwhite

" syn match namedViewName contained /[a-zA-Z0-9_\-\.+~@$%\^&*()=\[\]\\|:<>`?]\{1,64}/ skipwhite
syn match namedViewName contained /[a-zA-Z0-9]\{1,64}/ skipwhite
hi link namedElementViewName namedHL_Identifier
syn match namedElementViewName contained /[a-zA-Z0-9\-_\.]\{1,63}\s*;/he=e-1 skipwhite
\ contained skipwhite 
\ contains=namedViewName
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
syn match named_QuotedDomain contained /\<[0-9A-Za-z\._\-]\{1,1023}\>/ nextgroup=namedSpareDot
syn match named_QuotedDomain contained /'\<[0-9A-Za-z\.\-_]\{1,1023}'\>./ nextgroup=namedSpareDot
syn match named_QuotedDomain contained /"\<[0-9A-Za-z\.\-_]\{1,1023}"\>\"/ nextgroup=namedSpareDot
hi link named_QuotedDomain_SC	namedHLDomain
syn match named_QuotedDomain_SC contained /[0-9A-Za-z\._\-]\{1,1023}\.\{0,1}/ nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /'[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}'/ nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /"[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}"/hs=s+1,he=e-1 nextgroup=namedSemicolon skipwhite

" -- Vim syntax clusters
syntax cluster namedClusterCommonNext contains=namedComment,namedInclude,namedError
hi link namedClusterBoolean_SC namedHL_Error
syntax cluster namedClusterBoolean_SC contains=named_TypeBool_SC
syntax cluster namedClusterBoolean contains=namedTypeBool,namedNotBool,@namedClusterCommonNext
syntax cluster namedDomainFQDNCluster contains=namedDomain,namedError
syn cluster namedCommentGroup contains=namedToDo


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedTypeSizeSpec namedHL_Builtin
syn match namedTypeSizeSpec /unlimited\s*;/ contained skipwhite
syn match namedTypeSizeSpec /default\s*;/ contained skipwhite
hi link namedTypeSizeSpec namedHL_Number
syn match namedTypeSizeSpec /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/ contained skipwhite

syn region namedElementIP4AddrList contained start=+{+ end=+}\s*;+he=e-1
\ contains=namedElementIP4Addr,namedIPerror,namedParenError,namedComment

" AML Section/Elements
syn region namedElementAMLSection contained start=+{+ end=+;+
\ skipempty
\ contains=
\    namedInclude,
\    namedComment,
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    named_E_ACLName_SC  " TODO find a way to show Builtins before ACLName
\ nextgroup=
\    namedSemicolon,
\    namedParenError

syn region namedAMLSection contained start=/{/ end=/}/
\ contains=
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    named_E_ACLName_SC,
\    namedParenError,
\    namedInclude,
\    namedComment 
\    skipwhite

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
\ contains=namedGroupID
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
\    namedElementIP6Addr,
\    namedElementIP4Addr,
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
\ contains=namedIP6Addr,namedIP4Addr
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

hi link namedStmtKeyIdent namedHL_Identifier
syn match namedStmtKeyIdent contained skipwhite /\i/
\ contains=namedKeyName
\ nextgroup=namedStmtKeySection,namedNotParem,namedError

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
hi link namedLoggingCategoryChannelName namedHL_Identifier
syn match namedLoggingCategoryChannelName contained /\i\+/ skipwhite
\ contains=namedString
\ containedin=namedLoggingCategorySection

syn region namedLoggingCategorySection contained start=+{+ end=+}+ 
\ skipwhite
\ contains=namedLoggingCategoryChannelName
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
\ contains=namedTypeSizeSpec
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
\ contains=namedString
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
syn match namedMk_E_KeySecret /["'0-9A-Za-z\+\=\/]\{1,4098}/ 
\ contains=namedKeySecretValue
\ contained skipwhite
\ skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon,namedError

hi link namedMk_E_AlgorithmType namedHL_Number
syn match namedMk_E_AlgorithmType contained skipwhite /\d\{1,3}/
\ skipempty
\ nextgroup=namedMk_E_KeySecret,namedError

hi link namedMk_E_ProtocolType namedHL_Number
syn match namedMk_E_ProtocolType contained skipwhite /\d\{1,3}/
\ skipempty
\ nextgroup=namedMk_E_AlgorithmType,namedError

hi link namedMk_E_FlagType namedHL_Number
syn match namedMk_E_FlagType contained skipwhite /\d\{1,3}/
\ skipempty
\ nextgroup=namedMk_E_ProtocolType,namedError

hi link namedMk_E_InitialKey namedHL_Number
syn match namedMk_E_InitialKey /[0-9A-Za-z][-0-9A-Za-z.]\{1,4096}/ 
\ contained skipwhite skipempty
\ contains=namedString
\ nextgroup=namedMk_E_FlagType,namedError

hi link namedMk_E_DomainName namedHL_Identifier
syn match namedMk_E_DomainName /[0-9A-Za-z][_\-0-9A-Za-z.]\{1,1024}/
\ contains=namedDomain
\ contained skipwhite skipempty 
\ nextgroup=namedMk_E_InitialKey,namedError

syn region namedStmtManagedKeysSection start=+{+ end=+}+
\ contained skipwhite skipempty skipnl
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
\ contains=namedPort
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
\ contains=namedIP6Addr
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

syn match namedStmtMastersIdent contained /\<[0-9a-zA-Z\-_\.]\{1,64}/
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
hi link namedO_BooleanKeywords namedHL_Option
syn keyword namedO_BooleanKeywords contained 
\     automatic-interface-scan 
\     answer-cookie
\     flush-zones-on-shutdown
\     match-mapped-addresses
\ nextgroup=@namedClusterBoolean
\ skipwhite
\ containedin=namedStmtOptionsSection

syn keyword namedO_Keywords contained
\    avoid-v4-udp-ports
\    avoid-v6-udp-ports
\ nextgroup=namedPortSection,namedInclude,namedComment,namedError
\ skipwhite

syn keyword namedO_Keywords contained
\    bindkeys-file
\    cache-file
\    directory
\    dump-file
\    geoip-directory
\    key-directory
\    managed-keys-directory
\    named-xfer
\    pid-file
\    nextgroup=named_String_QuoteForced_SC,namedNotString
\    skipwhite

syn keyword namedO_Keywords contained
\    blackhole
\    listen-on
\ nextgroup=namedAMLSection,namedInclude,namedComment
\ skipwhite

hi link namedO_CheckNamesType namedHL_Builtin
syn match namedO_CheckNamesType contained /primary/ skipwhite
\ nextgroup=namedIgnoreWarnFail
syn match namedO_CheckNamesType contained /secondary/ skipwhite
\ nextgroup=namedIgnoreWarnFail
syn match namedO_CheckNamesType contained /response/ skipwhite
\ nextgroup=namedIgnoreWarnFail
syn match namedO_CheckNamesType contained /master/ skipwhite
\ nextgroup=namedIgnoreWarnFail
syn match namedO_CheckNamesType contained /slave/ skipwhite
\ nextgroup=namedIgnoreWarnFail 

hi link namedO_CheckNames namedHL_Option
syn keyword namedO_CheckNames contained check-names skipwhite
\ nextgroup=namedO_CheckNamesType,namedError
\ containedin=namedStmtOptionsSection

hi link namedO_CookieAlgorithmChoices namedHL_Type
syn match namedO_CookieAlgorithmChoices contained skipwhite
\ /\%(aes\)\|\%(sha256\)\|\%(sha1\)/
\ nextgroup=namedSemicolon,namedError

hi link namedO_CookieAlgs namedHL_Option
syn keyword namedO_CookieAlgs contained cookie-algorithm
\ skipwhite
\ nextgroup=namedO_CookieAlgorithmChoices
\ containedin=namedStmtOptionsSection

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
\ containedin=namedStmtOptionsSection

hi link namedO_CoresizeValueFixed namedHL_Builtin
syn match namedO_CoresizeValueFixed contained 
\ /\(default\)\|\(unlimited\)/
\ contains=namedHexSecretValue
\ skipwhite
\ nextgroup=namedSemicolon
hi link namedO_CoresizeValueDynamic namedHL_Number
syn match namedO_CoresizeValueDynamic contained 
\ /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>\s*;/he=e-1
\ contains=namedNumber
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_Coresize namedHL_Option
syn keyword namedO_Coresize contained 
\     coresize
\     datasize
\     files
\     stacksize
\ skipwhite
\ nextgroup=
\    namedO_CoresizeValueFixed,
\    namedO_CoresizeValueDynamic
\ containedin=namedStmtOptionsSection

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

hi link namedO_DnstapOutputFilespec namedHL_String
syn match namedO_DnstapOutputFilespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl  nextgroup=namedO_DnstapOutputSection
syn match namedO_DnstapOutputFilespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedO_DnstapOutputSection
syn match namedO_DnstapOutputFilespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedO_DnstapOutputSection

hi link namedO_DnstapOutputType namedHL_Type
syn keyword namedO_DnstapOutputType contained
\    file
\    unix
\ skipwhite
\ nextgroup=namedO_DnstapOutputFilespec

hi link namedO_DnstapOutputKeyword namedHL_Option
syn keyword namedO_DnstapOutputKeyword contained
\    dnstap-output
\ skipwhite
\ nextgroup=
\    namedO_DnstapOutputType
\ containedin=namedStmtOptionsSection

hi link namedO_DnstapVersionOpt namedHL_Builtin
syn keyword namedO_DnstapVersionOpt contained none skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapVersion namedHL_Option
syn keyword namedO_DnstapVersion contained
\    dnstap-version
\ skipwhite
\ nextgroup=
\    namedO_DnstapVersionOpt,
\    named_E_Filespec_SC
\ containedin=namedStmtOptionsSection


syn match namedO_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ contains=namedDSCP
\ nextgroup=namedSemicolon

hi link namedO_Dscp namedHL_Option
syn keyword namedO_Dscp contained dscp skipwhite
\ nextgroup=namedO_DscpNumber
\ containedin=namedStmtOptionsSection

hi link namedO_Number namedHL_Number
syn match namedO_Number  contained
\    /\d\{1,10}/
\ skipwhite
\ nextgroup=namedSemicolon

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
\ containedin=namedStmtOptionsSection

hi link namedO_Fstrm_SetBufferHint namedHL_Option
syn keyword namedO_Fstrm_SetBufferHint contained
\    fstrm-set-buffer-hint
\    fstrm-set-flush-timeout
\    fstrm-set-input-queue-size
\    fstrm-set-output-notify-threshold
\    fstrm-set-output-queue-size
\    fstrm-set-reopen-interval
\    interface-interval
\    lame-ttl
\    lmdb-mapsize
\    max-cache-size
\    max-cache-ttl
\    max-ncache-ttl
\    max-journal-size
\    max-records
\    max-recursion-depth
\    max-recursion-queries
\    max-refresh-time
\    max-retry-time
\    max-rsa-exponent-size
\    max-stale-ttl
\    max-transfer-idle-in
\    max-transfer-idle-out
\    max-transfer-time-in
\    max-transfer-time-out
\    max-udp-size
\    min-cache-ttl
\    min-ncache-ttl
\    min-refresh-time
\    min-retry-time
\    nocookie-udp-size
\    notify-delay
\    notify-rate
\    nta-recheck
\    port
\    resolver-query-timeout
\    resolver-retry-timeout
\    serial-query-rate
\    servfail-ttl
\    sig-signing-nodes
\    sig-signing-signatures
\    sig-signing-type
\    stacksize
\    stale-answer-ttl
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
\    v6-bias
\    zero-no-soa-ttl-cache
\ skipwhite
\ nextgroup=namedO_Number
\ containedin=namedStmtOptionsSection

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
\ containedin=namedStmtOptionsSection


" syn keyword namedO_Keywords deallocate-on-exit
" syn keyword namedO_Keywords filter-aaaa
" syn keyword namedO_Keywords filter-aaaa-on-v4
" syn keyword namedO_Keywords filter-aaaa-on-v6
" syn keyword namedO_Keywords host-statistics
" syn keyword namedO_Keywords host-statistics-max
" syn keyword namedO_Keywords interface-interval
" syn keyword namedO_Keywords lame-ttl
" syn keyword namedO_Keywords listen-on-v6
" syn keyword namedO_Keywords lock-file
" syn keyword namedO_Keywords max-cache-size
" syn keyword namedO_Keywords max-cache-ttl
" syn keyword namedO_Keywords max-ixfr-log-size
" syn keyword namedO_Keywords max-journal-size
" syn keyword namedO_Keywords max-ncache-ttl
" syn keyword namedO_Keywords max-records
" syn keyword namedO_Keywords max-recursion-depth
" syn keyword namedO_Keywords max-recursion-queries
" syn keyword namedO_Keywords max-rsa-exponent-size
" syn keyword namedO_Keywords max-transfer-idle-in
" syn keyword namedO_Keywords max-transfer-idle-out
" syn keyword namedO_Keywords max-transfer-time-in
" syn keyword namedO_Keywords max-transfer-time-out
" syn keyword namedO_Keywords max-udp-size
" syn keyword namedO_Keywords max-zone-ttl
" syn keyword namedO_Keywords memstatistics
" syn keyword namedO_Keywords memstatistics-file
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
" syn keyword namedO_Keywords notify-to-soa
" syn keyword namedO_Keywords preferred-glue
" syn keyword namedO_Keywords prefetch
" syn keyword namedO_Keywords provide-ixfr
" syn keyword namedO_Keywords queryport-port-ports
" syn keyword namedO_Keywords queryport-port-updateinterval
" syn keyword namedO_Keywords query-source
" syn keyword namedO_Keywords query-source-v6
" syn keyword namedO_Keywords querylog
" syn keyword namedO_Keywords random-device
" syn keyword namedO_Keywords rate-limit
" syn keyword namedO_Keywords recursing-file
" syn keyword namedO_Keywords recursive-clients
" syn keyword namedO_Keywords request-nsid
" syn keyword namedO_Keywords request-sit
" syn keyword namedO_Keywords reserved-sockets
" syn keyword namedO_Keywords resolver-query-timeout
" syn keyword namedO_Keywords response-policy
" syn keyword namedO_Keywords rfc2308-type1
" syn keyword namedO_Keywords root-delegation
" syn keyword namedO_Keywords rrset-order
" syn keyword namedO_Keywords secroots-file
" syn keyword namedO_Keywords serial-query-rate
" syn keyword namedO_Keywords serial-update-method
" syn keyword namedO_Keywords server-id
" syn keyword namedO_Keywords session-keyfile
" syn keyword namedO_Keywords session-keyalg
" syn keyword namedO_Keywords session-keyname
" syn keyword namedO_Keywords sig-signing-nodes
" syn keyword namedO_Keywords sig-signing-signatures
" syn keyword namedO_Keywords sig-signing-type
" syn keyword namedO_Keywords sig-validity-interval
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
" syn keyword namedO_Keywords try-tcp-refresh
" syn keyword namedO_Keywords update-check-ksk
" syn keyword namedO_Keywords use-alt-transfer-source
" syn keyword namedO_Keywords use-v4-udp-ports
" syn keyword namedO_Keywords use-v6-udp-ports
" syn keyword namedO_Keywords version
" syn keyword namedO_Keywords zero-no-soa-ttl
" syn keyword namedO_Keywords zero-no-soa-ttl-cache
" syn keyword namedO_Keywords zone-statistics

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'server' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server-statement-specific syntaxes
hi link namedServerBoolGroup namedHL_Option
syn keyword namedServerBoolGroup contained
\   bogus
\   edns
\   provide-ixfr
\   request-expire
\   request-ixfr
\   request-nsid
\   send-cookie
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
\    max-udp-size
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
" syn keyword namedStmtServerKeywords notify-to-soa
" syn keyword namedStmtServerKeywords request-sit
" syn keyword namedStmtServerKeywords support-ixfr


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'view' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedV_NumberGroup namedHL_Option
syn keyword namedV_NumberGroup contained
\    lame-ttl
\ nextgroup=namedNumber,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite

" view statement - second_type
hi link namedV_SecondGroup namedHL_Statement
syn keyword namedV_SecondGroup contained 
\    max-cache-ttl
\ nextgroup=namedTypeSeconds,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite

" view statement - minute_type
hi link namedV_MinuteGroup namedHL_Statement
syn keyword namedV_MinuteGroup contained 
\    heartbeat-interval
\ nextgroup=namedTypeMinutes,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite

" List of Port numbers

" view statement - 'check_options': warn/fail/ignore operators
" view statement - Filespec (directory, filename)
hi link namedV_FilespecGroup namedHL_Option
syn keyword namedV_FilespecGroup contained
\    cache-file
\    key-directory
\    managed-keys-directory
\    nextgroup=named_String_QuoteForced,namedNotString
\    containedin=namedStmtViewSection skipwhite

" view statement - SizeSpec options
hi link namedV_SizeSpecGroup namedHL_Statement
syn keyword namedV_SizeSpecGroup contained 
\    max-cache-size
\ nextgroup=namedTypeSizeSpec,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite


" view statement - AML
syn keyword namedV_Keywords contained
\    match-clients
\    match-destinations
\    nextgroup=namedAMLSection,namedError
\    containedin=namedStmtViewSection skipwhite


"  dual-stack-servers [ port <pg_num> ] 
"                     { ( <domain_name> [port <p_num>] |
"                         <ipv4> [port <p_num>] | 
"                         <ipv6> [port <p_num>] ); ... };
"  /.\+/
"  /\is*;/
syn match namedPortKeyword /port/
\ contained skipwhite
\ nextgroup=namedPort,namedWildcard
syn match namedDSS_Element_DomainAddrPort 
\ /\<[0-9A-Za-z\._\-]\+\>/ 
\ contained skipwhite
\ contains=namedDomain
\ nextgroup=namedPortKeyword,namedSemicolon,namedError

syn region namedDSS_Section start=+{+ end=/}\s*;/ contained 
\ contains=
\     namedDSS_Element_DomainAddrPort,
\     namedInclude,
\     namedComment,
\     namedParenError
\ skipwhite
syn match namedDSS_OptPortNumber contained /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ contains=namedPort,namedWildcard
\ nextgroup=namedDSS_Section skipwhite
syn keyword namedDSS_OptGlobalPort port
\ contained 
\ nextgroup=namedDSS_OptPortNumber skipwhite
\ containedin=namedV_Keywords

syn keyword namedV_Keywords contained 
\    dual-stack-servers
\ nextgroup=namedDSS_OptGlobalPort,namedDSS_Section skipwhite

" view statement - files
syn match namedFilesCount /\*/ contained
\ skipwhite
\ contains=namedNumber
syn match namedFilesCount /\d\+/ contained skipwhite
syn match namedFilesCount /default/ contained skipwhite
syn match namedFilesCount /unlimited/ contained skipwhite
syn keyword namedV_Keywords contained
\    files
\ nextgroup=namedFilesCount skipwhite

" view statement - hostname [ none | <domain_name> ];
hi link namedOV_Builtin_None_SC namedHL_Builtin
syn match namedOV_Builtin_None_SC contained /none/ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_Hostname namedHL_Option
syn keyword namedOV_Hostname contained hostname skipwhite
\ nextgroup=
\    namedOV_Builtin_None_SC,
\    named_QuotedDomain_SC
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection


" syn keyword namedV_Keywords class
" syn keyword namedV_Keywords filter-aaaa
" syn keyword namedV_Keywords filter-aaaa-on-v4
" syn keyword namedV_Keywords filter-aaaa-on-v6
" syn keyword namedV_Keywords ixfr-from-differences
" syn keyword namedV_Keywords match-clients
" syn keyword namedV_Keywords match-destination
" syn keyword namedV_Keywords match-recursive-only
" syn keyword namedV_Keywords max-cache-ttl
" syn keyword namedV_Keywords max-ixfr-log-size
" syn keyword namedV_Keywords max-journal-size
" syn keyword namedV_Keywords max-ncache-ttl
" syn keyword namedV_Keywords max-recursion-depth
" syn keyword namedV_Keywords max-recursion-queries
" syn keyword namedV_Keywords max-transfer-idle-in
" syn keyword namedV_Keywords max-transfer-idle-out
" syn keyword namedV_Keywords max-transfer-time-in
" syn keyword namedV_Keywords max-transfer-time-out
" syn keyword namedV_Keywords max-udp-size
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
" syn keyword namedV_Keywords notify-to-soa
" syn keyword namedV_Keywords preferred-glue
" syn keyword namedV_Keywords prefetch
" syn keyword namedV_Keywords provide-ixfr
" syn keyword namedV_Keywords queryport-port-ports
" syn keyword namedV_Keywords queryport-port-updateinterval
" syn keyword namedV_Keywords query-source
" syn keyword namedV_Keywords query-source-v6
" syn keyword namedV_Keywords rate-limit
" syn keyword namedV_Keywords request-nsid
" syn keyword namedV_Keywords request-sit
" syn keyword namedV_Keywords resolver-query-timeout
" syn keyword namedV_Keywords response-policy
" syn keyword namedV_Keywords rfc2308-type1
" syn keyword namedV_Keywords root-delegation
" syn keyword namedV_Keywords serial-update-method
" syn keyword namedV_Keywords session-keyname
" syn keyword namedV_Keywords sig-signing-nodes
" syn keyword namedV_Keywords sig-signing-signatures
" syn keyword namedV_Keywords sig-signing-type
" syn keyword namedV_Keywords sig-validity-interval
" syn keyword namedV_Keywords sortlist
" syn keyword namedV_Keywords support-ixfr
" syn keyword namedV_Keywords suppress-initial-notify
" syn keyword namedV_Keywords transfers
" syn keyword namedV_Keywords transfers-format
" syn keyword namedV_Keywords transfers-source
" syn keyword namedV_Keywords transfers-source-v6
" syn keyword namedV_Keywords try-tcp-refresh
" syn keyword namedV_Keywords update-check-ksk
" syn keyword namedV_Keywords use-alt-transfer-source
" syn keyword namedV_Keywords zero-no-soa-ttl
" syn keyword namedV_Keywords zero-no-soa-ttl-cache
" syn keyword namedV_Keywords zone-statistics

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'zone' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 'zone' clause - Filespec (directory, filename)
syn keyword namedStmtZoneKeywords contained key-directory skipwhite
\    nextgroup=named_String_QuoteForced,namedNotString
\    containedin=namedStmtViewSection

" syn keyword namedStmtZoneKeywords check-wildcard
" syn keyword namedStmtZoneKeywords class
" syn keyword namedStmtZoneKeywords client-per-query
" syn keyword namedStmtZoneKeywords database
" syn keyword namedStmtZoneKeywords delegation-only
" syn keyword namedStmtZoneKeywords file
" syn keyword namedStmtZoneKeywords in-view
" syn keyword namedStmtZoneKeywords inline-signing
" syn keyword namedStmtZoneKeywords journal
" syn keyword namedStmtZoneKeywords max-ixfr-log-size
" syn keyword namedStmtZoneKeywords max-journal-size
" syn keyword namedStmtZoneKeywords max-ncache-ttl
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
" syn keyword namedStmtZoneKeywords notify-to-soa
" syn keyword namedStmtZoneKeywords rrset-order
" syn keyword namedStmtZoneKeywords serial-update-method
" syn keyword namedStmtZoneKeywords server-addresses
" syn keyword namedStmtZoneKeywords server-names
" syn keyword namedStmtZoneKeywords session-keyname
" syn keyword namedStmtZoneKeywords sig-signing-nodes
" syn keyword namedStmtZoneKeywords sig-signing-signatures
" syn keyword namedStmtZoneKeywords sig-signing-type
" syn keyword namedStmtZoneKeywords sig-validity-interval
" syn keyword namedStmtZoneKeywords transfers-source
" syn keyword namedStmtZoneKeywords transfers-source-v6
" syn keyword namedStmtZoneKeywords type
" syn keyword namedStmtZoneKeywords update-check-ksk
" syn keyword namedStmtZoneKeywords update-policy
" syn keyword namedStmtZoneKeywords use-alt-transfer-source
" syn keyword namedStmtZoneKeywords zero-no-soa-ttl
" syn keyword namedStmtZoneKeywords zone-statistics

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
" syn keyword namedO_KeywordsObsoleted max-refresh-time
" syn keyword namedO_KeywordsObsoleted min-refresh-time
" syn keyword namedO_KeywordsObsoleted min-retry-time
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
" syn keyword namedV_KeywordsObsoleted max-refresh-time
" syn keyword namedV_KeywordsObsoleted min-refresh-time
" syn keyword namedV_KeywordsObsoleted min-retry-time
" syn keyword namedV_KeywordsObsoleted use-queryport-pool
" syn keyword namedV_KeywordsObsoleted use-queryport-updateinterval

" syn keyword namedStmtZoneKeywordsObsoleted alt-transfer-source
" syn keyword namedStmtZoneKeywordsObsoleted alt-transfer-source-v6
" syn keyword namedStmtZoneKeywordsObsoleted ixfr-base
" syn keyword namedStmtZoneKeywordsObsoleted maintain-ixfr-base
" syn keyword namedStmtZoneKeywordsObsoleted max-refresh-time
" syn keyword namedStmtZoneKeywordsObsoleted min-refresh-time
" syn keyword namedStmtZoneKeywordsObsoleted min-retry-time
" syn keyword namedStmtZoneKeywordsObsoleted pubkey
" syn keyword namedStmtZoneKeywordsObsoleted use-id-pool

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" edns-udp-size: range: 512 to 4096 (default 4096)
hi link namedOptionsServerViewEdnsUdpSizeValue namedHL_Number
syn match namedOptionsServerViewEdnsUdpSizeValue contained 
\  /\(51[2-9]\)\|\(5[2-9][0-9]\)\|\([6-9][0-9][0-9]\)\|\([1-3][0-9][0-9][0-9]\)\|\(40[0-8][0-9]\)\|\(409[0-6]\)/
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOptionsServerViewEdnsUdpSize namedHL_Option
syn keyword namedOptionsServerViewEdnsUdpSize contained edns-udp-size
\ skipwhite
\ nextgroup=namedOptionsServerViewEdnsUdpSizeValue
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtServerSection,
\    namedStmtViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOptionsViewDnssecLookasideOptKeyname namedHL_String
syn match namedOptionsViewDnssecLookasideOptKeyname contained 
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOptionsViewDnssecLookasideOptTD namedHL_Clause
syn keyword namedOptionsViewDnssecLookasideOptTD contained trust-anchor
\ nextgroup=namedOptionsViewDnssecLookasideOptKeyname
\ skipwhite

hi link namedOptionsViewDnssecLookasideOptDomain namedHL_String
syn match namedOptionsViewDnssecLookasideOptDomain contained 
\    /[0-9A-Za-z][-0-9A-Za-z\.\-_]\+/ 
\ nextgroup=namedOptionsViewDnssecLookasideOptTD
\ skipwhite

hi link namedOptionsViewDnssecLookasideOptAuto namedHL_Error
syn keyword namedOptionsViewDnssecLookasideOptAuto contained auto
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOptionsViewDnssecLookasideOpt namedHL_Type
syn keyword namedOptionsViewDnssecLookasideOpt contained no
\ skipwhite
\ nextgroup=namedSemicolon

" dnssec-lookaside [ auto | no | <domain_name> trusted-anchor <key_name>];
hi link namedOptionsViewDnssecLookasideKeyword namedHL_Option
syn keyword namedOptionsViewDnssecLookasideKeyword contained
\    dnssec-lookaside
\ skipwhite
\ nextgroup=
\    namedOptionsViewDnssecLookasideOpt,
\    namedOptionsViewDnssecLookasideOptDomain,
\    namedOptionsViewDnssecLookasideOptAuto
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection 

hi link namedOptionsViewBoolGroup namedHL_Option
syn keyword namedOptionsViewBoolGroup contained
\    allow-new-zones
\    auth-nxdomain 
\    check-wildcard 
\    dnsrps-enable
\    dnssec-accept-expired
\    dnssec-enable
\    empty-zone-enable
\    glue-cache
\ nextgroup=@namedClusterBoolean_SC
\ skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection 

hi link namedOptionsViewAMLGroup namedHL_Option
syn keyword namedOptionsViewAMLGroup contained
\    allow-query-cache
\    allow-query-cache-on
\    allow-recursion
\    allow-recursion-on
\ skipwhite
\ nextgroup=namedAMLSection
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedOptionsViewAttachCache namedHL_Option
syn keyword namedOptionsViewAttachCache contained attach-cache skipwhite
\ nextgroup=namedElementViewName,namedError
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedStmtOptionsViewNumbers namedHL_Option
syn keyword namedStmtOptionsViewNumbers contained
\    clients-per-query 
\    max-clients-per-query 
\ skipwhite
\ nextgroup=named_Number_SC
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedOptionsViewDnsrpsElement namedHL_String
syn region namedOptionsViewDnsrpsElement start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOptionsViewDnsrpsOptionsSection

syn region namedOptionsViewDnsrpsElement start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOptionsViewDnsrpsOptionsSection

syn region namedOptionsViewDnsrpsOptionsSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

hi link namedStmtOptionsViewDnsrpsOptions namedHL_Option
syn keyword namedStmtOptionsViewDnsrpsOptions contained
\    dnsrps-options
\ skipwhite
\ nextgroup=namedOptionsViewDnsrpsOptionsSection
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

syn match namedOptionsViewDenyAnswerElementDomainName /['"][_\-0-9A-Za-z\.]\{1,1024}['"]/
\ contained skipwhite skipempty 
\ contains=namedDomain
\ nextgroup=namedSemicolon

" deny-answer-addresses { <AML>; } [ except from { <domain_name>; }; } ];
syn region namedOptionsViewDenyAnswerExceptSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    named_E_ACLName_SC,
\    namedOptionsViewDenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedSemicolon

" deny-answer-addresses { <AML>; } [ except from { ... }; } ];
hi link namedOptionsViewDenyAnswerExceptKeyword namedHL_Option
syn match namedOptionsViewDenyAnswerExceptKeyword contained
\    /\(except\)\s\+\(from\)/
\ skipwhite
\ nextgroup=
\    namedOptionsViewDenyAnswerExceptSection,
\    namedSemicolon
 
" deny-answer-addresses { <AML>; } ...
syn region namedOptionsViewDenyAnswerAddrSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    named_E_ACLName_SC,
\    namedOptionsViewDenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedOptionsViewDenyAnswerExceptKeyword,
\    namedSemicolon

" deny-answer-addresses { } ...
hi link namedStmtOptionsViewDenyAnswerAddrKeyword namedHL_Option
syn keyword namedStmtOptionsViewDenyAnswerAddrKeyword contained 
\    deny-answer-addresses
\ skipwhite
\ nextgroup=namedOptionsViewDenyAnswerAddrSection
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

" deny-answer-aliases { <AML>; } ...
syn region namedOptionsViewDenyAnswerAliasSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=
\    named_E_ACLName_SC,
\    namedOptionsViewDenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedOptionsViewDenyAnswerExceptKeyword,
\    namedSemicolon

" deny-answer-aliases { } ...
hi link namedStmtOptionsViewDenyAnswerAliasKeyword namedHL_Option
syn keyword namedStmtOptionsViewDenyAnswerAliasKeyword contained 
\    deny-answer-aliases
\ skipwhite
\ nextgroup=namedOptionsViewDenyAnswerAliasSection
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

" disable-algorithms <name> { <algo_name>; ... };
hi link namedOptionsViewDisableAlgosElementName namedHL_String
syn match namedOptionsViewDisableAlgosElementName contained 
\   /['"]\?[a-zA-Z0-9\.\-_]\{1,64}['"]\?/
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOptionsViewDisableAlgosSection

" disable-algorithms <name> { ...; };
syn region namedOptionsViewDisableAlgosSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon

" disable-algorithms <name> { ... };
hi link namedOptionsViewDisableAlgosIdent namedHL_Identifier
syn match namedOptionsViewDisableAlgosIdent contained 
\   /[a-zA-Z0-9\.\-_]\{1,64}/
\ skipwhite
\ nextgroup=namedOptionsViewDisableAlgosSection

hi link namedOptionsViewDisableAlgosIdent namedHL_Identifier
syn match namedOptionsViewDisableAlgosIdent contained 
\   /"[a-zA-Z0-9\.\-_]\{1,64}"/
\ skipwhite
\ nextgroup=namedOptionsViewDisableAlgosSection

hi link namedOptionsViewDisableAlgosIdent namedHL_Identifier
syn match namedOptionsViewDisableAlgosIdent contained 
\   /'[a-zA-Z0-9\.\-_]\{1,64}'/
\ skipwhite
\ nextgroup=namedOptionsViewDisableAlgosSection

" disable-algorithms <name> ...
hi link namedStmtOptionsViewDisableAlgosKeyword namedHL_Option
syn keyword namedStmtOptionsViewDisableAlgosKeyword contained 
\    disable-algorithms
\ skipwhite skipempty
\ nextgroup=namedOptionsViewDisableAlgosIdent
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

" disable-ds-digests <name> ...
hi link namedStmtOptionsViewDisableDsDigestKywd namedHL_Option
syn keyword namedStmtOptionsViewDisableDsDigestKywd contained 
\    disable-ds-digests
\ skipwhite skipempty
\ nextgroup=namedOptionsViewDisableAlgosIdent
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedStmtOptionsViewDisEmptyZone namedHL_Option
syn keyword namedStmtOptionsViewDisEmptyZone contained 
\    disable-empty-zone 
\ nextgroup=namedElementZoneName,namedError
\ skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedOptionsViewDns64Element namedHL_Option
" dns64 <netprefix> { break-dnssec <boolean>; };
syn keyword namedOptionsViewDns64Element contained 
\    break-dnssec
\    recursive-only
\ skipwhite
\ nextgroup=@namedClusterBoolean


" dns64 <netprefix> { clients { xxx; }; };
syn region namedOptionsViewDns64ClientsSection contained start=+{+ end=+}+
\ skipwhite
\ contains=
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    named_E_ACLName_SC,
\    namedInclude,
\    namedComment 
\ nextgroup=namedSemicolon

" dns64 <netprefix> { suffix <ip_addr>; };
syn keyword namedOptionsViewDns64Element contained suffix
\ skipwhite
\ nextgroup=
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    named_E_ACLName_SC

" dns64 <netprefix> { break-dnssec <bool>; };
syn match namedOptionsViewDns64Element contained 
\    /\(break-dnssec\)\|\(recursive-only\)/
\ skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

" dns64 <netprefix> { mapped { ... }; };
syn keyword namedOptionsViewDns64Element contained 
\    clients
\    exclude
\    mapped
\ skipwhite
\ nextgroup=namedOptionsViewDns64ClientsSection

" dns64 <netprefix> { <AML>; };
syn region namedOptionsViewDns64Section contained start=+{+ end=+}+
\ skipwhite skipempty
\ contains=namedOptionsViewDns64Element
\ nextgroup=namedSemicolon

" dns64 <netprefix> { 
hi link namedOptionsViewDns64Ident namedError
syn match namedOptionsViewDns64Ident contained /[0-9a-fA-F:%\.\/]\{7,48}/
\ contained skipwhite skipempty
\ contains=namedIP4AddrPrefix,namedIP6AddrPrefix
\ nextgroup=namedOptionsViewDns64Section

" dns64 <netprefix> 
hi link namedStmtOptionsViewDns64 namedHL_Option
syn keyword namedStmtOptionsViewDns64 contained dns64
\ nextgroup=namedOptionsViewDns64Ident,namedError skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

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
\    namedStmtOptionsSection,
\    namedStmtViewSection

" dnssec-validation [ maintain | no-resign ];
hi link namedOptionsViewDnssecValidation namedHL_Option
syn keyword namedOptionsViewDnssecValidation contained 
\    dnssec-validation
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

" dnstap { ... };
hi link namedOptionsViewDnstapClauses namedHL_Builtin
syn keyword namedOptionsViewDnstapClauses contained
\    query
\    response
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOptionsViewDnstapOpts namedHL_Builtin
syn keyword namedOptionsViewDnstapOpts contained 
\    all 
\    auth
\    client
\    forwarder
\    resolver
\    update
\ skipwhite
\ nextgroup=namedOptionsViewDnstapClauses

syn region namedOptionsViewDnstapSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ nextgroup=namedSemicolon
\ contains=namedOptionsViewDnstapOpts

hi link namedOptionsViewDnstapKeyword namedHL_Option
syn keyword namedOptionsViewDnstapKeyword contained 
\    dnstap
\ skipwhite
\ nextgroup=namedOptionsViewDnstapSection
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedOptionsViewFetchQuotaParamsHigh namedHL_Number
syn match namedOptionsViewFetchQuotaParamsHigh contained
\    /\d\{1,10}\.\d/
\ skipwhite

hi link namedOptionsViewFetchQuotaParamsMed namedHL_Number
syn match namedOptionsViewFetchQuotaParamsMed contained
\    /\d\{1,10}\.\d/
\ skipwhite
\ nextgroup=namedOptionsViewFetchQuotaParamsHigh

hi link namedOptionsViewFetchQuotaParamsLow namedHL_Number
syn match namedOptionsViewFetchQuotaParamsLow contained
\    /\d\{1,10}\.\d/
\ skipwhite
\ nextgroup=namedOptionsViewFetchQuotaParamsMed

hi link namedOptionsViewFetchQuotaParamsRecalPerQueries namedHL_Number
syn match namedOptionsViewFetchQuotaParamsRecalPerQueries contained
\    /\d\{1,10}/
\ skipwhite
\ nextgroup=namedOptionsViewFetchQuotaParamsLow

hi link namedOptionsViewFetchQuotaParams namedHL_Option
syn keyword namedOptionsViewFetchQuotaParams contained fetch-quota-params
\ skipwhite
\ nextgroup=namedOptionsViewFetchQuotaParamsRecalPerQueries
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedOptionsViewFetchQuotaPersType namedHL_Builtin
syn keyword namedOptionsViewFetchQuotaPersType contained
\    fail
\    drop
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOptionsViewFetchQuotaPersValue namedHL_Number
syn match namedOptionsViewFetchQuotaPersValue contained
\    /\d\{1,10}/
\ skipwhite
\ nextgroup=namedOptionsViewFetchQuotaPersType

hi link namedOptionsViewFetchPers namedHL_Option
syn keyword namedOptionsViewFetchPers contained 
\    fetches-per-server
\    fetches-per-zone
\ skipwhite
\ nextgroup=namedOptionsViewFetchQuotaPersValue
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

" heartbeat-interval: range: 0-40320
hi link namedOV_HeartbeatIntervalValue namedHL_Option
syn match namedOV_HeartbeatIntervalValue contained
\ /\%(1440\)\|\%(14[0-3][0-9]\)\|\%(1[0-3][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_HeartbeatInterval namedHL_Option
syn keyword namedOV_HeartbeatInterval contained
\    heartbeat-interval
\ skipwhite
\ nextgroup=namedOV_HeartbeatIntervalValue
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn match namedOptionsZoneDialupOptBoolean contained /\S\+/
\ skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

hi link namedOptionsZoneDialupOptBuiltin namedHL_Builtin
syn match namedOptionsZoneDialupOptBuiltin contained 
\     /\%(notify\)\|\%(notify-passive\)\|\%(passive\)\|\%(refresh\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOptionsZoneDialup namedHL_Option
syn keyword namedOptionsZoneDialup contained dialup
\ skipwhite
\ nextgroup=
\    namedOptionsZoneDialupOptBuiltin,
\    namedOptionsZoneDialupOptBoolean
\ containedin=
\    namedStmtOptionsSection,
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

hi link namedOptionsZoneDnstapIdentity namedHL_Option
syn keyword namedOptionsZoneDnstapIdentity contained 
\    dnstap-identity
\ skipwhite
\ nextgroup=
\    namedOptionsDnstapIdentityOpts,
\    namedOptionsDnstapIdentityDomain
\ containedin=
\    namedStmtOptionsSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', and 'zone'  ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOVZ_AMLGroup namedHL_Option
syn keyword namedOVZ_AMLGroup contained
\    allow-notify
\    allow-query
\    allow-query-on
\    allow-transfer
\    allow-update
\    allow-update-forwarding
\ nextgroup=namedAMLSection skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
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
\ contains=namedIPwild,namedIP4Addr
\ nextgroup=
\    namedOptATSClausePort,
\    namedOptATSClauseDscp,
\    namedSemicolon
\ skipwhite

syn match namedOptATS_IP6wild /\S\+/ contained
\ contains=namedIPwild,namedIP6Addr
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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection
syn keyword namedOVZ_OptATS contained
\    alt-transfer-source
\ nextgroup=namedOptATS_IP4wild skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection

syn match namedAllowMaintainOff_SC contained /\S\+/
\ nextgroup=namedSemicolon
\ contains=namedAllowMaintainOff

hi link namedOVZ_AutoDNSSEC namedHL_Option
syn keyword namedOVZ_AutoDNSSEC contained auto-dnssec skipwhite
\ nextgroup=namedAllowMaintainOff_SC,namedComment,namedError 
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection 

hi link namedStmtOVZ_IgnoreWarnFail namedHL_Option
syn keyword namedStmtOVZ_IgnoreWarnFail contained 
\    check-dup-records
\    check-mx-cname
\    check-mx
\    check-srv-cnames
\ skipwhite
\ nextgroup=namedIgnoreWarnFail

hi link namedOVZ_DnskeyValidityDays namedHL_Number
syn match namedOVZ_DnsKeyValidityDays contained 
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedStmtOVZ_DnskeyValidity namedHL_Option
syn keyword namedStmtOVZ_DnskeyValidity contained 
\    dnskey-sig-validity
\ skipwhite
\ nextgroup=namedOVZ_DnsKeyValidityDays
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection 

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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
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
\    namedStmtOptionsSection, " inert since 9.5
\    namedStmtViewSection,  " inert since 9.5
\    namedStmtZoneSection   " inert since 9.5

hi link namedOVZ_BoolGroup namedHL_Option
syn keyword namedOVZ_BoolGroup contained 
\    check-sibling
\    check-integrity
\    dnssec-dnskey-kskonly
\    dnssec-secure-to-insecure
\    inline-signing
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC
\ containedin=
\    namedStmtViewSection,
\    namedStmtOptionsSection,
\    namedStmtZoneSection   " zone obsoleted by 9.15(?)

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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection
" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx

hi link namedOVZ_Forwarders_Opt_PortNumber namedHL_Error
syn match namedOVZ_Forwarders_Opt_PortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ contains=namedPort
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
\ contains=namedIP6Addr
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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
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
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection

hi link namedOVZ_ChecksIgnWarnFail namedHL_Option
syn keyword namedOVZ_ChecksIgnWarnFail contained
\    check-spf
\ nextgroup=namedIgnoreWarnFail,namedError 
\ skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', 'view', and 'zone' ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'server'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtOptAVS namedHL_String
" syn match namedStmtOptAVS contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match namedStmtOptAVS /aaaa\s*;/ contained skipwhite
syn match namedStmtOptAVS /AAAA\s*;/ contained skipwhite
syn match namedStmtOptAVS /a6\s*;/ contained skipwhite
syn match namedStmtOptAVS /A6\s*;/ contained skipwhite

hi link namedStmtOptionsServerViewOptAV6S namedHL_Option
syn keyword namedStmtOptionsServerViewOptAV6S contained
\    allow-v6-synthesis
\ nextgroup=namedStmtOptAVS 
\ skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtOVZ_OptAN namedHL_Option
syn keyword namedStmtOVZ_OptAN contained
\    also-notify
\ nextgroup=namedElementIP4AddrList,namedInclude,namedComment,namedError
\ skipwhite

" + these keywords are contained within `update-policy' section only
" syn keyword namedIntKeyword contained grant nextgroup=namedString skipwhite
" syn keyword namedIntKeyword contained name self subdomain wildcard nextgroup=namedString skipwhite
" syn keyword namedIntKeyword TXT A PTR NS SOA A6 CNAME MX ANY skipwhite
" 
" syn keyword namedZoneOpt contained update-policy
" \  nextgroup=namedIntSection skipwhite

" syn match namedAMElement contained /.*\s*;/ 
" \ contains=namedACLName,namedComment,namedError skipwhite

syn match namedOptPortKeyval contained /port\s\+\d\\+/ms=s+5 contains=namedPortVal

syn region namedPortSection contained start=+{+ end=+}+ 
\ contains=
\    namedElementPortWild,
\    namedParenError,
\    namedComment,
\    namedInclude
\ skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtViewZoneIgnoreWarnFail namedHL_Option
syn keyword namedStmtViewZoneIgnoreWarnFail contained 
\    check-names
\ skipwhite
\ nextgroup=namedIgnoreWarnFail

hi link namedVZ_Ixfr_From_Diff namedHL_Option
syn keyword namedVZ_Ixfr_From_Diff contained ixfr-from-differences skipwhite
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC
\ containedin=
\    namedStmtViewSection,
\    namedStmtZoneSection

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections ({ ... };) of statements go below here
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options { <options_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmtOptionsSection contained start=+{+ end=+}+ 
\ skipwhite
\ contains=
\    namedStmtOptionsBoolGroup,
\    namedStmtOptionsMinuteGroup,
\    namedO_Keywords,
\    namedStmtOptionsServerViewOptAV6S,
\    namedStmtOVZ_IgnoreWarnFail,
\    namedStmtOVZ_OptAN,
\    namedInclude,
\    namedComment,
\    namedParenError
\ nextgroup=namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmtServerIdent> { <namedStmtServerKeywords>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmtServerSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ contains=
\    namedStmtOptionsServerViewOptAV6S,
\    namedStmtServerBoolGroup,
\    namedComment,
\    namedInclude
\ nextgroup=namedSemicolon
" \ contains=    namedStmtOVZ_OptAN,


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmtServerIdent> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn match namedStmtServerIdent contained
\ /[0-9]\{1,3}\(\.[0-9]\{1,3}\)\{0,3}\([\/][0-9]\{1,3}\)\{0,1}/
\ skipwhite
\ nextgroup=
\    namedStmtServerSection,
\    namedComment,
\    namedInclude,
\    namedError 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" view <namedViewIdent> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmtViewSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedStmtViewBoolGroup,
\    namedStmtViewSecondGroup,
\    namedStmtViewMinuteGroup,
\    namedStmtViewIgnoreWarnFail,
\    namedStmtViewFilespecGroup,
\    namedStmtViewSizeSpecGroup,
\    namedStmtViewKeywords,
\    namedStmtOVZ_OptAN,
\    namedStmtOptionsServerViewOptAV6S,
\    namedStmtOVZ_IgnoreWarnFail,
\    namedStmtViewZoneIgnoreWarnFail,
\    namedInclude,namedComment,namedParenError

syn match namedViewIdent contained /\i\+/ skipwhite
\ nextgroup=namedStmtViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" zone <namedZoneIdent> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmtZoneSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedStmtZoneKeywords,
\    namedStmtOVZ_OptAN,
\    namedStmtOVZ_IgnoreWarnFail,
\    namedStmtViewZoneIgnoreWarnFail,
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

hi link namedZoneIdent namedHL_Identifier
syn match namedZoneIdent contained /\S\+/ 
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
syn match namedStmtKeyword /\_^\s*\<acl\>/
\ skipempty skipnl skipwhite
\ nextgroup=namedStmtACLIdent,

syn match namedStmtKeyword /\_^\s*\<controls\>/
\ skipempty skipnl skipwhite
\ nextgroup=namedStmtControlsSection,

syn match namedStmtKeyword /\_^\s*\<dlz\>/
\ skipempty skipnl skipwhite
\ nextgroup=namedStmtDlzIdent,

syn match namedStmtKeyword /\_^\s*\<dyndb\>/
\ skipempty skipnl skipwhite
\ nextgroup=namedStmtDyndbIdent,

syn match namedStmtKeyword /\_^\s*\<key\>/
\ nextgroup=namedStmtKeyIdent skipempty skipwhite

syn match namedStmtKeyword /\_^\s*\<logging\>/
\ nextgroup=namedStmtLoggingSection skipempty skipwhite

syn match namedStmtKeyword /\_^\s*\<managed-keys\>/
\ nextgroup=namedStmtManagedKeysSection skipempty skipwhite

syn match namedStmtKeyword /\_^\s*\<masters\>/ 
\ skipwhite skipnl skipempty 
\ nextgroup=
\    namedStmtMastersIdent,
\    namedComment, 
\    namedInclude,
" \ namedError prevents a linefeed between 'master' and '<master_name'

syn match namedStmtKeyword /\_^\s*\<options\>/
\ nextgroup=namedStmtOptionsSection skipempty skipwhite

syn match  namedStmtKeyword /\_^\s*\<server\>/
\ nextgroup=namedStmtServerIdent,namedComment 
\ skipempty skipwhite

syn match namedStmtKeyword /\_^\s*\<statistics-channels\>/
\ nextgroup=namedIntIdent 
\ skipempty skipwhite

syn match namedStmtKeyword /\_^\s*\<trusted-keys\>/
\ skipempty skipwhite
\ nextgroup=namedIntSection 

" view <namedViewIdent> { ... };  
syn match namedStmtKeyword /\_^\s*\<view\>/ 
\ skipwhite
\ nextgroup=namedViewIdent 

" TODO: namedStmtError, how to get namedHL_Error to appear
" zone <namedZoneIdent> { ... };
syn match namedStmtKeyword /\_^\_s*\<zone\>/
\ nextgroup=namedZoneIdent,namedComment,namedStmtError skipempty skipwhite

let &cpoptions = s:save_cpo
unlet s:save_cpo

let b:current_syntax = 'named'

if main_syntax == 'bind-named'
  unlet main_syntax
endif

" vim: ts=4
