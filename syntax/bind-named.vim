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
" Basic highlighting is covered for all Bind configuration options.
" Only normal (default to white) highlighting is used to 
" show 'undetected' Bind syntax.  Every valid words get colorized.
" Every character-valid values get colorized, no range-checking here.
"
" New Bind 9.13+ terminologies here:
"    Stmt - top-level statement (formerly 'clause' in Bind 4 to 9.11)
"    Opt  - an option statement within each of its top-level statement
"    Clause - keyword used within each of its option statement
"
" Clarification; There is an 'Options' notation for just one of 
" the top-level statements, and then there is an 'Opt' notation 
" under each top-level statement. Opt <> Options.
"
" iskeyword is used for Bind builtins ONLY because they transcend all syntax
" processing (including nested curly-braces sections, so you don't want to 
" be using the bruteforce above-all-syntax Vim keyword for too much else 
" other than Bind 'builtins'.
" Bind builtins are 'any', 'none', 'localhost', 'localnets' because we shouldn't
" be using those builtins anywhere else as an identifier or a label names 
" either.  ACL names are identifier and are not tracked nor correlated within 
" Vim syntax highlighting effort, just highlighted.  Another reason why you
" shouldn't use period or semicolon in ACL names because it confuses IP 
" address syntax processing.
"
" isident is used for the most-lax naming convention of all Bind identifiers, 
" which is ordered from VIEW_name, Zone_name, ACL_name, master_name, and then 
" to the most strictest naming convention, domain_name.
" charset_view_name_base = alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed
" charset_zone_name_base = alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed

" charset_acl_name_base =  alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed
" charset_master_name = alphanums + '_-.'
" charset_fqdn_name_base = alphanums + '_-.'




" quit when a syntax file was already loaded
if !exists("main_syntax")
  if exists('b:current_syntax')
    finish
  endif
  let main_syntax='bind-named'
endif

syn case match

setlocal iskeyword=.,-,48-58,A-Z,a-z

" ACL name : alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed 

setlocal isident=.,-,48-58,A-Z,a-z,_

syn sync match namedSync grouphere NONE "^(zone|controls|acl|key)"

let s:save_cpo = &cpoptions
set cpoptions-=C

" First-level highlighting

hi link namedComment	namedHLComment
hi link namedInclude	namedHLInclude

" Bind Statements 
" (used to be called 'clause' back in Bind 4,
"  Bind 8, and some earlier Bind 9 days
"  but that has been swapped with 'statement')
hi link namedACLKeyword	namedHLStatement
hi link namedControlsKeyword	namedHLStatement
hi link namedDLZKeyword	namedHLStatement
hi link namedKeyKeyword	namedHLStatement
hi link namedLoggingKeyword	namedHLStatement
hi link namedManagedKeysKeyword	namedHLStatement
hi link namedLWRESKeyword	namedHLStatement  " gone in 9.13.0 
hi link namedMastersKeyword	namedHLStatement
hi link namedStmtOptionsKeywords	namedHLStatement
hi link namedStmtServerKeywords	namedHLStatement
hi link namedStatisticsChannelsKeyword	namedHLStatement
hi link namedTrustedKeysKeyword	namedHLStatement
hi link namedStmtViewKeywords	namedHLStatement
hi link namedStmtZoneKeywords	namedHLStatement

" Second-level highlighting

hi link namedACLIdent	namedHLIdentifier
hi link namedACLName	namedHLIdentifier
hi link namedChannelIdent	namedHLIdentifier
hi link namedChannelName	namedHLIdentifier
hi link namedKeyIdent	namedHLIdentifier
hi link namedKeyName	namedHLIdentifier
hi link namedStmtMastersIdent	namedHLIdentifier
hi link namedMasterName	namedHLIdentifier
hi link namedElementMasterName	namedHLIdentifier
hi link namedStmtServerIdent namedHLIdentifier
hi link namedServerName	namedHLIdentifier
hi link namedViewIdent	namedHLIdentifier
hi link namedViewName	namedHLIdentifier
hi link namedZoneIdent	namedHLIdentifier
hi link namedZoneName	namedHLIdentifier
hi link namedDomain	namedHLIdentifier
hi link namedString	namedHLString
hi link namedGroupID	namedHLNumber
hi link namedUserID	namedHLNumber
hi link namedFilePerm   namedHLNumber
hi link namedWildcard   namedHLNumber

" Third-level highlighting
"   - Type
"   - Type
"   - Number
"   - Identifier
hi link namedQuotedDomain	namedDomain
hi link namedDNSSECLookaside	namedHLNumber
hi link namedDSS_OptGlobalPort	namedKeyword
hi link namedPortKeyword	namedKeyword
hi link namedPortWild    	namedWildcard
hi link namedWildcard	namedHLNumber
hi link namedFilesCount	namedHLNumber
hi link namedTypeNone	namedIdentifier

hi link namedClauseKeyword	namedHLOption
hi link namedKeyword	namedHLOption
hi link namedIntKeyword	namedHLOption

hi link namedTypeMinutes	namedHLNumber
hi link namedPort	namedHLNumber
hi link namedHexNumber	namedHLNumber
hi link namedIP4Addr	namedHLNumber
hi link namedIPwild	namedHLNumber
hi link namedNumber	namedHLNumber
hi link namedDSCP	namedHLNumber
hi link namedTypeBase64	namedHLIdentifier

hi link namedKeyAlgorithmName namedHLNumber
hi link namedKeySecretValue namedTypeBase64

hi link namedTypeBool	namedHLType
hi link namedQSKeywords	namedHLType
hi link namedCNKeywords	namedHLType
hi link namedLogCategory	namedHLType
hi link namedTypeZone	namedHLType
hi link namedIgnoreWarnFail	namedHLType
hi link namedAllowMaintainOff	namedHLType

hi link namedIdentifier	namedHLClause
hi link namedControlsInet	namedHLClause
hi link namedControlsPort	namedHLClause
hi link namedControlsAllow	namedHLClause
hi link namedControlsKey	namedHLClause

hi link namedQuotedString	namedHLString
hi link namedSingleQuotedString	namedHLString
hi link namedDoubleQuotedString	namedHLString
hi link namedFilespec	namedHLString

hi link namedTypeCheckNamesZone namedHLSpecial
hi link namedStmtViewCheckNames namedHLOption

hi link namedNotBool	namedHLError
hi link namedNotNumber	namedHLError
hi link namedNotSemicolon	namedHLError
hi link namedParenError	namedHLError
hi link namedNotParenError	namedHLError
hi link namedEParenError	namedHLError
hi link namedIllegalDom	namedHLError
hi link namedIPerror	namedHLError
hi link namedSpareDot	namedHLError
hi link namedError	namedHLError

hi link namedSpecial	namedHLSpecial
hi link namedHLBuiltin	namedHLSpecial

hi link namedTypeBool_SC	namedHLTBool


" BIND configuration file
" Down-Top syntax approach.
" Smallest granular definition starts here.
" Largest granular definition goes at the bottom.
" Pay attention to tighest-pattern-first ordering of syntax 
" match/region/keyword having same identifers (First-match method used).

" 'uncontained' statements are the ones used GLOBALLY

" Builtins are global as to ensure non-accidential re-usage
hi link namedBuiltinsKeyword namedHLSpecial
syn keyword namedBuiltinsKeyword any none localhost localnets

hi link namedToDo Todo
syn keyword namedToDo xxx contained XXX FIXME TODO TODO: FIXME:

syn match namedComment "//.*" contains=namedToDo
syn match namedComment "#.*" contains=namedToDo
syn region namedComment start="/\*" end="\*/" contains=namedToDo
syn match namedInclude /\_s*include/ 
\ nextgroup=namedFilespec,namedError 
\ skipwhite

" 'contained' statements are confined to within their parent's region

