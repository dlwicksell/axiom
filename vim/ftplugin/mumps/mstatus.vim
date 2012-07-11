" Package:       Axiom
" File:          mstatus.vim
" Summary:       Show statusline for MUMPS routines
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Jul 11, 2012
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
" Creates a status line which tracks the MUMPS label plus offset of the
" routine. It also sets up the ability to have it dynamically updated while
" editing if the file has been modified and the cursor has moved. Creates a
" command that will turn the statusline on or off, as well as the update
" ability on or off. Both default to off.


if exists("s:did_ms_ftplugin")
  finish
endif

function! MTagStatusLine() "set a nice statusline for a MUMPS routine
  if filereadable(bufname("%"))
    "build a dictionary of the current routine's labels
    let s:labels = {}
    let s:count = 0 "start with 0, because of recursive function call bug

    if empty(readfile(bufname("%")))
      return "%f\ %h%m%r\ %=%-15(%l,%c%V%)%P"
    endif

    for s:line in readfile(bufname("%"))
      let s:match = matchstr(s:line, "[%A-Za-z0-9]*")

      if s:match != ""
        let s:labels[s:count] = s:match
      endif

      let s:count += 1
    endfor

    unlet s:line
    unlet s:match
    unlet s:count

    let l:file = tr(expand("%:t:r"), "_", "%")
    let l:prevLabel = 0
    let l:tag = ""

    for l:curLabel in keys(s:labels)
      if line(".") > l:curLabel && l:curLabel >= l:prevLabel
        let l:tag = s:labels[l:curLabel]
        let l:prevLabel = l:curLabel + 1 "add 1 because count starts with 0
      endif
    endfor

    let l:offset = line(".") - l:prevLabel

    if l:tag != "" && line(".") != l:prevLabel
      let l:tag = l:tag . "+" . l:offset
    endif

    "added to fix issue with statusline being fired before BufLeave events
    if expand("%:t") !~ "\\.m$" || l:tag == ""
      return "%f\ %h%m%r\ %=%-15(%l,%c%V%)%P"
    else
      return l:tag . "^" . l:file . "\ %h%m%r\ %=%-15(%l,%c%V%)%P"
    endif
  else
    return "%f\ %h%m%r\ %=%-15(%l,%c%V%)%P"
endfunction

"turn the M Statusline and auto updating on or off
function! MTagStatus(value)
  let l:value = a:value
  let l:value = tolower(l:value)

  if l:value == "?"
    echohl ModeMsg
    echo ":MStatus on|off|update|noupdate"
    echohl None
  elseif l:value == "on"
    setlocal statusline=%!MTagStatusLine()
    setlocal laststatus=2

    echohl ModeMsg
    echo "M Statusline on"
    echohl None
  elseif l:value == "off"
    setlocal statusline=""
    setlocal laststatus=1

    echohl ModeMsg
    echo "M Statusline off"
    echohl None
  elseif l:value == "update"
    autocmd CursorMoved <buffer> update
    autocmd CursorMovedI <buffer> update

    echohl ModeMsg
    echo "M Statusline auto-update enabled"
    echohl None
  elseif l:value == "noupdate"
    autocmd! CursorMoved <buffer>
    autocmd! CursorMovedI <buffer>

    echohl ModeMsg
    echo "M Statusline auto-update disabled"
    echohl None
  else
    echohl ErrorMsg
    echo "MStatus: Invalid option: '" . l:value . "': Try '?' for options"
    echohl None
  endif
endfunction

"set up a command to turn on the M Statusline and autosave updating
au BufEnter <buffer> command! -nargs=1 -buffer MStatus call MTagStatus(<q-args>)

let s:did_ms_ftplugin = 1
