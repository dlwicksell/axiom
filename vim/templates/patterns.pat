" Package:       Axiom
" File:          patterns.pat
" Summary:       template patterns script for MUMPS/GT.M
" Maintainer:    David Wicksell
" Last Modified: Jul 11, 2012
"
" Written by David Wicksell <dlw@linux.com>
" Copyright © 2011,2012 Fourth Watch Software, LC
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
" Script to jump from pattern to pattern and make changes for each template.
"
" This is the master pattern script. You should make symbolic links for every
" template file you have to this one, each ending in .pat, in the
" ~/.vim/templates directory. E.g.
"     ln -s patterns.pat m.pat
"     ln -s patterns.pat ewd.pat


"key mapping, bound to ",,", to jump from pattern to pattern
nnoremap <silent> <buffer> ,, /<+.\{-}+><CR>
"key mapping, bound to ",.", to quickly change the patterns
nnoremap <buffer> ,. cf>
