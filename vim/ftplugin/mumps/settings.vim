" Package:       Axiom
" File:          settings.vim
" Summary:       Configuration settings script
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: July 11, 2012
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
" This is a companion script to the mumps.vim syntax highlighting file.
" It sets up certain options in Vim that are required for that file to
" work properly. It also sets up some options for the globaldump.vim and
" mtags.vim scripts. When you leave a mumps buffer it puts everything that
" it changed back to the way it was.
"
" It binds Ctl-N to toggle on and off syntax folding of dotted do blocks.
" It defaults to off.


if exists("s:did_set_ftplugin")
  finish
endif

function! StartSyntax() "set necessary syntax options in one place
  setlocal tags+=~/.mtags,~/mtags "add the tags files for the Axiom package
  "required to define mumps intrinsic functions and special variables
  setlocal iskeyword+=$

  "turn off folding, and use the toggle bound to Ctl-N to turn it back on
  setlocal nofoldenable "setlocal isn't necessary, but doesn't hurt
  setlocal foldmethod=syntax "setlocal isn't necessary, but doesn't hurt

  setlocal nolinebreak "wraps lines

  "turn off matching brackets and braces while in a mumps buffer
  "affects the % command
  setlocal matchpairs=(:)

  let s:oldshowbreak = &showbreak
  set showbreak=>> "shows that lines have wrapped

  "add an extra virtual column, so that tag jumps work properly at line ends
  "in normal mode, x doesn't quite function the same way with 'onemore' set
  if &virtualedit =~ "onemore"
    let s:onemore = 1
  else
    let s:onemore = 0
    set virtualedit+=onemore "X in normal mode behaves slightly differently
  endif

  "set this variable to 1 if you want a split screen view of dumped globals
  "or set it to 0 or comment it out if you don't want a split screen
  let b:globalsplit = 1

  "uncomment the next 2 commands to turn on the M Statusline by default
  "setlocal statusline=%!MTagStatusLine()
  "setlocal laststatus=2

  "uncomment the next 2 commands to turn on the auto-update feature by default
  "autocmd CursorMoved <buffer> update
  "autocmd CursorMovedI <buffer> update
endfunction

"clean up the syntax options and put things back the way they were
function! EndSyntax()
  let &showbreak = s:oldshowbreak

  if s:onemore == 0
    set virtualedit-=onemore
  endif
endfunction

function! FoldToggle() "enables toggling of folding the mumpsBlock
  if &foldenable
    set nofoldenable

    echohl ModeMsg
    echo "Syntax folding disabled"
    echohl None
  else
    set foldenable

    echohl ModeMsg
    echo "Syntax folding enabled"
    echohl None
  endif
endfunction

"define a key mapping, bound to Ctl-N, in order to toggle mumpsBlock folding
"defaults to off above
au BufEnter <buffer> nnoremap <silent> <buffer> <C-N> :call FoldToggle()<CR>

"lots of small configuration details need to be set for syntax
autocmd BufEnter <buffer> call StartSyntax()
autocmd BufLeave <buffer> call EndSyntax()

let s:did_set_ftplugin = 1
