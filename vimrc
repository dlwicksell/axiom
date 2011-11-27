" Package:       m-tools
" File:          .vimrc
" Summary:       Sample .vimrc for the m-tools package
" Maintainer:    David Wicksell
" Last Modified: Nov 25, 2011
"
" Written by David Wicksell <dlw@linux.com>
" Copyright © 2011 Fourth Watch Software, LC
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU Affero General Public License (AGPL)
" as published by the Free Software Foundation, either version 3 of
" the License, or (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
" GNU Affero General Public License for more details.
"
" You should have received a copy of the GNU Affero General Public License
" along with this program. If not, see http://www.gnu.org/licenses/.
"
" My personal .vimrc settings. Make sure to turn on filetype, if it isn't
" on already. I think that vim is nearly perfectly configured out of the
" box, which is why my .vimrc is small. 


"personal settings that I prefer
set autoindent
set expandtab
set smarttab
set nohlsearch
set nomodeline
set more
set tabstop=4
set softtabstop=4
set shiftwidth=4
set tabpagemax=20

"turn on filetype in order to seamlessly use the m-tools package
if v:version >= 600
  "turn on syntax and automatic filetype detection
  syntax enable

  filetype on
  filetype detect
  filetype plugin on
  filetype indent on
else
  "turn on syntax and source the m-tools utility functions
  syntax on

  source ~/.vim/ftplugin/mumps/datetime.vim
  source ~/.vim/ftplugin/mumps/globaldump.vim
  source ~/.vim/ftplugin/mumps/mtags.vim
  source ~/.vim/ftplugin/mumps/syntax.vim
endif
