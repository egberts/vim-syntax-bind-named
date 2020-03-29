" Vim syntax file
" Language:     BIND zone files (RFC1035)
" Maintainer:   Mathieu Arnold <mat@mat.cc>
" URL:          https://github.com/Absolight/vim-bind
" Last Change:  Mon 2012-12-17 19:33:55 CET
"
" Based on an earlier version by Julian Mehnle, with heavy modifications.

if exists("b:current_syntax")
  finish
endif

syn case match

" Directives
syn region      zoneRRecord             start=/\v^/ end=/\v$/ contains=zoneOwnerName,zoneSpecial,zoneComment,zoneUnknown

syn match       zoneDirective           /\v^\$ORIGIN\s+/   nextgroup=zoneOrigin,zoneUnknown
syn match       zoneDirective           /\v^\$TTL\s+/      nextgroup=zoneNumber,zoneTTL,zoneUnknown
syn match       zoneDirective           /\v^\$INCLUDE\s+/  nextgroup=zoneText,zoneUnknown
syn match       zoneDirective           /\v^\$GENERATE\s/
hi def link     zoneDirective           Macro

syn match       zoneUnknown             contained /\v\S+/
hi def link     zoneUnknown             Error

syn match       zoneOwnerName           contained /\v^[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]*(\s|;)@=/ nextgroup=zoneTTL,zoneClass,zoneRRType skipwhite
hi def link     zoneOwnerName           Statement

syn match       zoneOrigin              contained  /\v[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]+(\s|;|$)@=/
hi def link     zoneOrigin              Statement

syn match       zoneDomain              contained  /\v([^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]+|\@)(\s|;|$)@=/
hi def link     zoneDomain              Underlined

syn match       zoneSpecial             contained /\v^(\@|\*(\.\S*)?)\s@=/ nextgroup=zoneTTL,zoneClass,zoneRRType skipwhite
hi def link     zoneSpecial             Special

syn match       zoneTTL                 contained /\v<(\d[HhWwDd]?)*>/ nextgroup=zoneClass,zoneRRType skipwhite
hi def link     zoneTTL                 Constant

syn keyword     zoneClass               contained IN CHAOS nextgroup=zoneRRType,zoneTTL   skipwhite
hi def link     zoneClass               Include

let s:dataRegexp = {}
let s:dataRegexp["zoneNumber"] = "/\\v<[0-9]+>/"
let s:dataRegexp["zoneDomain"] = "/\\v[^[:space:]!\"#$%&'()*+,\\/:;<=>?@[\\]\\^`{|}~]+[^[:space:]!\"#$%&'()*+,\\/:;<=>?@[\\]\\^`{|}~]@!/"
let s:dataRegexp["zoneBase64"] = "/\\v[[:space:]]@<=[a-zA-Z0-9\\/\\=\\+]+[a-zA-Z0-9\\/\\=\\+]@!/"
let s:dataRegexp["zoneHex"] = "/\\v<[a-fA-F0-9]+>/"
let s:dataRegexp["zoneRR"] = "/\\v<[A-Z0-9]+>/"
let s:dataRegexp["zoneText"] = "/\\v\"([^\"\\\\]|\\\\.)*\"/"
let s:dataRegexp["zoneSerial"] = "/\\v<[0-9]{9,10}>/"
let s:dataRegexp["zoneTTL"] = "/\\v<(\\d[HhWwDd]?)+>/"

function! s:zoneName(...)
  return "zone_" . join(a:000, "_")
endfunction

