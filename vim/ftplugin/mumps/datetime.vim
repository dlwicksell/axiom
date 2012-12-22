" Package:       Axiom
" File:          datetime.vim
" Summary:       Auto datetime stamp for MUMPS routines
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Dec 22, 2012
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
" Imprints a datetime stamp, where the date is in ISO 8601 format,
" and the time is in a fairly standard format, at the end of the
" first line.
"
" It puts the datetime stamp in a location that follows the VISTA
" SAC. If you are not editing a VISTA routine, you may either turn
" this functionality off, by commenting out the autocmd at the
" bottom of this script, or it will just put it in the 3rd ';'
" piece, adding ';' characters, if needed.
"
" Added a toggle in normal mode, bound to Ctl-H that will toggle
" the datetime stamp on and off. When entering a mumps buffer it
" defaults to on.


if exists("b:did_dt_ftplugin")
  finish
endif

if !exists("*DateTime") "don't define the same function twice
  "sets the MUMPS routine to the current datetime
  function! DateTime()
    if &modified "only update the datetime stamp if you've modified the buffer
      "if the strftime library function doesn't exist, skip this functionality
      if exists("*strftime")
        let l:dt = strftime("%F  %-I:%M %p")
      else
        finish
      endif

      let l:gl = getline(1)

      if l:gl =~ "^[^;]*$" "no SAC compliant information
        call setline(1, getline(1) . ";;" . l:dt)
      elseif l:gl =~ "^[^;]*;[^;]*$" "no current datetime stamp
        call setline(1, getline(1) . ";" . l:dt)
      elseif l:gl =~ "^[^;]*;[^;]*;[^;]*$" "overwrite the current datetime stamp
        call setline(1, strpart(l:gl, 0, strridx(l:gl, ";")) . ";" . l:dt)
      else "too many ';' pieces - not SAC compliant
        let l:linelist = split(l:gl, ";")
        let l:linelist[2] = l:dt

        if l:gl =~ "^.*;$"
          call setline(1, join(l:linelist, ";") . ";")
        else
          call setline(1, join(l:linelist, ";"))
        endif
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
"defaults to on, comment the next line if you want it to default to off
autocmd BufWrite <buffer> call DateTime()

let b:did_dt_ftplugin = 1
