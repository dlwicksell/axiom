" Package:       m-tools
" File:          scripts.vim
" Summary:       Scripts syntax file
" Version:       0.9.0
" Maintainer:    David Wicksell
" Last Modified: Nov 25, 2011
" Licence:       AGPL Ver 3 (or later)
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
" $Source: endor:/home/dlw/axiom/vim/scripts.vim $
" $Revision: [0:681a24778a9d] 2011-11-25 23:20 -0700 $
"
" This vim file was created to deal with a GT.M/EWD environment.
" It was inspired by earlier work by Jim Self <jaself@ucdavis.edu>.
"
" There is no .m or .ro extension, but it still looks like a MUMPS routine.


"Don't set the filetype if it is already set
if did_filetype()
  finish
endif

"A standard first line in a MUMPS routine, but don't want to go too far
if getline(1) =~ '^%\?[A-Za-z0-9]\+\s\+;\|^;'
  setfiletype mumps
endif


" $RCSfile: scripts.vim $
