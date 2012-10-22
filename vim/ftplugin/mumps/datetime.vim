" Package:       Axiom
" File:          datetime.vim
" Summary:       Auto datetime stamp for MUMPS routines
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Oct 21, 2012
"
" Written by David Wicksell <dlw@linux.com>
" Copyright © 2010-2012 Fourth Watch Software, LC
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
" Imprints a Datetime stamp in either new or old VPE formats,
" at the end of the first line.
"
" Added a toggle in normal mode, bound to Ctl-H that will toggle
" the DateTime stamp on and off. When entering a mumps buffer it
" defaults to on.


if exists("b:did_dt_ftplugin")
  finish
endif

if !exists("*DateTime") "don't define the same function twice
  "sets the MUMPS routine to the current datetime
  function! DateTime()
    if &modified "only update the datetime stamp if you've modified the buffer
      "- narrows the specifier to 1 character, to match VPE's datetime stamp
      let l:dt = strftime("%-m/%-d/%y %-I:%M%P")
      let l:gl = getline(1)

      if l:gl =~ "^.*]$" "old datetime stamp format
        call setline(1, strpart(l:gl, 0, strridx(l:gl, "[")) . "[" . l:dt . "]")
      elseif l:gl =~ "^.*;$" "no current datetime stamp
        call setline(1, l:gl . " " . l:dt)
      elseif l:gl =~ "^.*/.*/.*:.*$" "overwrite the current datetime stamp
        call setline(1, strpart(l:gl, 0, strridx(l:gl, ";")) . "; " . l:dt)
      else
        call setline(1, getline(1) . " ; " . l:dt)
      endif
    endif
  endfunction
endif

if !exists("*DateTimeToggle") "don't define the same function twice
  "toggles the automatic datetime stamp on or off
  function! DateTimeToggle()
    "if you define more bufwrite autocommands for mumps, this will turn them off
    if exists("#BufWrite#<buffer>") "check if there is a BufWrite autocommand
      autocmd! BufWrite <buffer>

      echohl ModeMsg
      echo "DateTime stamp is off"
      echohl None
    else
      autocmd BufWrite <buffer> call DateTime()

      echohl ModeMsg
      echo "DateTime stamp is on"
      echohl None
    endif
  endfunction
endif

"define a key mapping, bound to Ctl-H, in order to toggle datetime stamping
au BufEnter <buffer> nnoremap <silent> <buffer> <C-H> :call DateTimeToggle()<CR>
"defaults to on
autocmd BufWrite <buffer> call DateTime()

let b:did_dt_ftplugin = 1
