" Package:       Axiom
" File:          mcompile.vim
" Summary:       Compile MUMPS routines and show errors
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Oct 21, 2012
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
" Compile the routine in the current buffer, displaying any compiler errors.
" The routine will be compiled in the object directory that corresponds with
" the first routine directory in $gtmroutines that contains the routine in
" the current buffer.


if exists("b:did_mc_ftplugin")
  finish
endif

if !exists("*MCompile") "don't define the same function twice
  function! MCompile()
    let l:gtmlist = split($gtmroutines, " ") "turn $gtmroutines into a list
    let l:cdir = {}
    let l:rdir = {}
    let l:cnt = 0
    let l:flag = 0

    for l:dir in l:gtmlist "loop through the list of directories
      if l:dir =~ "("
        let l:cdir[l:cnt] = strpart(l:dir, 0, stridx(l:dir, "("))
        let l:rdir[l:cnt] = strpart(l:dir, stridx(l:dir, "(") + 1)

        if l:dir !~ ")"
          let l:flag = 1
        else
          let l:rdir[l:cnt] = strpart(l:rdir[l:cnt], 0, len(l:rdir[l:cnt]) - 1)
        endif
      elseif l:dir =~ ")" && l:flag
        let l:cdir[l:cnt] = l:cdir[l:cnt - 1]
        let l:rdir[l:cnt] = strpart(l:dir, 0, stridx(l:dir, ")"))
        let l:flag = 0
      else
        if l:flag
          let l:cdir[l:cnt] = l:cdir[l:cnt - 1]
          let l:rdir[l:cnt] = l:dir
        else
          let l:cdir[l:cnt] = l:dir
          let l:rdir[l:cnt] = l:cdir[l:cnt]
        endif

        if l:cdir[l:cnt] =~ "\\.so"
          let l:cdir[l:cnt] = fnamemodify(l:cdir[l:cnt], ":h")
        endif

        if l:rdir[l:cnt] =~ "\\.so"
          let l:rdir[l:cnt] = fnamemodify(l:rdir[l:cnt], ":h")
        endif
      endif

      let l:cnt = l:cnt + 1
    endfor

    let l:cnt = 0

    while l:cnt < len(l:rdir)
      "deal with absolute or relative path names
      if expand("%:p:h") == l:rdir[l:cnt] || expand("%:h") == l:rdir[l:cnt]

        let l:directory = getcwd()

        execute "lcd " . l:cdir[l:cnt]

        let l:compilefile = l:rdir[l:cnt] . "/" . expand("%:t")
        let l:status = system("mumps " . l:compilefile)

        if l:status == ""
          echohl ModeMsg
          echo "Compilation successful: Compiled in " . l:cdir[l:cnt]
          echohl None
        else
          echohl ErrorMsg
          echo "Compilation error(s)\n"
          echohl None
          echo l:status
        endif

        execute "lcd " . l:directory

        break
      endif

      let l:cnt = l:cnt + 1
    endwhile

    if ! exists("l:status")
      let l:directory = getcwd()

      execute "lcd " . expand("%:h")

      let l:status = system("mumps " . bufname("%"))

      if l:status == ""
        echohl ModeMsg
        echo "Compilation successful: Compiled in " . getcwd()
        echohl None
      elseif l:status =~ "%SYSTEM-E-ENO13, Permission denied"
        echohl ErrorMsg
        echo "Permission denied: System routines cannot be compiled"
        echohl None
      else
        echohl ErrorMsg
        echo "Compilation error(s)\n"
        echohl None
        echo l:status
      endif

      execute "lcd " . l:directory
    endif
  endfunction
endif

autocmd BufEnter <buffer> command! -buffer MCompile call MCompile()

let b:did_mc_ftplugin = 1
