vim-syntax-bind-named
=====================

This project aims to replace the stock Vim syntax highlighting for ISC Bind
(`named.vim`), by updating it to recognize the new RRs that came out in
the last few decade and also to highlight more keywords that ISC Bind9/10 has
incorporated as of late.

![Example](https://raw.githubusercontent.com/egberts/gist/master/vim-syntax-bind-named-front-page.png "Example")

As comment lines throughout this `bind-named.vim` syntax file, I incorporate
nearly all the revised psuedo-BNF syntax for every `named.conf` statement
keywords encountered.  These psuedo-BNF syntax may (often) not match the
official ISC Bind documentation because its C source code
takes final precedence here.

FEATURES
--------

* new `named.conf` keywords supported
* All 3 comment styles supported: C++, C, bash.
* IPv6 syntax checking
 * link-local IPv6 addresses with zone numeric and name index
 * IPv4-mapped IPv6 addresses and IPv4-translated addresses
 * IPv4-Embedded IPv6 Address
* a comprehensive test named.conf file for later tweaking of this syntax file.
* Bold-Highlighting TODO, FIXME, and XXX in comment lines.
* Supports many include statements for large enterprise (or whitelabs).
* New filetype detections
 * `rndc.conf` Filetype detection
 * supports `rndc.key`
 * Still supports named.conf
* Filetype detection, both expanded (and constrained)
 * Constrained to `named-*.conf` from `named*.conf`
 * Constrained to `named_*.conf` from `named*.conf`
 * Constrained to `named.*.conf` from `named*.conf`
 * Expanded to `*-named.conf`
 * Expanded to `*_named.conf`
 * Expanded to `*.named.conf`
 * Expanded to `rndc_*.conf`
 * Expanded to `rndc-*.conf`
 * Expanded to `rndc.*.conf`
 * Expanded to `*_rndc.conf`
 * Expanded to `*-rndc.conf`
 * Expanded to `*.rndc.conf`
* support for Array-type ACL names.

Filetype Constraints/Expansion
------------------------------
The `rndc.conf` is now supported (along with its filename variants, as long as
as the filename portion begins with `rndcX` or ends with `Xrndc` and the letter
X signifies a period, an underscore, or a dash/minus symbol.

There's a namedXXXXX.conf out there being used by a database so I figured
we constrained it a bit with a dash, an underscore, or a period symbol.

In my huge internal whitelab bastion server, I run two separate named daemon
and its configuration files, they all get included into their respective
`named-XXXX.conf`:

    /etc/bind/named-public.conf
    /etc/bind/public/acl-named.conf
    /etc/bind/public/channels-named.conf
    /etc/bind/public/controls-named.conf
    /etc/bind/public/dnssec-keys-named.conf
    /etc/bind/public/masters-named.conf
    /etc/bind/public/options-named.conf
    /etc/bind/public/servers-named.conf
    /etc/bind/public/statistics-named.conf
    /etc/bind/public/view.red
    /etc/bind/rndc-public.conf

    /etc/bind/named-internal.conf
    /etc/bind/internal/options-named.conf
    /etc/bind/internal/acl-named.conf
    /etc/bind/internal/channels-named.conf
    /etc/bind/internal/controls-named.conf
    /etc/bind/internal/masters-named.conf
    /etc/bind/internal/view.red
    /etc/bind/internal/view.dmz
    /etc/bind/internal/view.yellow
    /etc/bind/internal/view.green
    /etc/bind/rndc-internal.conf

Array-Type ACL Names
--------------------
Imagine my surprise in the current Bind version that ACL names can
support some form of Python/C/C++ language array naming convention.

Yeah, ACL names like:
```named
acl my_firewall[red][zoom] { acl_conference_rooms; };
acl my_firewall[red][facetime] { acl_conference_rooms; };
acl my_firewall[red][signal] { acl_conference_rooms; };
```
Pretty cool, uh?


IPv6 Patterns Supported
-----------------------
The following patterns for IPv6 addresses are supported:

 * 1:2:3:4:5:6:7:8
 * 1::  1:2:3:4:5:6:7::
 * 1::8  1:2:3:4:5:6::8  1:2:3:4:5:6::8
 * 1::7:8  1:2:3:4:5::7:8  1:2:3:4:5::8
 * 1::6:7:8  1:2:3:4::6:7:8  1:2:3:4::8
 * 1::5:6:7:8  1:2:3::5:6:7:8  1:2:3::8
 * 1::4:5:6:7:8  1:2::4:5:6:7:8  1:2::8
 * 1::3:4:5:6:7:8  1::3:4:5:6:7:8  1::8
 * ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8  ::
 * fe80::7:8%eth0  fe80::7:8%1
 * ::255.255.255.255  ::ffff:255.255.255.255  ::ffff:0:255.255.255.255
 * 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33

PLANS
-----

I plan to:

* replace the stock Vim `bindzone.vim`, but that is something that I
  would welcome anyone to submit ... easily.
  Instead, I'm focused on doing this hard problem of creating these
  syntaxes for `bind-named.vim` (Bind named configuration file).

* make this work steadily across ALL versions of Bind, but in
  starting with the current v9.16 and then OUTWARD toward v4 and
  v10: I managed to do this mostly.

* NOT to make a Vim bundle zip file (for remote upgrading/downloading):
  I work offline and my whitelab is offline, so someone else is more than
  welcome to do the bunzip'ing.

* make the FINAL CALL here for this syntax development using its C source
  code.  Mistakes will be made: I'm human too.  ISC Bind9 documentation
  project is not something to rely on when devising this VIM syntax for
  its named configuration file.
  I do have ALL released (and some minor) versions of Bind4, Bind8,
  Bind9, and Bind10 documentation as well as its source code.

I maintain those lifetime of keywords for `named.conf` and its many
characteristics into my Pythonized ISC Bind keyword dictionary maintained over
at [egberts' repo at Github](https://github.com/egberts/bind9_parser/blob/master/examples/rough-draft/namedconfglobal.py).  
Some Python database characteristics for each keywords are:

* statement occurance count
* occurs multiple times
* default value
* validity of value methods
* found-within which other statement
* multi-line-ordering ID
* user-defined indices
* top-level statement flag
* output ordering ID
* introduced in which version
* obsoleted by which version
* keyword topic
* server-type
* required statement flag
* subordering matter flag
* Python dictionary indice by name


Bug Reporting
-------------
If you have any issues with this syntax file, see if you can:

* keep narrowing down the offending line until it stopped offending, hopefully
  it is just to just one (or few) lines.  No need to expose your entire `named.conf`
  Don't forget to change all IP addresses (unless that breaks too) for
  your privacy sake.

* post/file the offending line over at my [Github issue](https://github.com/egberts/vim-syntax-bind-named/issues). 

* detail the wrong highlight and state what you think is to be its
  correct highlight, if applicable.


Debugging Vim Syntax
--------------------
If you are bold enough to try your hand on debugging Vim syntax file,
see my [DEBUG.md](https://github.com/egberts/vim-syntax-bind-named/blob/master/DEBUG.md) on how to debug a Vim syntax file.

Install
-------
See [INSTALL.md](https://github.com/egberts/vim-syntax-bind-named/blob/master/INSTALL.md) on how to install this Vim syntax to your local Vim settings.

To Vim Developers
-----------------
Note to Vim developers:  During the prototyping of my IPv6 address
syntax matching, I noticed that vim 8.1 can only support a maximum
of 9 groupings of parenthesis, even if I used the "\%( ... \)"
notation (instead of "\( ...\)").

As a result of this Vim limitation, I've had to
duplicate IPv6 match patterns through this syntax file to get around
this vim 8.1 limitation.  But it works and faster so.