function! s:createChain(whose, ...)
  let l:first = join(split(a:whose, " "), "_")
  for args in a:000
    if type(args) == type("")
      let i = [args]
    else
      let i = args
    endif
    let l:size = len(i)
    let l:c = 0
    exe "syn keyword zoneRRType contained " . a:whose  . " skipwhite nextgroup=" . s:zoneName(l:first, l:c) . "," . s:zoneName(l:first, l:c, "SP")
    while l:c < l:size
      let l:keyword = i[l:c]

      let l:str = "syn match " . s:zoneName(l:first, l:c) . " contained skipwhite " . s:dataRegexp[l:keyword]
      if l:c == l:size - 1
        " if we're at the end, loop.
        let l:str = l:str . " nextgroup=" . s:zoneName(l:first, l:c)
      else
        " if we're not at the end, nextgroup may be the next group or a
        " parenthesis.
        let l:str = l:str . " nextgroup=" . s:zoneName(l:first, l:c + 1)
              \ . "," . s:zoneName(l:first, l:c, "SP")
      endif
      exe l:str
      exe "hi link " . s:zoneName(l:first, l:c) . " " . l:keyword

      if l:c < size - 1
        let l:d = l:c + 1
        " or, it could be a multiline record which can start by either a
        " the first type, or a comment followed by the first type.
        exe "syn region " . s:zoneName(l:first, l:c, "SP") . " contained start=\"(\" end=\")\" skipwhite skipnl"
              \" contains=" . s:zoneName(l:first,l:c,l:d) . "," s:zoneName(l:first, l:c, l:d - 1, "Comment")
        exe "hi link " . s:zoneName(l:first, l:c, "SP") . " Macro"
        exe "syn match " . s:zoneName(l:first, l:c, l:d - 1, "Comment") . " /\\v\\;.*/" . " skipwhite skipnl nextgroup=" . s:zoneName(l:first, l:c, l:d)
        exe "hi link " . s:zoneName(l:first, l:c, l:d - 1, "Comment") . " zoneComment"
        while l:d < l:size
          let l:keyword = i[l:d]

          if l:d == l:size - 1
            let l:next = l:d
          else
            let l:next = l:d + 1
          endif

          exe "syn match " . s:zoneName(l:first, l:c, l:d) . " contained skipwhite skipnl " . s:dataRegexp[l:keyword]
                \ . " nextgroup=" . s:zoneName(l:first, l:c, l:next) . "," . s:zoneName(l:first, l:c, l:d, "Comment")
          exe "hi link " . s:zoneName(l:first, l:c, l:d) . " " . l:keyword

          exe "syn match " . s:zoneName(l:first, l:c, l:d, "Comment") . " /\\v\\;.*/" . " skipwhite skipnl nextgroup=" . s:zoneName(l:first, l:c, l:next)
          exe "hi link " . s:zoneName(l:first, l:c, l:d, "Comment") . " zoneComment"

          let l:d += 1
        endwhile
      endif
      let l:c += 1
    endwhile
  endfor
endfunction

" From :
" http://www.iana.org/assignments/dns-parameters/dns-parameters.xml#dns-parameters-3
" keep sorted by rrtype value as possible, no obsolete or experimental RR.
syn keyword     zoneRRType              contained A nextgroup=zoneIPAddr skipwhite
syn keyword     zoneRRType              contained AAAA nextgroup=zoneIP6Addr skipwhite
syn keyword     zoneRRType              contained NS CNAME PTR DNAME nextgroup=zoneDomain skipwhite
call s:createChain("MX", ["zoneNumber", "zoneDomain"])
call s:createChain("SRV", ["zoneNumber", "zoneNumber", "zoneNumber", "zoneDomain"])
call s:createChain("DS DLV TLSA NSEC3PARAM", ["zoneNumber", "zoneNumber", "zoneNumber", "zoneHex"])
call s:createChain("DNSKEY", ["zoneNumber", "zoneNumber", "zoneNumber", "zoneBase64"])
call s:createChain("SSHFP", ["zoneNumber", "zoneNumber", "zoneHex"])
call s:createChain("RRSIG", ["zoneRR", "zoneNumber", "zoneNumber", "zoneNumber", "zoneNumber", "zoneNumber", "zoneNumber", "zoneDomain", "zoneBase64"])
call s:createChain("NSEC", ["zoneDomain", "zoneRR"])
call s:createChain("NSEC3", ["zoneNumber", "zoneNumber", "zoneNumber", "zoneHex", "zoneDomain", "zoneRR"])
call s:createChain("TXT", "zoneText")
call s:createChain("SOA", ["zoneDomain", "zoneDomain", "zoneSerial", "zoneTTL"])
syn keyword     zoneRRType              contained WKS HINFO RP
      \ AFSDB X25 ISDN RT NSAP NSAP-PTR SIG KEY PX GPOS LOC EID NIMLOC
      \ ATMA NAPTR KX CERT SINK OPT APL IPSECKEY
      \ DHCID HIP NINFO RKEY TALINK CDS SPF UINFO UID
      \ GID UNSPEC NID L32 L64 LP URI CAA TA
      \ nextgroup=zoneRData skipwhite
