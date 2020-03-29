Debugging Vim Syntax File
=========================

Of all the things that I have tried to do in order to debug a brand 
new syntax file for Vim editor, the following steps are my best and 
easiest to use and I hope they are to you as well.

this simple `vim named.conf` command will perform the following steps:

* load the content of the `named.conf` file, 
* makes note of its filename AND filetype, then 
* reads in all `ftdetect/*`files for any of its matching filename/filetype
* using `ftdetect/<filenametype_match>` that matched and flagged by filename/filetype
* loads corresponding `syntax/<filenametype_match>.vim` of highlighters
* reads syntaxes then displays highlighting

All that with just `vim <your-test-file>` command.

Preparing Your Home Settings
----------------------------

I use Dr. Chip [`hilinks.vim`](https://github.com/kergoth/vim-hilinks) to support my debugging effort during this Vim syntax development.

Starting Out Debugging
----------------------

Two terminal sessions are required for a successful debugging of any
new or changed Vim syntax.

#) Editing/saving the changed Vim syntax (`~/.vim/syntax/named.conf`) file
#) Re-viewing the target test-text (`named.conf`) file of its updated highlightings.

In the first terminal session, I did:
```bash
mkdir ~/.vim
mkdir ~/.vim/syntax
cp /usr/lib/vim/vim81/syntax/named.vim ~/.vim/syntax/
vim ~/.vim/syntax/named.vim
```

In a second terminal session, I cloned the target test-text file:

```bash
cp /etc/bind/named.conf /tmp/named.conf
vim /tmp/named.conf
```

In first terminal, I made a one-line change in `~/.vim/syntax/named.conf`,
saved it.

Then in second terminal, I edited my test-text `named.conf` file to see if I 
enhanced (or broke) something. 

Sure enough, I broke it ... rather badly.

Go back to the beginning and do it over with a new syntax setting.

Documentation, Ugh.
-------------------

In the very beginning, I was blindly making multiple syntax changes to 
my very own copy of an existing stock Vim syntax file.  
It wasn't intuitive (not at all) and its results were "unpleasant."

Back to reading all relevant (and not-so-relevant) Vim documents, they 
are (but not limited to):

* [Patterns](http://vimdoc.sourceforge.net/htmldoc/pattern.html)
* [Syntax](http://vimdoc.sourceforge.net/htmldoc/syntax.html)

Those two were really all I need but still woefully inadequate for 
rapid startup of a robust debugging session for its syntax file.

The more changes I made to my copy of the stock Vim syntax file, the more I
realized that I've got something brand new.  None of the existing stock syntax
exist anymore.  It's morphed enough to be on its own but with an MIT License.
  I've been incorporating over 143 pseudo-BNF syntaxes, as a result I've 
re-christened this file as `bind-named.vim` in order not to
conflict with the stock Vim syntax (`syntax/named.vim`) file.

Reloading New Changes
---------------------
As one makes a change to its Vim syntax file (now called 
`syntax/bind-named.vim`) in 1st terminal session, you need to refresh 
the viewing (2nd) terminal session with your new syntaxes.

One method is to perform exiting the current Vim edit session on 
the target file being highlighted (`named.conf`) and then restarting the same 
Vim editor session, has become rather tedious as:

In the "editing" (1st) terminal session, edit the syntax
(`~/.vim/syntax/bind-named.conf`) file and just simply save it:

```vim
(insert Vim editing keystrokes updating syntax)
```

and just save it (no need to quit the edit session):

```vim
:w
```

In the "viewing" (2nd) terminal session, exiting the vim editor:
```vim 
:q
```
then re-entering same edit session:
```bash
vim named.conf
```

That's your basic development cycle of creating/changing the Vim syntax file.

Note that there is no debugging or troubleshooting steps there.  It's a
blind-man approach of hit-or-miss affair.

Programming Function Keys
-------------------------
Do this blind-man development cycle about 10,000 times (OK, so I'm 
exaggerating here but the point stands),
and you'll desperately want for a single keystroke do all the work 
of 8 (tedious) keystrokes plus whatever the length of your test text file) 
after doing each and every single tweaking of your syntax file.

So let's go program some Vim function keys:

* Detail highlight used on current cursor
* Reload new syntax changes

Detail Highlight Function Key
-----------------------------

I programmed the F10 function key to do the following:

* F10 - Show which highlighter statement is being used at the current cursor

Stick this into your `vimrc` file (you remember where it is?):

```vim
" Show syntax highlighting macro at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
```

Now in your "viewing" (2nd) terminal session, the F10 key will show you 
which highlight syntax got used exactly where your cursor is currently at 
in your `named.conf` file.

Curious about a highlight that looks strange?  Move the cursor to where that
strange highlighting occurs at then press F10, and the status bar (at the
bottom of 2nd terminal screen) comes alive
with information showing:

```console
hi<> trans<> lo<>
```

This means none of the entire system's syntax file found a syntax match to 
where the cursor is at.

Let's move the cursor around a bit more, then press F10 again:

```console
hi<namedStmtKeyword> trans<namedStmtKeyword> lo<Statement>
```

This means `namedStmtKeyword` syntax was matched, transitioned from
`namedStmtKeyword`, and got highlighted with a color of `Statement`.

Show Me The Colors!
-------------------

I wanted to know what color was available in which I can use in my syntax;
to get the colors actually used for the test-text file, execute
in your "viewing" (2nd) Vim terminal for this example:

```vim
:syntax
```

Now you are seeing all the colors used for each statement (or lack thereof if
you have forgotten).  And its output is fed via Unix pipe through 
the `less` utility.  
Use spacebar/PgUp/PgDn/Up/Down to scroll through the entire 
pre-processed syntax file during this `:syntax` viewing.  Press `q` to quit.

Vim `:syntax` command is that first debugging tool showing you all the
highlight syntaxes and its coloring.  Very useful for 
one of final validations.

Reload Function Key
-------------------

For the second function (F12) key, I found that Vim 
reload (`:source $MYVIMRC`) command.  It's a nice command that
does the equivalence (but, as I've discovered, NOT EXACTLY THE SAME) 
thing of reloading your newly changed Vim syntax file during a typical 
development cycle as described in the first section of this page.

NOTE: There may be some commands like `:set ft=sh` in your `~/.vimrc` that 
WILL actually break the ability to cleanly reload your 
`syntax-file-under-test.vim` file: so, comment those out. I had to
do the basic divide-and-conquer of putting:

```vim
finish
```

throughout my `.vimrc` file until the breakage stop breaking then commented
out the offending lines (such as `set ft=sh` or `syntax off`).

The reload command basically rereads the `vimrc` files (there's more than 
one) which in turn reloads all applicable `syntax/*` files as 
determined by its 
filetype (`.vim/ftdetect/bind-named.vim`).  

You can see a total list of `vimrc` files that VIM checked and read before 
displaying the content of its file being edited.  I'll show you how to do
this recreation of that list:

```bash
script /tmp/vim.strace
vim named.conf
```

And then blindly type in `:q` to quit the edit session and exit Vim editor.
You can then scan for files that Vim opened by doing:

```bash
grep open /tmp/vim.strace | grep -v "No such file" | grep vim
```

That output list is:

```console
openat(AT_FDCWD, "/usr/share/vim/vimrc", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/debian.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/home/john/.vimrc", O_RDONLY) = 4
openat(AT_FDCWD, "/home/john/.vimrc.local", O_RDONLY|O_NONBLOCK) = 5
openat(AT_FDCWD, "/home/john/.vimrc.local", O_RDONLY) = 5
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syntax.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/synload.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/usr/share/vim/vim81/rgb.txt", O_RDONLY) = 9
openat(AT_FDCWD, "/usr/share/vim/vim81/filetype.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/home/john/.vim/ftdetect/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 8
openat(AT_FDCWD, "/home/john/.vim/ftdetect/bind-named.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/home/john/.vim/ftdetect/bindzone.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/home/john/.vim/ftdetect/bro.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/home/john/.vim/ftdetect/nftables.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/home/john/.vim/ftdetect/tatsu.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/home/john/.vim/colors/elflord.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/usr/share/vim/vim81/filetype.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/usr/share/vim/vim81/filetype.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/usr/share/vim/vim81/ftplugin.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syntax.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/nosyntax.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/synload.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/home/john/.vim/colors/elflord.vim", O_RDONLY) = 7
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 8
openat(AT_FDCWD, "/home/john/.vim/colors/elflord.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/home/john/.vim/syntax/syncolor.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/syncolor.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/usr/share/vim/vim81/pack/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/home/john/.vim/plugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/home/john/.vim/plugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/home/john/.vim/plugin/hilinks.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/autoloclist.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/balloons.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/checker.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/cursor.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/highlighting.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/loclist.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/modemap.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/notifiers.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/registry.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/signs.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/var/lib/vim/addons/autoload/syntastic/util.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/autoloclist.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/balloons.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/checker.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/cursor.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/highlighting.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/loclist.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/modemap.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/notifiers.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/registry.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/var/lib/vim/addons/plugin/syntastic/signs.vim", O_RDONLY) = 5
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/getscriptPlugin.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/gzip.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/logiPat.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/manpager.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/matchparen.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/netrwPlugin.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/rrhelper.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/spellfile.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/tarPlugin.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/tohtml.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/vimballPlugin.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/plugin/zipPlugin.vim", O_RDONLY) = 4
openat(AT_FDCWD, "/usr/share/vim/vim81/pack/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
openat(AT_FDCWD, "/home/john/.viminfo", O_RDONLY) = 5
openat(AT_FDCWD, "/home/john/.viminfo", O_RDONLY) = 6
openat(AT_FDCWD, "/home/john/.vim/ftplugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 6
openat(AT_FDCWD, "/usr/share/vim/vim81/ftplugin/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 6
openat(AT_FDCWD, "/usr/share/vim/vim81/syntax/named.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/var/lib/vim/addons/autoload/syntastic/log.vim", O_RDONLY) = 6
openat(AT_FDCWD, "/home/john/.viminfo", O_RDONLY) = 4
openat(AT_FDCWD, "/home/john/.viminfo.tmp", O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW, 0600) = 6
```

So you can see that there is many syntax files checked before decided on
`syntax/named.vim` due to `named.conf` filename/filetype detection
as determined by `ftdetect/named.conf`.

To perform single-key reloading of your 
`syntax-under-unit-test.vim` file, put this near at the end 
of your `~/.vimrc` of the file.

```vim
" Toggle reload of syntax files
" Didn't have desired effect on reloading syntax files; noremap <F12> <Esc>:source $MYVIMRC<CR>
"
noremap <F12> <Esc>:source $MYVIMRC<CR>
inoremap <F12> <C-o>:source $MYVIMRC<CR>
```

Now you have a reload function key at your very next Vim edit session.  
Any changes you make to your `~/.vim/syntax/<test.vim>` will immediately
show the changes made by your recent changes to highlight syntax(es).

I saved myself from doing 18 keystrokes and going back and forth 
between two different terminal sessions by using this new F10 keystroke.

Now its 1st terminal, Vim `:w` command.
And 2nd terminal, F12 key to reload new syntax file.
Back and forth.

Continuous Status 
-----------------

Then as more serious debugging work requires (as I was about on my 5th of 134
pseudo-BNF syntaxes), this hitting F10 on each cursor position was starting 
to drive me mad until I get a clearer picture.

Searching for a better solution, I found this HiLinkTrace (`hilinks`) 
Vim bundle from Charles Campbell (aka Dr. Chip).  It's an older version 
4 but it works on my latest Vim v8.1!

Update: There is a later version v4m at [Dr. Chip](http://www.drchip.org/astronaut/vim/vbafiles/hilinks.vba.gz) that is detailed on his [website](http://www.drchip.org/astronaut/vim/index.html#HILINKS).

But I got mine `git clone` from [Kergoth's Github](https://github.com/kergoth/vim-hilinks).

Files are in "VimBall" format and often denoted using `.vba` filetype.

If you go the Dr. Chip route, execute:

```bash
mkdir ~/.vim/bundle
cd ~/.vim/bundle/
wget http://www.drchip.org/astronaut/vim/vbafiles/hilinks.vba.gz
gunzip hilinks.vba.gz
```

If you got it from Github (or Dr. Chip), then also execute:

```bash
mkdir ~/.vim/bundle
git clone https://github.com/kergoth/vim-hilinks
cd vim-hilinks
vim hilinks.vba
```

And from either methods above, execute:

```vim
" execute the current file
:source %
```

It now installed! And ready for your next new Vim edit session.

Activating Live HiLinks Status
------------------------------

After that strange Vimball installation (remember, my lab is offline so 
remote updating within Vim plugins is not an option for me), I'm now 
starting up a new "viewing" (2nd) terminal session.

I see my highlighted keywords and identifiers in `bind-named.conf`.

To see the live status of where ever I move my cursor to, the current
status is displayed at the status bar below.  Activate this by executing:

```vim
:HLTm
```

The status bar comes alive with:

```console
SynStack:  namedStmtKeyword HltTrace: namedStmtKeyword->namedHLStatement->Statement fg<11> bg<>
```

My cursor was over the `acl` keyword when I saw the above status bar. The 
breakdown of the status bar is:

* `SynStack` - Syntax stack content
* `HltTrace` - Highlight tracing
* `fg` - Foreground color used
* `bg` - Background color used

For `SynStack`, the syntax stack content is `namedStmtKeyword`.  This means
that the nesting part of syntax calling other syntax (calling other syntax) is
one level deep.  First syntax encountered.  Nothing fancy.  Nice and simple.

For `HltTrace`, this is a function of which highlighting color got used.
Each level (`->`) is an alias of another level.  First one is the 
top-level highlight color name associated with the SynStack 
(coincidentally also named `namedStmtKeyword`).  Each alias takes us
closer to the actual color used.  `namedHLStatement` is a generic
`syntax/bind-named.vim`-specific alias.  And `Statement` is a default Vim
color.

For `fg` foreground color, it uses ANSI color 11.

And after some digging on the Internet, I show that Vim color code scheme to be:

```
The Vim colors are:
            0    black
            1    dark red
            2    dark green
            3    brown
            4    dark blue
            5    dark magenta
            6    dark cyan
            7    light grey
            8    dark grey
            9    red
            10   green
            11   yellow
            12   blue
            13   magenta
            14   cyan
            15   white
```

Bigger And Deeper
-----------------

As I developed more nested syntaxes and used longer syntax function name,
the one-line status bar got overrun and made a screen mess of things.

I fixed that by expanding the status bar into a 2-line status bar.

To activate a 2-line status at the bottom of your Vim terminal session 
and start showing your longer highlight debug information as you move 
your cursor around:

```bash
:set laststatus=2
```

That is all for now.
