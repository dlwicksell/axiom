" Package:       Axiom
" File:          xml.vim
" Summary:       Settings for xml indentation
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Aug 11, 2012
"
" Written by David Wicksell <dlw@linux.com>
" Copyright © 2012 Fourth Watch Software, LC
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
" Local settings for xml indentation


if exists("b:did_xml_ftplugin")
  finish
endif

setlocal softtabstop=2
setlocal shiftwidth=2

let b:did_xml_ftplugin = 1
