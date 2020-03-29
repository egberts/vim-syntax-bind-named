Installing Vim Syntax File
==========================

Of all the things that I have tried to do in order to debug a brand 
new syntax file for Vim editor, the following steps are my best and 
easiest to use and I hope they are to you as well.

Preparing Your Home Settings
----------------------------

If you do not have a `.vim` subdirectory in your `$HOME` directory, 
create that subdirectory:

```bash
mkdir $HOME/.vim
````
If you do not have a `syntax` or `ftdetect` subdirectory under that `.vim` directory, create one:

```bash
mkdir $HOME/.vim/syntax
mkdir $HOME/.vim/ftdetect
```

Copying Vim Syntax Files
------------------------
Copy the Vim syntax files from my github repository into your Vim local
settings:

```bash
cd $HOME/myworkspace
git clone https://github.com/egberts/vim-syntax-bind-named
cp -R vim-syntax-bind-named/syntax/* ~/.vim/syntax/
cp -R vim-syntax-bind-named/ftdetect/* ~/.vim/ftdetect/
```

See the Highlightings
---------------------
To highlighting in action, use the enclosed test file for highlighting of ISC Bind named configuration file:

```bash
vim vim-syntax-bind-named/example-named.conf
```


