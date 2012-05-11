" Package:       Axiom
" File:          templates.vim
" Summary:       Template loader script
" Maintainer:    David Wicksell
" Last Modified: May 10, 2012
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
" Script to automatically load any template file stored in
" ~/.vim/templates with a .tpl extension.
"
" Will also execute ex commands in a script called patterns.pat,
" connected with a particular extension. In order to use the
" patterns.pat script, you should make a symbolic link to it in
" the ~/.vim/templates directory called <filetype>.pat. E.g.
"
"     ln -s patterns.pat ewd.pat
"     ln -s patterns.pat m.pat
"
" NOTE: An EWD and MUMPS template is included as an example,
"   ~/.vim/templates/ewd.tpl and ~/.vim/templates/m.tpl
" Please change the headers and licensing information to your own.
"
" NOTE: Templates are turned off by default, please uncomment the
" autocmd below in order to turn them on.


function! LoadTemplate(extension)
  "read the template for an extension into the new file at the top
  silent! execute '0read ~/.vim/templates/' . a:extension . '.tpl'
  "execute the ex commands in the patterns files, changing the macros
  silent! execute 'source ~/.vim/templates/' . a:extension . '.pat'
endfunction

"uncomment this autocmd line to use templates
"autocmd BufNewFile * silent! call LoadTemplate('%:e')
