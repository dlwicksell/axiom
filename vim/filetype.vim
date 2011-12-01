" Package:       M-tools
" File:          filetype.vim
" Summary:       Filetype syntax file
" Maintainer:    David Wicksell
" Last Modified: Dec 01, 2011
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
" This Vim file was created to deal with a GT.M/EWD environment.
" It was inspired by earlier work by Jim Self <jaself@ucdavis.edu>.
"
" Set the filetype to mumps if its extension is .m or .ro, to xml
" if its extension is .ewd, and to tags if it is a custom tag file
" created by the mktags shell script.
"
" Added .rsa and .RSA for Caché routine save archive files and .pat
" for pattern scripts created for template files, of which a couple
" of examples are included in this package.


augroup filetypedetect

"GT.M source files
autocmd! BufRead,BufNewFile *.m setfiletype mumps

"GT.M routine out files
autocmd! BufRead,BufNewFile *.ro setfiletype mumps

"Caché routine save archive - import only!
autocmd! BufRead,BufNewFile *.rsa setfiletype mumps
autocmd! BufRead,BufNewFile *.RSA setfiletype mumps

"EWD design pages, either xml or html will work
autocmd! BufRead,BufNewFile *.ewd setfiletype xml

"tags files for the M-tools package
autocmd! BufRead,BufNewFile mtags setfiletype tags
autocmd! BufRead,BufNewFile .mtags setfiletype tags

"patterns ex script, associated with template files
autocmd! BufRead,BufNewFile *.pat setfiletype vim

"markdown file defaults to modula2, which we don't want
"most text files default to conf
autocmd! BufRead,BufNewFile *.md setfiletype conf

augroup END
