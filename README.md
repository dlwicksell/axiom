                             _          _       __  __
                            / \   __  _(_) ___ |  \/  |
                           / _ \  \ \/ / |/ _ \| |\/| |
                          / ___ \  >  <| | (_) | |  | |
                         /_/   \_\/_/\_\_|\___/|_|  |_|

                       A Vim plugin providing an Advanced
                  Developer Environment for MUMPS programmers
                -----------------------------------------------

# Axiom #

## Developer tools for editing M[UMPS]/GT.M routines in Vim ##

Version 0.20.13 - 2018 Aug 3

## Copyright and License ##

Package written and maintained by David Wicksell <dlw@linux.com>  
Copyright © 2011-2013,2018 Fourth Watch Software, LC

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License (AGPL)
as published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

***

## Summary and Info ##

Axiom is a package of developer tools that can help your productivity when
editing M[UMPS]/GT.M routines with the Vim editor, preferrably version 6.0 or
newer.

A colleague of mine, John Willis, has created a similar package of tools for
use with the Emacs editor. It is called *Lorikeem* and you can download it
from: <http://www.coherent-logic.com/products.html#lorikeem>.

Special thanks to Sam Habiel for encouraging me in my work on Axiom.

**ATTENTION:** This package was written and tested on Red Hat and Ubuntu Linux.
I can make no guarantees about other Operating Systems or Linux distributions.
I doubt that it will work, out of the box, on either a Windows or Mac system. I
have neither, so I can't even test them.

**NOTE:** In order to use the global dump functionality you must install
[GT.M][] and set the environment variables that GT.M requires.

**NOTE:** In order to use the mtags functionality, you must build a tags
file. In order to build the tags file with the included mktags shell script,
you will need to install the [exuberant-ctags][] program. In Debian/Ubuntu you
would install it via:

    $ sudo apt-get install exuberant-ctags

In Red Hat/CentOS you would install it via:

    $ sudo yum install ctags

You also have to use a version of ctags with regular expression support
compiled in, in order to build the tags file for MUMPS. To confirm that your
version is the correct one:

    $ ctags --version

Look for this line:

    Optional compiled features: +wildcards, +regex

***

## Installation ##

Any reference to Axiom in the commands below, may also have a version
number in it, either a version tag or a version hash.

To install this, you untar the tarball..

    $ tar -xfz axiom.tgz

Or unzip the zip file..

    $ unzip axiom.zip

Or, you can clone the repository with this command..

    $ hg clone https://bitbucket.org/dlw/axiom

Then you move to the resulting axiom/ directory..

    $ cd axiom/

Then you run the install script to install the Axiom utility scripts,
in the appropriate places, as well as create a .vimrc run command file,
or append or overwrite your current one. This is to ensure that the
package works correctly. It will also install a M[UMPS]/GT.m routine, which
is necessary to use the global dump functionality, as well as all the
documentation..

    $ ./install

To install in quiet mode, add the -q flag. This will allow you to install
Axiom non-interactively..

    $ ./install -q

**NOTE:** Using install in quiet mode will overwrite existing files that
are used by Axiom. Make sure that you have the $gtmroutines environment
variable defined, so that install -q will know where to put KBAWDUMP.m.

If you want to install Axiom manually, make sure you copy the following
files and directories to the right places at a minimum.
<MUMPS-source-directory> refers to a directory in your $gtmroutines
environment variable..

    $ cp axiom/KBAWDUMP.m <MUMPS-source-directory>/
    $ cp axiom/mktags ~/bin/
    $ cp axiom/vimrc ~/.vimrc
    $ cp -r axiom/vim ~/.vim/

If you are installing manually, you will also need to install the mktags and
KBAWDUMP man pages. For information on how to do that on your system, consult
the man page:

    $ man man

If you are installing manually, you will also need to install the axiom.txt
Vim help documentation. In a Vim editing session, type:

    :helptags ~/.vim/doc/

That is pretty much all there is to it. If you have questions on how to use
the mktags shell script, consult the man page..

    $ man mktags

If you have any questions on how to use the KBAWDUMP.m routine, consult the
man page..

    $ man KBAWDUMP

If you have questions on how to use any of the features of the Axiom
package, consult the Vim help page, built-in to the package, and accessible
inside of any Vim editing session..

    :help axiom

I hope you enjoy the Axiom package. If you have any questions, feature
requests, or bugs to report, please contact David Wicksell <dlw@linux.com>

### See Also ###

* The [GT.M][] implementation of MUMPS.
* The [Vim][] editor.
* The [exuberant-ctags][] tag file building program.

[GT.M]: http://sourceforge.net/projects/fis-gtm/
[Vim]: http://www.vim.org
[exuberant-ctags]: http://ctags.sourceforge.net/

### Package List ###
* *COPYING* - Copyright information
* *install* - Installation script for the Axiom package
* *KBAWDUMP.1* - Man page for KBAWDUMP
* *KBAWDUMP.m* - Routine to display all or some of a global's data
* *mktags* - Script to build a tag file for the mtags functionality
* *mktags.1* - Man page for mktags
* *README.md* - This README file
* *vimrc* - Sample .vimrc run command file
* *filetype.vim* - Script to set up a filetype by file extension
* *scripts.vim* - Script to set up a filetype by first line
* *axiom.txt* - Help documentation for Vim
* *html.vim* - Local settings for html files
* *datetime.vim* - Script to imprint a datetime stamp in MUMPS routines
* *globaldump.vim* - Script to call KBAWDUMP from within Vim
* *mcompile.vim* - Script to compile MUMPS routines, and display any errors
* *mstatus.vim* - Script to create a nice statusline for MUMPS routines
* *mtags.vim* - Script to call the tag file built by mktags
* *settings.vim* - Script to set up various settings for Axiom
* *xml.vim* - Local settings for xml files
* *templates.vim* - Script to call template files
* *mumps.vim* - Syntax file for M[UMPS]/GT.M routines
* *ewd.tpl* - Sample template for an EWD design page
* *m.tpl* - Sample template for a MUMPS routine
* *patterns.pat* - Script to set up key bindings to change patterns in templates

### Changelog ###
* Fixed a bug in mumps.vim
