" Package:       Axiom
" File:          settings.vim
" Summary:       Configuration settings script
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Dec 22, 2012
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
" work properly. It also sets up some options for the globaldump.vim,
" mtags.vim, and mstatus.vim scripts. When you leave a mumps buffer it
" puts everything that it changed back to the way it was.
"
" There is also a key mapping, bound to CTRL-N, which will cycle through
" several modes for syntax folding. It defaults to 'none'.


if exists("b:did_set_ftplugin")
  finish
endif

if !exists("*StartSyntax") "don't define the same function twice
  function! StartSyntax() "set necessary syntax options in one place
    setlocal tags+=mtags,~/.mtags "add the tags files for the Axiom package
    "required to define mumps intrinsic functions and special variables
    setlocal iskeyword+=$
    setlocal iskeyword-=_ "fix for the intrinsic function bug

    set foldmethod=syntax

    setlocal nolinebreak "wraps lines properly

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

    "***USER CONFIG STARTS HERE***

    "set this variable to control which folding mode is on by default
    "valid options are 'comment', 'do', 'both', or 'none'
    let b:mumpsfoldingmode = "none"

    "set this variable to 1 if you want a split screen view of dumped globals
    "or set it to 0 or comment it out if you don't want a split screen
    let b:globalsplit = 1

    "set this variable to 'horizontal' if you want a horizontal split screen
    "or set it to 'vertical' or comment it out if you want it to be vertical
    "NOTE - This option is ignored if globalsplit mode is turned off
    let b:splittype = "horizontal"

    "comment out the next 2 commands to turn off the MStatus Line
    "or leave them uncommented to keep the MStatus Line on
    if v:version >= 700 "setlocal doesn't work on older than 700?
      setlocal statusline=%!MTagStatusLine()
    else
      set statusline=%!MTagStatusLine()
    endif

    set laststatus=2 "setlocal doesn't work

    "uncomment the next 2 commands to turn on the auto-update feature
    "or leave them commented to keep the auto-update feature off
    "autocmd CursorMoved <buffer> update
    "autocmd CursorMovedI <buffer> update

    "***USER CONFIG ENDS HERE***

    if b:mumpsfoldingmode == "none"
      set nofoldenable

      syntax clear mumpsCommentBlock
      syntax clear mumpsDoBlock
    elseif b:mumpsfoldingmode == "comment"
      set foldenable

      syntax clear mumpsDoBlock
    elseif b:mumpsfoldingmode == "do"
      set foldenable

      syntax clear mumpsCommentBlock
    else
      set foldenable
    endif
  endfunction
endif

if !exists("*EndSyntax") "don't define the same function twice
  "clean up the syntax options and put things back the way they were
  function! EndSyntax()
    let &showbreak = s:oldshowbreak

    if s:onemore == 0
      set virtualedit-=onemore
    endif

    "comment out the next command whenever you comment out the MStatus Line
    if v:version >= 700 "setlocal doesn't work on older than 700?
      setlocal statusline=""
    else
      set statusline=""
    endif

    set laststatus=1 "setlocal doesn't work
  endfunction
endif

if !exists("*FoldMode") "don't define the same function twice
  function! FoldMode() "switches mumps folding mode
    "tests for the previous mode, not the current one
    if b:mumpsfoldingmode == "both"
      set foldenable
    else
      set foldenable

      "set up variables for sourcing a part of the syntax file
      unlet b:current_syntax
      let b:mumps_syntax = 1

      "need to re-source previously cleared syntax regions
      runtime syntax/mumps.vim
    endif

    "tests for the previous mode, not the current one
    if b:mumpsfoldingmode == "none"
      syntax clear mumpsDoBlock

      echohl ModeMsg
      echo "MUMPS Comment Blocks folded"
      echohl None

      let b:mumpsfoldingmode = "comment" "set current mode
    elseif b:mumpsfoldingmode == "comment"
      syntax clear mumpsCommentBlock

      echohl ModeMsg
      echo "MUMPS Do Blocks folded"
      echohl None

      let b:mumpsfoldingmode = "do" "set current mode
    elseif b:mumpsfoldingmode == "do"
      echohl ModeMsg
      echo "MUMPS Comment Blocks and Do Blocks folded"
      echohl None

      let b:mumpsfoldingmode = "both" "set current mode
    elseif b:mumpsfoldingmode == "both"
      syntax clear mumpsCommentBlock
      syntax clear mumpsDoBlock

      echohl ModeMsg
      echo "Syntax folding disabled"
      echohl None

      let b:mumpsfoldingmode = "none" "set current mode
    endif
  endfunction
endif

"define a key mapping, bound to Ctl-N, in order to cycle mumps folding modes
"defaults to 'none'
autocmd BufEnter <buffer> nnoremap <silent> <buffer> <C-N> :call FoldMode()<CR>

"lots of small configuration details need to be set for syntax
autocmd BufEnter <buffer> call StartSyntax()
autocmd BufLeave <buffer> call EndSyntax()

let b:did_set_ftplugin = 1