syn match       zoneRRType              contained /\vTYPE\d+/ nextgroup=zoneUnknownType1 skipwhite
hi def link     zoneRRType              Type

syn match       zoneRData               contained /\v[^;]*/ contains=zoneDomain,zoneNumber,zoneParen,zoneBase64,zoneHex,zoneUnknown,zoneRR

syn match       zoneIPAddr              contained /\v<[0-9]{1,3}(.[0-9]{1,3}){,3}>/
hi def link     zoneIPAddr              Number

"   Plain IPv6 address          IPv6-embedded-IPv4 address
"   ::[...:]8                   ::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v\s@<=::((\x{1,4}:){,5}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,6}\x{1,4})>/
"   1111::[...:]8               1111::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){1}:((\x{1,4}:){,4}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,5}\x{1,4})>/
"   1111:2::[...:]8             1111:2::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){2}:((\x{1,4}:){,3}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,4}\x{1,4})>/
"   1111:2:3::[...:]8           1111:2:3::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){3}:((\x{1,4}:){,2}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,3}\x{1,4})>/
"   1111:2:3:4::[...:]8         1111:2:3:4::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){4}:((\x{1,4}:){,1}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,2}\x{1,4})>/
"   1111:2:3:4:5::[...:]8       1111:2:3:4:5::127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){5}:(([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,1}\x{1,4})>/
"   1111:2:3:4:5:6:7:8          1111:2:3:4:5:6:127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){6}(\x{1,4}:\x{1,4}|([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2})>/
"   1111:2:3:4:5:6::8           -
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){6}:\x{1,4}>/
"   1111[:...]::                -
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){1,7}:(\s|;|$)@=/
hi def link     zoneIP6Addr             Number

syn match       zoneBase64              contained /\v[[:space:]\n]@<=[a-zA-Z0-9\/\=\+]+(\s|;|$)@=/
hi def link     zoneBase64              Identifier

syn match       zoneHex                 contained /\v[[:space:]\n]@<=[a-fA-F0-9]+(\s|;|$)@=/
hi def link     zoneHex                 Identifier

syn match       zoneText                contained /\v"([^"\\]|\\.)*"(\s|;|$)@=/
hi def link     zoneText                String

syn match       zoneNumber              contained /\v<[0-9]+(\s|;|$)@=/
hi def link     zoneNumber              Number

syn match       zoneSerial              contained /\v<[0-9]{9,10}(\s|;|$)@=/
hi def link     zoneSerial              Special

syn match       zoneRR                  contained /\v[[:space:]\n]@<=[A-Z0-9]+(\s|;|$)@=/
hi def link     zoneRR                  Type

syn match       zoneErrParen            /\v\)/
hi def link     zoneErrParen            Error

syn region      zoneParen               contained start="(" end=")" contains=zoneBase64,zoneHex,zoneSerial,zoneNumber,zoneComment,zoneDomain,zoneRR

syn match       zoneComment             /\v\;.*/
hi def link     zoneComment             Comment

syn match       zoneUnknownType1        contained /\v\\\#/ nextgroup=zoneUnknownType2 skipwhite
hi def link     zoneUnknownType1        Macro
syn match       zoneUnknownType2        contained /\v\d+/ nextgroup=zoneUnknownType3 skipwhite
hi def link     zoneUnknownType2        Number
syn match       zoneUnknownType3        contained /\v[0-9a-fA-F\ ]+/
hi def link     zoneUnknownType3        String

let b:current_syntax = "bindzone"

" vim:sts=2 sw=2