syn match namedSemicolon contained /\(;\+\s*\)\+/ skipwhite
syn match namedNotSemicolon contained /[^;]\+/he=e-1 skipwhite
syn match namedError /[^;{#]$/

syn match namedNotNumber contained "[^  0-9;]\+"
syn match namedNumber contained "\d\+"
syn match namedGroupID contained "[0-6]\{0,1}[0-9]\{1,4}"
syn match namedUserID contained "[0-6]\{0,1}[0-9]\{1,4}"
syn match namedFilePerm contained "[0-7]\{3,4}"
syn match namedDSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/

syn match namedPort contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
syn match namedPortWild contained /\*/
syn match namedPortWild contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link namedElementPortWild namedHLNumber
syn match namedElementPortWild contained /\*\s*;/ skipwhite
"syn match namedElementPortWild contained /\d\{1,5}\s*;/hs=s,me=e-1
syn match namedElementPortWild contained /\%([1-9]\|[1-5]\?[0-9]\{2,4}\|6[1-4][0-9]\{3}\|65[1-4][0-9]\{2}\|655[1-2][0-9]\|6553[1-5]\)\s*;/he=e-1
\ contains=namedPort skipwhite

syn match namedWildcard contained /\*/

syn match namedNotBool contained "[^  ;]\+"
syn match namedTypeBool contained /\cyes/
syn match namedTypeBool contained /\cno/
syn match namedTypeBool contained /\ctrue/
syn match namedTypeBool contained /\cfalse/
syn keyword namedTypeBool contained 1
syn keyword namedTypeBool contained 0
syn match namedTypeBool_SC contained /\i\+\s*;/
\ contains=namedTypeBool

hi link namedIP4Addr namedHLNumber
hi link namedIP4AddrPrefix namedHLNumber
hi link namedElementIP4Addr namedHLNumber
hi link namedElementIP4AddrPrefix namedHLNumber
hi link namedIP6Addr namedHLNumber
hi link namedIP6AddrPrefix namedHLNumber
hi link namedElementIP6Addr namedHLNumber
hi link namedElementIP6AddrPrefix namedHLNumber

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
syn region namedString start=/"/ skip=/\\"/ end=/"/ contained
syn region namedDoubleQuotedString start=/"/ skip=/\\"/ end=/"/ contained
syn region namedSingleQuotedString start=/'/ skip=/\\'/ end=/'/ contained
syn region namedQuotedString start=/"/ skip=/\\"/ end=/"/ contained
syn region namedQuotedString start=/'/ skip=/\\'/ end=/'/ contained

" --- Other variants of strings
"  filespec = '_-.+~@$%^&*()=[]\\|:<>`?'  " no curly braces nor semicolon
"  filespec = can be unquoted but no space char allowed
" syn match namedFilespec contained /[\f^;]\+/ skipwhite
syn match namedFilespec contained /[{}<>\|:;"'a-zA-Z0-9_\.\-\/\\]\+[^;]/ contains=namedQuotedString skipwhite skipempty skipnl

" -- Identifier
syn match namedACLName contained /\<[0-9a-zA-Z\-_\[\]\<\>\{\}]\{1,64}/ skipwhite
syn match namedElementACLName /\<[0-9a-zA-Z\-_\[\]\<\>\{\}]\{1,64}\s*;/he=e-1
\ contained skipwhite
\ contains=namedACLName

syn match namedTypeBase64 contained /\<[0-9a-zA-Z\/\-\_\,+=]\{1,4096}/
syn match namedKeySecretValue contained /\<[0-9a-zA-Z\\+=]\{1,4096}\s*;/he=e-1 skipwhite
syn match namedKeyName contained /\<[0-9a-zA-Z\-_]\{1,64}/ skipwhite
syn match namedKeyAlgorithmName contained /\<[0-9A-Za-z\-_]\{1,4096}/ skipwhite
syn match namedMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}/ skipwhite
syn match namedElementMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}\s*;/he=e-1 skipwhite

syn match namedViewName contained /.\+;/he=e-1 skipwhite
syn match namedZoneName contained /\i\+;/he=e-1 skipwhite
syn match namedDLZName contained /\i\+;/he=e-1 skipwhite

syn match namedFQDN contained /\i\+;/he=e-1 skipwhite

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
syn match namedNotParenError contained +\([^{]\|$\)+
syn match namedEParenError contained +{+
syn match namedParenError +}\([^;]\|$\)+


" --- IPs & Domains


syn match namedIPwild contained /\*/
syn match namedSpareDot contained /\./
syn match namedSpareDot_SC contained /\.\s\+;/



syn match namedDomain contained /"\."/ms=s+1,me=e-1 skipwhite
syn match namedDomain contained /\<[0-9A-Za-z][-0-9A-Za-z.]\+\>/ nextgroup=namedSpareDot
syn match namedQuotedDomain contained /'\<[0-9A-Za-z][-0-9A-Za-z.]\+\>./ nextgroup=namedSpareDot
syn match namedQuotedDomain contained /\"\<[0-9A-Za-z][-0-9A-Za-z.]\+\>\"/ nextgroup=namedSpareDot

" -- Vim syntax clusters
syntax cluster namedClusterCommonNext contains=namedComment,namedInclude,namedError
syntax cluster namedClusterBoolean_SC contains=namedTypeBool_SC,namedNotBool
syntax cluster namedClusterBoolean contains=namedTypeBool,namedNotBool,@namedClusterCommonNext
syntax cluster namedDomainFQDNCluster contains=namedDomain,namedError
syn cluster namedCommentGroup contains=namedToDo


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedTypeSizeSpec namedHLBuiltin
syn match namedTypeSizeSpec /unlimited\s*;/ contained skipwhite
syn match namedTypeSizeSpec /default\s*;/ contained skipwhite
hi link namedTypeSizeSpec namedHLNumber
syn match namedTypeSizeSpec /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/ contained skipwhite

syn region namedElementIP4AddrList contained start=+{+ end=+}\s*;+he=e-1
\ contains=namedElementIP4Addr,namedIPerror,namedParenError,namedComment

" AML Section/Elements
syn region namedElementAMLSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ contains=
\    namedInclude,
\    namedComment,
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    namedElementACLName
\ nextgroup=
\    namedSemicolon,
\    namedParenError,
\    namedError

syn region namedAMLSection contained start=/{/ end=/}/
\ contains=
\    namedElementIP6AddrPrefix,
\    namedElementIP6Addr,
\    namedElementIP4AddrPrefix,
\    namedElementIP4Addr,
\    namedElementACLName,
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

syn match namedStmtACLIdent /[0-9a-zA-Z\-_\.]\{1,64}/ 
\ contained skipwhite
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
" syn keyword namedControlsKeyword contained inet containedin=namedClause
" syn keyword namedControlsKeyword contained unix containedin=namedClause
" + these keywords are contained within `controls' section only
" syn keyword namedIntKeyword contained unix nextgroup=namedString skipwhite
" syn keyword namedIntKeyword contained port perm owner group nextgroup=namedNumber,namedNotNumber skipwhite
" syn keyword namedIntKeyword contained allow nextgroup=namedIntSection skipwhite

syn match namedControlsOptReadonlyBool /\i/ contained skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedControlsOptReadonlyKeyword namedHLOption
syn match namedControlsOptReadonlyKeyword /read\-only/ contained skipwhite
\ nextgroup=
\    namedControlsOptReadonlyBool,
\    namedError

syn match namedControlsUnixOptKeysElement /[a-zA-Z0-9_\-\.]\+/
\ contained 
\ contains=namedKeyName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError
\ containedin=
\    namedControlsUnixOptKeysSection

syn region namedControlsUnixOptKeysSection start=+{+ end=+}+
\ contained skipwhite
\ contains=namedControlsUnixOptKeysElement
\ nextgroup=
\    namedControlsOptReadonlyKeyword,
\    namedSemicolon,
\    namedError

hi link namedControlsUnixOptKeysKeyword namedHLOption
syn match namedControlsUnixOptKeysKeyword /keys/ contained skipwhite
\ nextgroup=namedControlsUnixOptKeysSection

syn match namedControlsUnixOptGroupInteger /\d\+/ contained skipwhite
\ contains=namedGroupID
\ nextgroup=
\     namedControlsOptReadonlyKeyword,
\     namedControlsUnixOptKeysKeyword,
\     namedSemicolon,
\     namedError

hi link namedControlsUnixOptGroupKeyword namedHLOption
syn match namedControlsUnixOptGroupKeyword /group/ contained skipwhite
\ nextgroup=namedControlsUnixOptGroupInteger,namedError

syn match namedControlsUnixOptOwnerInteger /\d\+/ contained skipwhite
\ contains=namedUserID
\ nextgroup=namedControlsUnixOptGroupKeyword,namedError

hi link namedControlsUnixOptOwnerKeyword namedHLOption
syn match namedControlsUnixOptOwnerKeyword /owner/ contained skipwhite
\ nextgroup=namedControlsUnixOptOwnerInteger,namedError

syn match namedControlsUnixOptPermInteger /\d\+/ contained skipwhite
\ contains=namedFilePerm
\ nextgroup=namedControlsUnixOptOwnerKeyword,namedError

hi link namedControlsUnixOptPermKeyword namedHLOption
syn match namedControlsUnixOptPermKeyword /perm/ contained skipwhite
\ nextgroup=namedControlsUnixOptPermInteger,namedError

" Dirty trick, use a single '"' char for a string match
hi link namedControlsUnixOptSocketName namedHLNumber
syn match namedControlsUnixOptSocketName /["']/
\ contained
\ contains=namedFilespec
\ nextgroup=
\     namedControlsUnixOptPermKeyword,
\     namedControlsOptReadonlyKeyword,
\     namedSemicolon,
\     namedError
\ containedin=namedStmtControlSection

hi link namedControlsClauseUnix namedHLOption
syn match namedControlsClauseUnix contained /unix/
\ skipwhite skipnl skipempty
\ nextgroup=namedControlsUnixOptSocketName
\ containedin=namedStmtControlSection

hi link namedControlsInetOptReadonlyBool namedHLOption
syn match namedControlsInetOptReadonlyBool contained /\i/
\ skipwhite skipnl skipempty
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

hi link namedControlsInetOptReadonlyKeyword namedHLOption
syn match namedControlsInetOptReadonlyKeyword contained /read\-only/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedControlsInetOptReadonlyBool

syn region namedControlsInetAMLSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    namedElementIP6Addr,
\    namedElementIP4Addr,
\    namedElementACLName,
\    namedSemicolon,
\    namedInclude,
\    namedComment
\ nextgroup=
\    namedControlsInetOptReadonlyKeyword,
\    namedControlsUnixOptKeysKeyword,
\    namedSemicolon

hi link namedControlsInetOptAllowKeyword namedHLOption
syn match namedControlsInetOptAllowKeyword contained /\<allow\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedControlsInetAMLSection,namedComment

hi link namedControlsInetOptPortWild namedHLBuiltin
syn match namedControlsInetOptPortWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedControlsInetOptAllowKeyword

hi link namedControlsInetOptPortNumber namedHLNumber
syn match namedControlsInetOptPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedControlsInetOptAllowKeyword

hi link namedControlsInetOptPortKeyword namedHLOption
syn match namedControlsInetOptPortKeyword contained /port/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedControlsInetOptPortWild,
\    namedControlsInetOptPortNumber


hi link namedControlsInetOptIPaddrWild namedHLBuiltin
syn match namedControlsInetOptIPaddrWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedControlsInetOptPortKeyword,
\    namedControlsInetOptAllowKeyword

" hi link namedControlsInetOptIPaddr namedHLNumber
syn match namedControlsInetOptIPaddr contained /[0-9a-fA-F\.:]\{3,45}/ 
\ skipwhite skipnl skipempty
\ contains=namedIP6Addr,namedIP4Addr
\ nextgroup=
\    namedControlsInetOptPortKeyword,
\    namedControlsInetOptAllowKeyword

hi link namedControlsClauseInet namedHLOption
syn match namedControlsClauseInet contained /inet/
\ skipnl skipempty skipwhite 
\ containedin=namedStmtControlSection
\ nextgroup=
\    namedControlsInetOptIPaddrWild,
\    namedControlsInetOptIPaddr

syn region namedStmtControlsSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ contains=
\    namedControlsClauseInet,
\    namedControlsClauseUnix,
\    namedComment,
\    namedInclude
\ nextgroup=
\    namedSemicolon,

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'key' statement
" 
" key <key_name> { algorithm <string>; secret <string>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedKeyElementSecretValue namedTypeBase64
syn match namedKeyElementSecretValue contained skipwhite /\<\S*[^;]\{1}/he=e-2
\ contains=namedTypeBase64
\ nextgroup=namedSemicolon,namedError

hi link namedKeyElementSecretKeyword namedHLOption
syn match namedKeyElementSecretKeyword /secret/ contained skipwhite
\ nextgroup=namedKeyElementSecretValue,namedError

syn match namedKeyElementAlgorithmName contained skipwhite /[a-zA-Z0-9\-_\.]\{1,128}\s*;/he=e-1
\ contains=namedKeyAlgorithmName
\ nextgroup=namedKeyElementSecretKeyword,namedError

hi link namedKeyElementAlgorithmKeyword namedHLOption
syn match namedKeyElementAlgorithmKeyword contained skipwhite /algorithm/
\ nextgroup=namedKeyElementAlgorithmName,namedError

syn region namedStmtKeySection start=+{+ end=+}+
\ contained skipwhite skipempty
\ contains=
\    namedKeyElementAlgorithmKeyword
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedStmtKeyIdent namedHLIdentifier
syn match namedStmtKeyIdent contained skipwhite /\i/
\ contains=namedKeyName
\ nextgroup=namedStmtKeySection,namedNotParem,namedError

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'managed-keys' statement
"
" managed-keys { string string integer integer integer quoted_string; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedManagedKeysElementKeySecret namedKeySecretValue
syn match namedManagedKeysElementKeySecret /["'0-9A-Za-z]\{1,1024}/ 
\ contains=namedKeySecretValue
\ contained skipwhite
\ skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon,namedError

hi link namedManagedKeysElementAlgorithmType namedHLNumber
syn match namedManagedKeysElementAlgorithmType contained skipwhite /\d\{1,3}/
\ skipempty
\ nextgroup=namedManagedKeysElementKeySecret,namedError

hi link namedManagedKeysElementProtocolType namedHLNumber
syn match namedManagedKeysElementProtocolType contained skipwhite /\d\{1,3}/
\ skipempty
\ nextgroup=namedManagedKeysElementAlgorithmType,namedError

hi link namedManagedKeysElementFlagType namedHLNumber
syn match namedManagedKeysElementFlagType contained skipwhite /\d\{1,3}/
\ skipempty
\ nextgroup=namedManagedKeysElementProtocolType,namedError

hi link namedManagedKeysElementInitialKey namedHLNumber
syn match namedManagedKeysElementInitialKey /[0-9A-Za-z][-0-9A-Za-z.]\{1,1024}/ 
\ contained skipwhite skipempty
\ contains=namedString
\ nextgroup=namedManagedKeysElementFlagType,namedError

hi link namedManagedKeysElementDomainName namedHLIdentifier
syn match namedManagedKeysElementDomainName /[0-9A-Za-z][-0-9A-Za-z.]\{1,1024}/
\ contains=namedDomain
\ contained skipwhite skipempty 
\ nextgroup=namedManagedKeysElementInitialKey,namedError

syn region namedStmtManagedKeysSection start=+{+ end=+}+
\ contained skipwhite skipempty
\ contains=namedManagedKeysElementDomainName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

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
hi link namedLoggingCategoryChannelName namedHLIdentifier
syn match namedLoggingCategoryChannelName contained /\i\+/ skipwhite
\ contains=namedString
\ containedin=namedLoggingCategorySection

syn region namedLoggingCategorySection contained start=+{+ end=+}+ 
\ skipwhite
\ contains=namedLoggingCategoryChannelName
\ nextgroup=namedSemicolon

hi link namedLoggingCategoryBuiltins namedHLBuiltin
syn keyword namedLoggingCategoryBuiltins contained skipwhite 
\    client cname config database default delegation-only dnssec dispatch
\    dnstap edns-disabled general lame-servers
\    network notify nsid queries query-errors rate-limit resolver
\    rate-limit resolver rpz security serve-stale spill 
\    trust-anchor-telemetry unmatched update update-security
\    xfer-in xfer-out zoneload 
\ nextgroup=namedLoggingCategorySection
\ containedin=namedStmtLoggingSection

hi link namedLoggingCategoryCustom namedHLIdentifier
syn match namedLoggingCategoryCustom contained skipwhite /\i\+/
\ containedin=namedStmtLoggingSection

syn match namedLoggingCategoryIdent /\i\+/ skipwhite contained
\ contains=namedLoggingCategoryBuiltins,namedLoggingCategoryCustom
\ nextgroup=namedLoggingCategorySection,namedError
\ containedin=namedStmtLoggingSection

hi link namedLoggingOptCategoryKeyword namedHLOption
syn match namedLoggingOptCategoryKeyword contained skipwhite /category/
\ nextgroup=namedLoggingCategoryIdent,namedError skipwhite
\ containedin=namedStmtLoggingSection

" logging { channel xxxxx { ... }; };

hi link namedLoggingChannelSeverityDebugValue namedHLNumber
syn match namedLoggingChannelSeverityDebugValue /[0-9]\{1,5}/ 
\ contained skipwhite 
\ nextgroup=namedComment,namedSemicolon,namedNotSemicolon,namedError

hi link namedLoggingChannelSeverityDebug namedHLBuiltin
syn match namedLoggingChannelSeverityDebug /debug\s*;/he=e-1
syn match namedLoggingChannelSeverityDebug /debug\s*/
\ nextgroup=
\    namedLoggingChannelSeverityDebugValue,
\    namedComment,
\    namedSemicolon,
\    namedNotSemicolon_SC,
\    namedNotComment,
\    namedError
hi link namedLoggingChannelSeverityInfo namedHLBuiltin
syn match namedLoggingChannelSeverityInfo /info\s*;/he=e-1
\ contained skipwhite
\ nextgroup=namedError
hi link namedLoggingChannelSeverityNotice namedHLBuiltin
syn match namedLoggingChannelSeverityNotice /notice\s*;/he=e-1
\ contained skipwhite
\ nextgroup=namedError
hi link namedLoggingChannelSeverityWarning namedHLBuiltin
syn match namedLoggingChannelSeverityWarning /warning\s*;/he=e-1 
\ contained skipwhite
\ nextgroup=namedError
hi link namedLoggingChannelSeverityError namedHLBuiltin
syn match namedLoggingChannelSeverityError /error\s*;/he=e-1 
\ contained skipwhite
\ nextgroup=namedError
hi link namedLoggingChannelSeverityCritical namedHLBuiltin
syn match namedLoggingChannelSeverityCritical /critical\s*;/he=e-1 
\ contained skipwhite
\ nextgroup=namedError
hi link namedLoggingChannelSeverityDynamic namedHLBuiltin
syn match namedLoggingChannelSeverityDynamic /dynamic\s*;/he=e-1 
\ contained skipwhite
\ nextgroup=namedError

hi link namedLoggingChannelOptNull namedHLClause
syn keyword namedLoggingChannelOptNull null contained skipwhite
\ nextgroup=namedComment,namedSemicolon,namedNotSemicolon,namedError
syn keyword namedLoggingChannelOptNull stderr contained skipwhite
\ nextgroup=namedSemicolon,namedNotSemicolon,namedComment,namedError

hi link namedLoggingChannelOpts namedHLOption
syn match namedLoggingChannelOpts contained skipwhite 
\    /\(buffered\)\|\(print\-category\)\|\(print\-severity\)/
\ nextgroup=@namedClusterBoolean_SC,namedError

" BUG: You can specify 'severity' twice on same line before semicolon
hi link namedLoggingChannelOptSeverity namedHLOption
syn match namedLoggingChannelOptSeverity contained /severity/ 
\ skipwhite skipempty
\ nextgroup= 
\    namedLoggingChannelSeverityDebug,
\    namedLoggingChannelSeverityInfo,
\    namedLoggingChannelSeverityNotice,
\    namedLoggingChannelSeverityWarning,
\    namedLoggingChannelSeverityError,
\    namedLoggingChannelSeverityCritical,
\    namedLoggingChannelSeverityDynamic,
\    namedComment,
\    namedError

" hi link namedLoggingChannelSyslogFacilityKern namedHLBuiltin
" syn keyword namedLoggingChannelSyslogFacilityKern kern contained skipwhite
" \ nextgroup=namedSemicolon,namedNotSemicolon,namedComment,namedError

hi link namedLoggingChannelSyslogFacility namedHLBuiltin
syn match namedLoggingChannelSyslogFacility 
\ /\<\(\(user\)\|\(kern\)\|\(mail\)\|\(daemon\)\)\s*;/he=e-1
\ contained 
\ nextgroup=namedComment,namedParenError,namedError
syn match namedLoggingChannelSyslogFacility 
\ /\<\(\(auth\)\|\(syslog\)\|\(lpr\)\|\(news\)\)\s*;/he=e-1
\ contained 
\ nextgroup=namedComment,namedParenError,namedError
syn match namedLoggingChannelSyslogFacility 
\ /\<\(\(uucp\)\|\(cron\)\|\(authpriv\)\|\(ftp\)\)\s*;/he=e-1
\ contained 
\ nextgroup=namedComment,namedParenError,namedError
syn match namedLoggingChannelSyslogFacility 
\ /\<\(\(local0\)\|\(local1\)\|\(local2\)\|\(local3\)\)\s*;/he=e-1
\ contained 
\ nextgroup=namedComment,namedParenError,namedError
syn match namedLoggingChannelSyslogFacility 
\ /\<\(\(local4\)\|\(local5\)\|\(local6\)\|\(local7\)\)\s*;/he=e-1
\ contained 
\ nextgroup=namedComment,namedParenError,namedError

hi link namedLoggingChannelOptSyslog namedHLOption
sy keyword namedLoggingChannelOptSyslog syslog contained skipwhite 
\ nextgroup=
\    namedLoggingChannelSyslogFacilityKern,
\    namedLoggingChannelSyslogFacilityUser,
\    namedLoggingChannelSyslogFacility,
\    namedParenError,
\    @namedClusterCommonNext,

hi link namedLoggingChannelOptPrinttimeISOs namedHLBuiltin
syn match namedLoggingChannelOptPrinttimeISOs contained skipwhite
\ /\(\(iso8601\(-utc\)\{0,1}\)\|\(local\)\)\s*;/he=e-1
\ nextgroup=
\    namedComment,
\    namedNotSemicolon,
\    namedError

hi link namedLoggingChannelOptPrintTime namedHLOption
syn match namedLoggingChannelOptPrintTime /print\-time/ contained skipwhite
\ nextgroup=
\    namedLoggingChannelOptPrinttimeISOs,
\    @namedClusterBoolean_SC,
\    namedParenError,
\    @namedClusterCommonNext,
\    namedError,

hi link namedLoggingChannelFileVersionOptUnlimited namedHLBuiltin
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
hi link namedLoggingChannelFileOptVersions namedHLOption
syn match namedLoggingChannelFileOptVersions contained skipwhite /versions/
\ nextgroup=
\    namedLoggingChannelFileVersionOptInteger,
\    namedLoggingChannelFileVersionOptUnlimited,

hi link namedLoggingChannelFileSizeOpt namedHLNumber
" [0-9]\{1,12}\([BbKkMmGgPp]\{1}\)/
syn match namedLoggingChannelFileSizeOpt 
\ /[0-9]\{1,11}\([BbKkMmGgPp]\)\{0,1}/
\ contains=namedTypeSizeSpec
\ contained skipwhite
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptVersions,
\           namedSemicolon

hi link namedLoggingChannelFileOptSize namedHLOption
syn match namedLoggingChannelFileOptSize /size/
\ contained  skipwhite
\ nextgroup=namedLoggingChannelFileSizeOpt

hi link namedLoggingChannelFileSuffixOpt namedHLBuiltin
syn match namedLoggingChannelFileSuffixOpt /\(\(increment\)\|\(timestamp\)\)/
\ contained skipwhite
\ nextgroup=namedLoggingChannelFileOptSize,
\           namedLoggingChannelFileOptVersions,
\           namedSemicolon

hi link namedLoggingChannelFileOptSuffix namedHLOption
syn match namedLoggingChannelFileOptSuffix /suffix/
\ contained  skipwhite
\ nextgroup=namedLoggingChannelFileSuffixOpt

hi link namedLoggingChannelFileIdent namedHLIdentifier
" syn match namedLoggingChannelFileIdent /\S\+\(\s\+;\)\{0,1}/he=e-1 contained skipwhite
syn match namedLoggingChannelFileIdent /\S\+/ contained skipwhite
\ contains=namedFilespec
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptSize,
\           namedLoggingChannelFileOptVersions,
\           namedSemicolon

" file <namedLoggingChannelOptFile> [ ... ];
hi link namedLoggingChannelOptFile namedHLOption
syn match namedLoggingChannelOptFile /file/ contained skipwhite
\ nextgroup=
\    namedLoggingChannelFileIdent,
\    namedInclude,
\    namedComment,
\    namedParenError,
\    namedError

syn region namedLoggingChannelSection contained start=+{+ end=+}\s*;+ 
\ contains=
\    namedLoggingChannelOpts,
\    namedLoggingChannelOptFile,
\    namedLoggingChannelOptPrintTime,
\    namedLoggingChannelOptSyslog,
\    namedLoggingChannelOptNull,
\    namedLoggingChannelOptSeverity,
\    namedInclude,
\    namedComment,
\    namedParenError,
\    namedError
\ skipwhite

hi link namedLoggingChannelIdent namedHLIdentifier
syn match namedLoggingChannelIdent /\S\+/ contained skipwhite
\ contains=namedString
\ nextgroup=namedLoggingChannelSection

hi link namedLoggingOptChannelKeyword namedHLOption
syn match namedLoggingOptChannelKeyword contained skipwhite /channel/
\ nextgroup=namedLoggingChannelIdent,namedError
\ containedin=namedStmtLoggingSection

syn region namedStmtLoggingSection contained start=+{+ end=+}\s*;+ 
\ contains=
\    namedLoggingOptCategoryKeyword,
\    namedLoggingOptChannelKeyword,
\    namedComment,namedInclude,namedParenError,namedError
\ skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'options' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn keyword namedStmtOptionsKeywords contained 
\     automatic-interface-scan 
\     check-integrity 
\     check-sibling 
\     check-wildcard 
\ nextgroup=@namedClusterBoolean
\ containedin=namedOptionsClause skipwhite

" 'options' warn/fail/ignore operators
syn keyword namedStmtOptionsKeywords contained
\    check-spf
\ nextgroup=namedIgnoreWarnFail,namedError 
\ containedin=namedOptionsClause skipwhite

syn keyword namedStmtOptionsKeywords contained
\    avoid-v4-udp-ports
\    avoid-v6-udp-ports
\ nextgroup=namedPortSection,namedInclude,namedComment,namedError
\ containedin=namedOptionsClause skipwhite

" 'options' clause - Filespec (directory, filename)
syn keyword namedStmtOptionsKeywords contained
\    bindkeys-file
\    cache-file
\    directory
\    dump-file
\    geoip-directory
\    key-directory
\    managed-keys-directory
\    named-xfer
\    pid-file
\    nextgroup=namedQuotedString,namedNotString
\    containedin=namedOptionsClause skipwhite

" 'option' clause - AML
syn keyword namedStmtOptionsKeywords contained
\    blackhole
\    listen-on
\ nextgroup=namedAMLSection,namedInclude,namedComment
\ containedin=namedOptionsClause skipwhite

" syn keyword namedStmtOptionsKeywords check-dup-records
" syn keyword namedStmtOptionsKeywords check-mx
" syn keyword namedStmtOptionsKeywords check-mx-cname
" syn keyword namedStmtOptionsKeywords check-names
" syn keyword namedStmtOptionsKeywords check-srv-camera
" syn keyword namedStmtOptionsKeywords check-wildcard
" syn keyword namedStmtOptionsKeywords coresize
" syn keyword namedStmtOptionsKeywords datasize
" syn keyword namedStmtOptionsKeywords deallocate-on-exit
" syn keyword namedStmtOptionsKeywords deny-answer-addresses
" syn keyword namedStmtOptionsKeywords deny-answer-aliases
" syn keyword namedStmtOptionsKeywords dialup
" syn keyword namedStmtOptionsKeywords disable-algorithms
" syn keyword namedStmtOptionsKeywords disable-ds-digests
" syn keyword namedStmtOptionsKeywords disable-empty-zone
" syn keyword namedStmtOptionsKeywords dns64
" syn keyword namedStmtOptionsKeywords dns64-contact
" syn keyword namedStmtOptionsKeywords dns64-server
" syn keyword namedStmtOptionsKeywords dnssec-accept-expired
" syn keyword namedStmtOptionsKeywords dnssec-dnskey-kskonly
" syn keyword namedStmtOptionsKeywords dnssec-dnskey-kskonly
" syn keyword namedStmtOptionsKeywords dnssec-enable
" syn keyword namedStmtOptionsKeywords dnssec-loadkeys-interval
" syn keyword namedStmtOptionsKeywords dnssec-lookaside
" syn keyword namedStmtOptionsKeywords dnssec-must-be-secure
" syn keyword namedStmtOptionsKeywords dnssec-secure-to-insecure
" syn keyword namedStmtOptionsKeywords dnssec-validation
" syn keyword namedStmtOptionsKeywords dscp
" syn keyword namedStmtOptionsKeywords empty-contact
" syn keyword namedStmtOptionsKeywords empty-server
" syn keyword namedStmtOptionsKeywords empty-zone-enable
" syn keyword namedStmtOptionsKeywords fetch-quota-param
" syn keyword namedStmtOptionsKeywords fetches-per-server
" syn keyword namedStmtOptionsKeywords fetches-per-zone
" syn keyword namedStmtOptionsKeywords files
" syn keyword namedStmtOptionsKeywords filter-aaaa
" syn keyword namedStmtOptionsKeywords filter-aaaa-on-v4
" syn keyword namedStmtOptionsKeywords filter-aaaa-on-v6
" syn keyword namedStmtOptionsKeywords flush-zones-on-shutdown
" syn keyword namedStmtOptionsKeywords forward
" syn keyword namedStmtOptionsKeywords forwarders
" syn keyword namedStmtOptionsKeywords heartbeat-interval
" syn keyword namedStmtOptionsKeywords host-statistics
" syn keyword namedStmtOptionsKeywords host-statistics-max
" syn keyword namedStmtOptionsKeywords hostname
" syn keyword namedStmtOptionsKeywords interface-interval
" syn keyword namedStmtOptionsKeywords ixfr-from-differences
" syn keyword namedStmtOptionsKeywords lame-ttl
" syn keyword namedStmtOptionsKeywords listen-on-v6
" syn keyword namedStmtOptionsKeywords lock-file
" syn keyword namedStmtOptionsKeywords masterfile-format
" syn keyword namedStmtOptionsKeywords match-mapped-addresses
" syn keyword namedStmtOptionsKeywords max-cache-size
" syn keyword namedStmtOptionsKeywords max-cache-ttl
" syn keyword namedStmtOptionsKeywords max-clients-per-query
" syn keyword namedStmtOptionsKeywords max-ixfr-log-size
" syn keyword namedStmtOptionsKeywords max-journal-size
" syn keyword namedStmtOptionsKeywords max-ncache-ttl
" syn keyword namedStmtOptionsKeywords max-records
" syn keyword namedStmtOptionsKeywords max-recursion-depth
" syn keyword namedStmtOptionsKeywords max-recursion-queries
" syn keyword namedStmtOptionsKeywords max-rsa-exponent-size
" syn keyword namedStmtOptionsKeywords max-transfer-idle-in
" syn keyword namedStmtOptionsKeywords max-transfer-idle-out
" syn keyword namedStmtOptionsKeywords max-transfer-time-in
" syn keyword namedStmtOptionsKeywords max-transfer-time-out
" syn keyword namedStmtOptionsKeywords max-udp-size
" syn keyword namedStmtOptionsKeywords max-zone-ttl
" syn keyword namedStmtOptionsKeywords memstatistics
" syn keyword namedStmtOptionsKeywords memstatistics-file
" syn keyword namedStmtOptionsKeywords min-roots
" syn keyword namedStmtOptionsKeywords minimal-responses
" syn keyword namedStmtOptionsKeywords multiple-cnames
" syn keyword namedStmtOptionsKeywords mult-master
" syn keyword namedStmtOptionsKeywords no-case-compress
" syn keyword namedStmtOptionsKeywords nosit-udp-size
" syn keyword namedStmtOptionsKeywords notify
" syn keyword namedStmtOptionsKeywords notify-delay
" syn keyword namedStmtOptionsKeywords notify-source
" syn keyword namedStmtOptionsKeywords notify-source-v6
" syn keyword namedStmtOptionsKeywords notify-to-soa
" syn keyword namedStmtOptionsKeywords preferred-glue
" syn keyword namedStmtOptionsKeywords prefetch
" syn keyword namedStmtOptionsKeywords provide-ixfr
" syn keyword namedStmtOptionsKeywords queryport-port-ports
" syn keyword namedStmtOptionsKeywords queryport-port-updateinterval
" syn keyword namedStmtOptionsKeywords query-source
" syn keyword namedStmtOptionsKeywords query-source-v6
" syn keyword namedStmtOptionsKeywords querylog
" syn keyword namedStmtOptionsKeywords random-device
" syn keyword namedStmtOptionsKeywords rate-limit
" syn keyword namedStmtOptionsKeywords recursing-file
" syn keyword namedStmtOptionsKeywords recursive-clients
" syn keyword namedStmtOptionsKeywords request-nsid
" syn keyword namedStmtOptionsKeywords request-sit
" syn keyword namedStmtOptionsKeywords reserved-sockets
" syn keyword namedStmtOptionsKeywords resolver-query-timeout
" syn keyword namedStmtOptionsKeywords response-policy
" syn keyword namedStmtOptionsKeywords rfc2308-type1
" syn keyword namedStmtOptionsKeywords root-delegation
" syn keyword namedStmtOptionsKeywords rrset-order
" syn keyword namedStmtOptionsKeywords secroots-file
" syn keyword namedStmtOptionsKeywords serial-query-rate
" syn keyword namedStmtOptionsKeywords serial-update-method
" syn keyword namedStmtOptionsKeywords server-id
" syn keyword namedStmtOptionsKeywords session-keyfile
" syn keyword namedStmtOptionsKeywords session-keyalg
" syn keyword namedStmtOptionsKeywords session-keyname
" syn keyword namedStmtOptionsKeywords sig-signing-nodes
" syn keyword namedStmtOptionsKeywords sig-signing-signatures
" syn keyword namedStmtOptionsKeywords sig-signing-type
" syn keyword namedStmtOptionsKeywords sig-validity-interval
" syn keyword namedStmtOptionsKeywords sit-secret
" syn keyword namedStmtOptionsKeywords sortlist
" syn keyword namedStmtOptionsKeywords stacksize
" syn keyword namedStmtOptionsKeywords statistics-file
" syn keyword namedStmtOptionsKeywords statistics-interval
" syn keyword namedStmtOptionsKeywords support-ixfr
" syn keyword namedStmtOptionsKeywords suppress-initial-notify
" syn keyword namedStmtOptionsKeywords tcp-clients
" syn keyword namedStmtOptionsKeywords tcp-listen-queue
" syn keyword namedStmtOptionsKeywords tkey-dhkey
" syn keyword namedStmtOptionsKeywords tkey-domain
" syn keyword namedStmtOptionsKeywords tkey-gssapi-credential
" syn keyword namedStmtOptionsKeywords tkey-gssapi-keytab
" syn keyword namedStmtOptionsKeywords transfers
" syn keyword namedStmtOptionsKeywords transfers-format
" syn keyword namedStmtOptionsKeywords transfers-in
" syn keyword namedStmtOptionsKeywords transfers-out
" syn keyword namedStmtOptionsKeywords transfers-per-ns
" syn keyword namedStmtOptionsKeywords transfers-source
" syn keyword namedStmtOptionsKeywords transfers-source-v6
" syn keyword namedStmtOptionsKeywords trusted-anchor-telemetry
" syn keyword namedStmtOptionsKeywords try-tcp-refresh
" syn keyword namedStmtOptionsKeywords update-check-ksk
" syn keyword namedStmtOptionsKeywords use-alt-transfer-source
" syn keyword namedStmtOptionsKeywords use-v4-udp-ports
" syn keyword namedStmtOptionsKeywords use-v6-udp-ports
" syn keyword namedStmtOptionsKeywords version
" syn keyword namedStmtOptionsKeywords zero-no-soa-ttl
" syn keyword namedStmtOptionsKeywords zero-no-soa-ttl-cache
" syn keyword namedStmtOptionsKeywords zone-statistics

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'server' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server-statement-specific syntaxes
hi link namedServerBoolGroup namedHLOption
syn keyword namedServerBoolGroup contained
\   bogus
\ nextgroup=@namedClusterBoolean 
\ containedin=namedStmtServerSection skipwhite


" syn keyword namedStmtServerKeywords edns
" syn keyword namedStmtServerKeywords edns-version
" syn keyword namedStmtServerKeywords max-udp-size
" syn keyword namedStmtServerKeywords notify-source
" syn keyword namedStmtServerKeywords notify-source-v6
" syn keyword namedStmtServerKeywords notify-to-soa
" syn keyword namedStmtServerKeywords request-ixfr
" syn keyword namedStmtServerKeywords request-nsid
" syn keyword namedStmtServerKeywords request-sit
" syn keyword namedStmtServerKeywords support-ixfr


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'view' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" view statement - boolean operators
hi link namedStmtViewBoolGroup namedHLStatement
syn keyword namedStmtViewBoolGroup contained 
\    check-integrity 
\    check-sibling 
\    check-wildcard
\    dnssec-accept-expired
\    dnssec-enable
\    dnssec-validation
\    empty-zone-enable
\    fetch-glue
\    match-recursive-only
\ nextgroup=@namedClusterBoolean 
\ containedin=namedStmtViewSection,namedInclude,namedComment
\ skipwhite
" obsoleted 'view' statements
" \    acache-enable
" \    additional-from-auth
" \    additional-from-cache
" \    cleaning-interval

hi link namedStmtViewNumberGroup namedHLOption
syn keyword namedStmtViewNumberGroup contained
\    lame-ttl
\ nextgroup=namedNumber,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite

" view statement - second_type
hi link namedStmtViewSecondGroup namedHLStatement
syn keyword namedStmtViewSecondGroup contained 
\    max-cache-ttl
\ nextgroup=namedTypeSeconds,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite

" view statement - minute_type
hi link namedStmtViewMinuteGroup namedHLStatement
syn keyword namedStmtViewMinuteGroup contained 
\    cleaning-interval
\    heartbeat-interval
\ nextgroup=namedTypeMinutes,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite

" List of Port numbers

" view statement - 'check_options': warn/fail/ignore operators
syn keyword namedStmtViewKeywords contained
\    check-dup-records
\    check-mx-cname
\    check-mx
\    check-sibling
\    check-spf
\    check-srv-cname
\ nextgroup=namedIgnoreWarnFail,namedError 
\ containedin=namedStmtViewSection skipwhite

" view statement - Filespec (directory, filename)
hi link namedStmtViewFilespecGroup namedHLOption
syn keyword namedStmtViewFilespecGroup contained
\    cache-file
\    key-directory
\    managed-keys-directory
\    nextgroup=namedQuotedString,namedNotString
\    containedin=namedStmtViewSection skipwhite

" view statement - SizeSpec options
hi link namedStmtViewSizeSpecGroup namedHLStatement
syn keyword namedStmtViewSizeSpecGroup contained 
\    max-cache-size
\ nextgroup=namedTypeSizeSpec,namedComment,namedError
\ containedin=namedStmtViewSection skipwhite


" view statement - Domain name with optional ending period
syn keyword namedStmtViewKeywords contained
\    empty-contact
\    nextgroup=namedQuotedDomain,namedNotString
\    containedin=namedStmtViewSection skipwhite

" view statement - AML
syn keyword namedStmtViewKeywords contained
\    match-clients
\    match-destinations
\    nextgroup=namedAMLSection,namedError
\    containedin=namedStmtViewSection skipwhite

" view statement - check-names
syn match namedTypeCheckNamesZone /primary/ contained containedin=namedStmtViewCheckNames nextgroup=namedIgnoreWarnFail skipwhite
syn match namedTypeCheckNamesZone /secondary/ contained containedin=namedStmtViewCheckNames nextgroup=namedIgnoreWarnFail skipwhite
syn match namedTypeCheckNamesZone /response/ contained containedin=namedStmtViewCheckNames nextgroup=namedIgnoreWarnFail skipwhite
syn match namedTypeCheckNamesZone /master/ contained containedin=namedStmtViewCheckNames nextgroup=namedIgnoreWarnFail skipwhite
syn match namedTypeCheckNamesZone /slave/ contained containedin=namedStmtViewCheckNames nextgroup=namedIgnoreWarnFail skipwhite
syn keyword namedStmtViewCheckNames contained
\    check-names
\    nextgroup=namedTypeCheckNamesZone,namedError
\    containedin=namedStmtViewSection
\    skipwhite


syn keyword namedStmtViewKeywords contained 
\     disable-empty-zone 
\ nextgroup=namedQuotedString,namedError skipwhite

" view statement - disable-empty-zone, trust anchor method
hi link namedDNSSECLookaside namedSpecial
syn match namedDNSSECLookaside /auto\s*;/he=e-1 contained skipwhite
syn match namedDNSSECLookaside /no\s*;/he=e-1 contained skipwhite
" TODO: dnssec-lookaside <domain-name>
" syn match namedDNSSECLookaside /.\+\s*;/he=e-1 contained nextgroup=@namedDomainFQDNCluster skipwhite

syn keyword namedStmtViewKeywords contained 
\     dnssec-lookaside 
\ nextgroup=namedDNSSECLookaside,namedQuotedDomain,namedError skipwhite

" dnssec-must-be-secure <domain_name> <boolean>; [ Opt View ]  # v9.3.0+
syn match namedDMBS_FQDN /\i/ 
\ contained contains=namedDomain 
\ nextgroup=@namedClusterBoolean skipwhite
syn keyword namedStmtViewKeywords contained dnssec-must-be-secure 
\ nextgroup=namedDMBS_FQDN skipwhite

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
\ /\<[0-9A-Za-z][-0-9A-Za-z.]\+\>/ 
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
\ containedin=namedStmtViewKeywords
syn keyword namedStmtViewKeywords contained 
\    dual-stack-servers
\ nextgroup=namedDSS_OptGlobalPort,namedDSS_Section skipwhite

" view statement - files
syn match namedFilesCount /\*/ contained
\ skipwhite
\ contains=namedNumber
syn match namedFilesCount /\d\+/ contained skipwhite
syn match namedFilesCount /default/ contained skipwhite
syn match namedFilesCount /unlimited/ contained skipwhite
syn keyword namedStmtViewKeywords contained
\    files
\ nextgroup=namedFilesCount skipwhite

" view statement - hostname [ none | <domain_name> ];
syn match namedTypeNone /none/ skipwhite
syn keyword namedStmtViewKeywords contained
\    hostname
\ nextgroup=namedTypeNone,namedQuotedDomain skipwhite


" syn keyword namedStmtViewKeywords class
" syn keyword namedStmtViewKeywords client-per-query
" syn keyword namedStmtViewKeywords deny-answer-addresses
" syn keyword namedStmtViewKeywords deny-answer-aliases
" syn keyword namedStmtViewKeywords dialup
" syn keyword namedStmtViewKeywords disable-algorithms
" syn keyword namedStmtViewKeywords disable-ds-digests
" syn keyword namedStmtViewKeywords dns64
" syn keyword namedStmtViewKeywords dns64-contact
" syn keyword namedStmtViewKeywords dns64-server
" syn keyword namedStmtViewKeywords dnssec-dnskey-kskonly
" syn keyword namedStmtViewKeywords dnssec-loadkeys-interval
" syn keyword namedStmtViewKeywords dnssec-secure-to-insecure
" syn keyword namedStmtViewKeywords dnssec-update-mode
" syn keyword namedStmtViewKeywords empty-server
" syn keyword namedStmtViewKeywords fetch-quota-param
" syn keyword namedStmtViewKeywords fetches-per-server
" syn keyword namedStmtViewKeywords fetches-per-zone
" syn keyword namedStmtViewKeywords filter-aaaa
" syn keyword namedStmtViewKeywords filter-aaaa-on-v4
" syn keyword namedStmtViewKeywords filter-aaaa-on-v6
" syn keyword namedStmtViewKeywords forward
" syn keyword namedStmtViewKeywords forwarders
" syn keyword namedStmtViewKeywords ixfr-from-differences
" syn keyword namedStmtViewKeywords masterfile-format
" syn keyword namedStmtViewKeywords match-clients
" syn keyword namedStmtViewKeywords match-destination
" syn keyword namedStmtViewKeywords match-recursive-only
" syn keyword namedStmtViewKeywords max-cache-ttl
" syn keyword namedStmtViewKeywords max-clients-per-query
" syn keyword namedStmtViewKeywords max-ixfr-log-size
" syn keyword namedStmtViewKeywords max-journal-size
" syn keyword namedStmtViewKeywords max-ncache-ttl
" syn keyword namedStmtViewKeywords max-recursion-depth
" syn keyword namedStmtViewKeywords max-recursion-queries
" syn keyword namedStmtViewKeywords max-transfer-idle-in
" syn keyword namedStmtViewKeywords max-transfer-idle-out
" syn keyword namedStmtViewKeywords max-transfer-time-in
" syn keyword namedStmtViewKeywords max-transfer-time-out
" syn keyword namedStmtViewKeywords max-udp-size
" syn keyword namedStmtViewKeywords max-zone-ttl
" syn keyword namedStmtViewKeywords min-roots
" syn keyword namedStmtViewKeywords minimal-responses
" syn keyword namedStmtViewKeywords multiple-cnames
" syn keyword namedStmtViewKeywords mult-master
" syn keyword namedStmtViewKeywords no-case-compress
" syn keyword namedStmtViewKeywords nosit-udp-size
" syn keyword namedStmtViewKeywords notify
" syn keyword namedStmtViewKeywords notify-delay
" syn keyword namedStmtViewKeywords notify-source
" syn keyword namedStmtViewKeywords notify-source-v6
" syn keyword namedStmtViewKeywords notify-to-soa
" syn keyword namedStmtViewKeywords preferred-glue
" syn keyword namedStmtViewKeywords prefetch
" syn keyword namedStmtViewKeywords provide-ixfr
" syn keyword namedStmtViewKeywords queryport-port-ports
" syn keyword namedStmtViewKeywords queryport-port-updateinterval
" syn keyword namedStmtViewKeywords query-source
" syn keyword namedStmtViewKeywords query-source-v6
" syn keyword namedStmtViewKeywords rate-limit
" syn keyword namedStmtViewKeywords request-nsid
" syn keyword namedStmtViewKeywords request-sit
" syn keyword namedStmtViewKeywords resolver-query-timeout
" syn keyword namedStmtViewKeywords response-policy
" syn keyword namedStmtViewKeywords rfc2308-type1
" syn keyword namedStmtViewKeywords root-delegation
" syn keyword namedStmtViewKeywords serial-update-method
" syn keyword namedStmtViewKeywords session-keyname
" syn keyword namedStmtViewKeywords sig-signing-nodes
" syn keyword namedStmtViewKeywords sig-signing-signatures
" syn keyword namedStmtViewKeywords sig-signing-type
" syn keyword namedStmtViewKeywords sig-validity-interval
" syn keyword namedStmtViewKeywords sortlist
" syn keyword namedStmtViewKeywords support-ixfr
" syn keyword namedStmtViewKeywords suppress-initial-notify
" syn keyword namedStmtViewKeywords transfers
" syn keyword namedStmtViewKeywords transfers-format
" syn keyword namedStmtViewKeywords transfers-source
" syn keyword namedStmtViewKeywords transfers-source-v6
" syn keyword namedStmtViewKeywords try-tcp-refresh
" syn keyword namedStmtViewKeywords update-check-ksk
" syn keyword namedStmtViewKeywords use-alt-transfer-source
" syn keyword namedStmtViewKeywords zero-no-soa-ttl
" syn keyword namedStmtViewKeywords zero-no-soa-ttl-cache
" syn keyword namedStmtViewKeywords zone-statistics

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'zone' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn keyword namedStmtZoneKeywords contained 
\     check-integrity 
\     check-sibling 
\ nextgroup=@namedClusterBoolean containedin=namedZoneSection skipwhite

" 'zone' clause - 'check_options': warn/fail/ignore operators
syn keyword namedStmtZoneKeywords contained
\    check-spf
\ nextgroup=namedIgnoreWarnFail,namedError 
\ containedin=namedZoneSection skipwhite

" 'zone' clause - Filespec (directory, filename)
syn keyword namedStmtZoneKeywords contained
\    key-directory
\    nextgroup=namedQuotedString,namedNotString
\    containedin=namedStmtViewSection skipwhite

" syn keyword namedStmtZoneKeywords check-dup-records
" syn keyword namedStmtZoneKeywords check-mx
" syn keyword namedStmtZoneKeywords check-mx-cname
" syn keyword namedStmtZoneKeywords check-names
" syn keyword namedStmtZoneKeywords check-srv-cname
" syn keyword namedStmtZoneKeywords check-wildcard
" syn keyword namedStmtZoneKeywords class
" syn keyword namedStmtZoneKeywords client-per-query
" syn keyword namedStmtZoneKeywords database
" syn keyword namedStmtZoneKeywords delegation-only
" syn keyword namedStmtZoneKeywords dialup
" syn keyword namedStmtZoneKeywords dnssec-dnskey-kskonly
" syn keyword namedStmtZoneKeywords dnssec-loadkeys-interval
" syn keyword namedStmtZoneKeywords dnssec-secure-to-insecure
" syn keyword namedStmtZoneKeywords dnssec-update-mode
" syn keyword namedStmtZoneKeywords file
" syn keyword namedStmtZoneKeywords files
" syn keyword namedStmtZoneKeywords forward
" syn keyword namedStmtZoneKeywords forwarders
" syn keyword namedStmtZoneKeywords in-view
" syn keyword namedStmtZoneKeywords inline-signing
" syn keyword namedStmtZoneKeywords journal
" syn keyword namedStmtZoneKeywords masterfile-format
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

" syn keyword namedStmtOptionsKeywordsObsoleted acache-cleaning-interval
" syn keyword namedStmtOptionsKeywordsObsoleted acache-enable
" syn keyword namedStmtOptionsKeywordsObsoleted additional-from-auth
" syn keyword namedStmtOptionsKeywordsObsoleted additional-from-cache
" syn keyword namedStmtOptionsKeywordsObsoleted alt-transfer-source
" syn keyword namedStmtOptionsKeywordsObsoleted alt-transfer-source-v6
" syn keyword namedStmtOptionsKeywordsObsoleted fake-iquery
" syn keyword namedStmtOptionsKeywordsObsoleted fetch-glue
" syn keyword namedStmtOptionsKeywordsObsoleted has-old-clients
" syn keyword namedStmtOptionsKeywordsObsoleted maintain-ixfr-base
" syn keyword namedStmtOptionsKeywordsObsoleted max-acache-size
" syn keyword namedStmtOptionsKeywordsObsoleted max-refresh-time
" syn keyword namedStmtOptionsKeywordsObsoleted max-retry-time
" syn keyword namedStmtOptionsKeywordsObsoleted min-refresh-time
" syn keyword namedStmtOptionsKeywordsObsoleted min-retry-time
" syn keyword namedStmtOptionsKeywordsObsoleted named-xfer
" syn keyword namedStmtOptionsKeywordsObsoleted serial-queries
" syn keyword namedStmtOptionsKeywordsObsoleted treat-cr-as-space
" syn keyword namedStmtOptionsKeywordsObsoleted use-ixfr
" syn keyword namedStmtOptionsKeywordsObsoleted use-queryport-pool
" syn keyword namedStmtOptionsKeywordsObsoleted use-queryport-updateinterval

" syn keyword namedStmtServerKeywordsObsoleted edns-udp-size
" syn keyword namedStmtServerKeywordsObsoleted keys
" syn keyword namedStmtServerKeywordsObsoleted provide-ixfr
" syn keyword namedStmtServerKeywordsObsoleted transfers
" syn keyword namedStmtServerKeywordsObsoleted transfers-format
" syn keyword namedStmtServerKeywordsObsoleted transfers-source
" syn keyword namedStmtServerKeywordsObsoleted transfers-source-v6

" syn keyword namedStmtViewKeywordsObsoleted alt-transfer-source
" syn keyword namedStmtViewKeywordsObsoleted alt-transfer-source-v6
" syn keyword namedStmtViewKeywordsObsoleted fetch-glue
" syn keyword namedStmtViewKeywordsObsoleted maintain-ixfr-base
" syn keyword namedStmtViewKeywordsObsoleted max-acache-size
" syn keyword namedStmtViewKeywordsObsoleted max-refresh-time
" syn keyword namedStmtViewKeywordsObsoleted max-retry-time
" syn keyword namedStmtViewKeywordsObsoleted min-refresh-time
" syn keyword namedStmtViewKeywordsObsoleted min-retry-time
" syn keyword namedStmtViewKeywordsObsoleted use-queryport-pool
" syn keyword namedStmtViewKeywordsObsoleted use-queryport-updateinterval

" syn keyword namedStmtZoneKeywordsObsoleted alt-transfer-source
" syn keyword namedStmtZoneKeywordsObsoleted alt-transfer-source-v6
" syn keyword namedStmtZoneKeywordsObsoleted cleaning-interval
" syn keyword namedStmtZoneKeywordsObsoleted ixfr-base
" syn keyword namedStmtZoneKeywordsObsoleted maintain-ixfr-base
" syn keyword namedStmtZoneKeywordsObsoleted max-refresh-time
" syn keyword namedStmtZoneKeywordsObsoleted max-retry-time
" syn keyword namedStmtZoneKeywordsObsoleted min-refresh-time
" syn keyword namedStmtZoneKeywordsObsoleted min-retry-time
" syn keyword namedStmtZoneKeywordsObsoleted pubkey
" syn keyword namedStmtZoneKeywordsObsoleted use-id-pool

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOptionsViewBoolGroup namedHLOption
syn keyword namedOptionsViewBoolGroup contained
\    allow-new-zones
\    auth-nxdomain 
\ nextgroup=@namedClusterBoolean 
\ containedin=namedStmtOptionsSection,namedStmtViewSection skipwhite

hi link namedOptionsViewAMLGroup namedHLOption
syn keyword namedOptionsViewAMLGroup contained
\    allow-query-cache
\    allow-query-cache-on
\    allow-recursion
\    allow-recursion-on
\ nextgroup=namedAMLSection skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

hi link namedViewName_SC namedHLIdentifier
syn match namedViewName_SC /\s\+/
\ contained skipwhite 
\ contains=namedViewName
\ nextgroup=namedSemicolon

hi link namedOptionsViewAttachCache namedHLOption
syn match namedOptionsViewAttachCache contained
\    /\<attach-cache\>/
\ nextgroup=namedViewName_SC,namedError skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'view', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOptionsViewZoneAMLGroup namedHLOption
syn keyword namedOptionsViewZoneAMLGroup contained
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

hi link namedOptATSClauseDscp  namedHLClause
syn match namedOptATS_DSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ contains=namedDSCP skipwhite
\ nextgroup=namedOptATSClausePort,namedSemicolon

hi link namedOptATS_PortWild namedHLNumber
syn match namedOptATS_PortWild contained /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=namedOptATSClauseDscp,namedSemicolon

hi link namedOptATSClausePort  namedHLClause
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

hi link namedOptionsViewZoneOptATS namedHLOption
syn keyword namedOptionsViewZoneOptATS contained
\    alt-transfer-source-v6
\ nextgroup=namedOptATS_IP6wild skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection
syn keyword namedOptionsViewZoneOptATS contained
\    alt-transfer-source
\ nextgroup=namedOptATS_IP4wild skipwhite
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection

syn match namedAllowMaintainOff_SC contained /\S\+/
\ nextgroup=namedSemicolon
\ contains=namedAllowMaintainOff
hi link namedViewZoneAutoDNSSEC namedHLOption
syn keyword namedViewZoneAutoDNSSEC contained
\    auto-dnssec
\ nextgroup=namedAllowMaintainOff_SC,namedComment,namedError 
\ containedin=
\    namedStmtOptionsSection,
\    namedStmtViewSection,
\    namedStmtZoneSection 
\ skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'server'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtOptAVS namedHLString
" syn match namedStmtOptAVS contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match namedStmtOptAVS /aaaa\s*;/ contained skipwhite
syn match namedStmtOptAVS /AAAA\s*;/ contained skipwhite
syn match namedStmtOptAVS /a6\s*;/ contained skipwhite
syn match namedStmtOptAVS /A6\s*;/ contained skipwhite

hi link namedStmtOptionsServerViewOptAV6S namedHLOption
syn keyword namedStmtOptionsServerViewOptAV6S contained
\    allow-v6-synthesis
\ nextgroup=namedStmtOptAVS 
\ skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedStmtOptionsViewZoneOptAN namedHLOption
syn keyword namedStmtOptionsViewZoneOptAN contained
\    also-notify
\ nextgroup=namedElementIP4AddrList,namedInclude,namedComment,namedError
\ skipwhite

" + these keywords are contained within `update-policy' section only
syn keyword namedIntKeyword contained grant nextgroup=namedString skipwhite
syn keyword namedIntKeyword contained name self subdomain wildcard nextgroup=namedString skipwhite
syn keyword namedIntKeyword TXT A PTR NS SOA A6 CNAME MX ANY skipwhite

syn region namedZoneString contained oneline start=+"+ end=+"+ skipwhite
\  contains=namedDomain,namedIllegalDom
\  nextgroup=namedZoneClass,namedStmtZoneSection

syn keyword namedZoneClass contained in hs hesiod chaos
\  IN HS HESIOD CHAOS
\  nextgroup=namedStmtZoneSection skipwhite

syn keyword namedZoneOpt contained update-policy
\  nextgroup=namedIntSection skipwhite

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections ({ ... };) of statements go below here
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" masters <masterIdentifier> { <masters_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedMastersOptMasterKeyName namedHLIdentifier
syn match namedMastersOptMasterKeyName contained /[a-zA-Z][0-9a-zA-Z\-_]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedMastersOptKeyKeyword namedHLOption
syn match namedMastersOptKeyKeyword contained skipwhite /key/
\ nextgroup=
\    namedMastersOptMasterKeyName,
\    namedError

hi link namedMastersOptIPaddrPortNumber namedHLError
syn match namedMastersOptIPaddrPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ contains=namedPort
\ nextgroup=
\    namedMastersOptKeyKeyword,

hi link namedMastersOptIPaddrPortKeyword namedHLOption
syn match namedMastersOptIPaddrPortKeyword contained skipwhite /port/
\ nextgroup=
\    namedMastersOptIPaddrPortNumber,
\    namedError

hi link namedMastersOptMasterName namedHLIdentifier
syn match namedMastersOptMasterName contained skipwhite /[a-zA-Z][a-zA-Z0-9_\-]\+/
\ nextgroup=
\    namedMastersOptKeyKeyword,
\    namedSemicolon,
\   namedComment, namedInclude,
\    namedError
\ containedin=namedStmtMastersSection

" hi link namedMastersOptIP6addr namedHLNumber
syn match namedMastersOptIP6addr contained skipwhite /[0-9a-fA-F:\.]\{6,48}/
\ contains=namedIP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedMastersOptIPaddrPortKeyword,
\   namedMastersOptKeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedStmtMastersSection

hi link namedMastersOptIP4addr namedHLNumber
syn match namedMastersOptIP4addr contained skipwhite 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\   namedSemicolon,
\   namedMastersOptIPaddrPortKeyword,
\   namedMastersOptKeyKeyword,
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


" End of Masters section

hi link namedMastersOpt_DSCP namedHLNumber
syn match namedMastersOpt_DSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=namedMastersOptClausePort,namedStmtMastersSection,namedSemicolon

hi link namedMastersOpt_Port namedHLNumber
syn match namedMastersOpt_Port contained skipwhite
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ nextgroup=namedMastersOptClauseDscp,namedStmtMastersSection,namedSemicolon

hi link namedMastersOptClausePort  namedHLOption
syn match namedMastersOptClausePort /port/ contained skipwhite
\ nextgroup=namedMastersOpt_Port

hi link namedMastersOptClauseDscp  namedHLOption
syn match namedMastersOptClauseDscp /dscp/ contained skipwhite
\ nextgroup=
\    namedMastersOpt_DSCP,

syn match namedStmtMastersIdent contained /\<[0-9a-zA-Z\-_\.]\{1,64}/
\ contains=namedMasterName
\ skipwhite
\ skipempty skipnl
\ nextgroup=
\    namedStmtMastersSection,
\    namedMastersOptClausePort,
\    namedMastersOptClauseDscp,
\    namedComment, namedInclude,
\    namedError

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options { <options_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmtOptionsSection contained 
\ start=+{+ end=+}\s*;+ 
\ contains=
\    namedStmtOptionsBoolGroup,
\    namedStmtOptionsMinuteGroup,
\    namedStmtOptionsKeywords,
\    namedStmtOptionsServerViewOptAV6S,
\    namedStmtOptionsViewZoneOptAN,
\    namedOptionsViewAttachCache,
\    namedInclude,namedComment,namedParenError skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmtServerIdent> { <namedStmtServerKeywords>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmtServerSection contained 
\ start=+{+ end=+}\s*;+ 
\ contains=
\     namedStmtOptionsViewZoneOptAN,
\     namedStmtOptionsServerViewOptAV6S,
\     namedStmtServerBoolGroup,
\     namedComment,namedInclude,namedError,
\ skipwhite


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmtServerIdent> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn match namedStmtServerIdent contained
\ /[0-9]\{1,3}\(\.[0-9]\{1,3}\)\{0,3}\([\/][0-9]\{1,3}\)\{0,1}/
\ nextgroup=namedStmtServerSection,namedComment,namedInclude,namedError skipwhite


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" view <namedViewIdent> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmtViewSection contained 
\ start=+{+ end=+}\s*;+ 
\ contains=
\    namedStmtViewBoolGroup,
\    namedStmtViewSecondGroup,
\    namedStmtViewMinuteGroup,
\    namedStmtViewIgnWarnFail,
\    namedStmtViewCheckNames,
\    namedStmtViewFilespecGroup,
\    namedStmtViewSizeSpecGroup,
\    namedStmtViewKeywords,
\    namedStmtOptionsViewZoneOptAN,
\    namedStmtOptionsServerViewOptAV6S,
\    namedInclude,namedComment,namedParenError skipwhite

syn match namedViewIdent contained /\i\+/ 
\ nextgroup=namedStmtViewSection skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" zone <namedZoneIdent> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmtZoneSection contained 
\ start=+{+ end=+}\s*;+ 
\ contains=
\    namedComment,
\    namedInclude,
\    namedStmtOptionsViewZoneOptAN,
\    namedStmtZoneKeywords,
\    namedParenError  skipwhite

hi link namedZoneIdent namedHLIdentifier
syn match namedZoneIdent contained /\i\+/ 
\ nextgroup=namedStmtZoneSection,namedComment,namedError skipwhite


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Top-level statment (formerly clause) keywords
" 'uncontained' statements are the ones used GLOBALLY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtKeyword namedHLStatement
syn match namedStmtKeyword /\_s*acl/
\ nextgroup=namedStmtACLIdent skipempty skipwhite

syn match namedStmtKeyword /\_s*controls/
\ skipempty skipnl skipwhite
\ nextgroup=namedStmtControlsSection

syn match namedStmtKeyword /\_s*key/
\ nextgroup=namedStmtKeyIdent skipempty skipwhite

syn match namedStmtKeyword /\_s*logging/
\ nextgroup=namedStmtLoggingSection skipempty skipwhite

syn match namedStmtKeyword /\_s*managed-keys/
\ nextgroup=namedStmtManagedKeysSection skipempty skipwhite

syn match namedStmtKeyword /\_s*masters/ 
\ skipwhite skipnl skipempty 
\ nextgroup=
\    namedStmtMastersIdent,
\    namedComment, 
\    namedInclude,
" \ namedError prevents a linefeed between 'master' and '<master_name'

syn match namedStmtKeyword /\_^options/
\ nextgroup=namedStmtOptionsSection skipempty skipwhite

syn match  namedStmtKeyword /\_s*server/
\ nextgroup=namedStmtServerIdent,namedComment 
\ skipempty skipwhite

syn keyword namedStmtKeyword statistics-channels 
\ nextgroup=namedIntIdent 
\ skipempty skipwhite

syn keyword namedStmtKeyword trusted-keys 
\ skipempty skipwhite
\ nextgroup=namedIntSection 

" view <namedViewIdent> { ... };  
syn match namedStmtKeyword /\_s*view/ 
\ skipwhite
\ nextgroup=namedViewIdent 

" TODO: namedStmtError, how to get namedHLError to appear
" zone <namedZoneIdent> { ... };
syn keyword namedStmtKeyword zone 
\ nextgroup=namedZoneIdent,namedComment,namedStmtError skipempty skipwhite

hi link namedHLComment	Comment
hi link namedHLInclude	PreProc
hi link namedHLIdentifier 	Identifier
hi link namedHLStatement	Statement
hi link namedHLOption	Label
hi link namedHLType	Type
hi link namedHLClause	Keyword   " could use a 3rd color here
hi link namedHLNumber	Number
hi link namedHLString	String
hi link namedHLSpecial	Special
hi link namedHLUnderlined	Underlined
hi link namedHLError	Error

let &cpoptions = s:save_cpo
unlet s:save_cpo

let b:current_syntax = 'named'

if main_syntax == 'bind-named'
  unlet main_syntax
endif

" vim: ts=4
