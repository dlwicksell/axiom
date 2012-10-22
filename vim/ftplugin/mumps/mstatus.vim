" Package:       Axiom
" File:          mstatus.vim
" Summary:       Show a status line for MUMPS routines
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Oct 22, 2012
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
" command that will turn the status line on or off, as well as the update
" ability on or off. MStatus defaults to 'on', and auto-updating to 'off'.


if exists("b:did_ms_ftplugin")
  finish
endif

if !exists("*MTagStatusLine") "don't define the same function twice
  function! MTagStatusLine() "set a nice status line for a MUMPS routine
    if filereadable(bufname("%"))
      "build a dictionary of the current routine's labels
      let l:labels = {}
      let l:count = 0 "start with 0, because of recursive function call bug

      if empty(readfile(bufname("%")))
        return "%f\ %h%m%r\ %=%-15(%l,%c%V%)%P"
      endif

      for l:line in readfile(bufname("%"))
        let l:match = matchstr(l:line, "[%A-Za-z0-9]*")

        if l:match != ""
          let l:labels[l:count] = l:match
        endif

        let l:count += 1
      endfor

      let l:file = tr(expand("%:t:r"), "_", "%")
      let l:prevLabel = 0
      let l:tag = ""

      for l:curLabel in keys(l:labels)
        if line(".") > l:curLabel && l:curLabel >= l:prevLabel
          let l:tag = l:labels[l:curLabel]
          let l:prevLabel = l:curLabel + 1 "add 1 because count starts with 0
        endif
      endfor

      let l:offset = line(".") - l:prevLabel

      if l:tag != "" && line(".") != l:prevLabel
        let l:tag = l:tag . "+" . l:offset
      endif

      "added to fix issue with status line being fired before BufLeave events
      if expand("%:t") !~ "\\.m$" || l:tag == ""
        return "%f\ %h%m%r\ %=%-15(%l,%c%V%)%P"
      else
        let l:tag = substitute(l:tag, "%", "%%", "")
        let l:file = substitute(l:file, "%", "%%", "")

        return l:tag . "^" . l:file . "\ %h%m%r\ %=%-15(%l,%c%V%)%P"
      endif
    else
      return "%f\ %h%m%r\ %=%-15(%l,%c%V%)%P"
  endfunction
endif

if !exists("*MTagStatus") "don't define the same function twice
  "turn the M Statusline and auto-updating on or off
  function! MTagStatus(value)
    let l:value = a:value
    let l:value = tolower(l:value)

    if l:value == "?"
      echohl ModeMsg
      echo ":MStatus on|off|update|noupdate"
      echohl None
    elseif l:value == "on"
      set statusline=%!MTagStatusLine() "setlocal doesn't work on 700 or older?
      set laststatus=2 "setlocal doesn't work

      echohl ModeMsg
      echo "M Statusline on"
      echohl None
    elseif l:value == "off"
      set statusline="" "setlocal doesn't work on 700 or older?
      set laststatus=1 "setlocal doesn't work

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
endif

"set up a command to turn on or off the M Statusline and auto-updating options
au BufEnter <buffer> command! -nargs=? -buffer MStatus call MTagStatus(<q-args>)

let b:did_ms_ftplugin = 1
