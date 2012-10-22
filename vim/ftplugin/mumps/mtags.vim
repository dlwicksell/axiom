" Package:       Axiom
" File:          mtags.vim
" Summary:       Jumps to different labels in a MUMPS routine
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
" Binds Ctl-] to jump to a MUMPS label and Ctl-T to jump back. It uses a
" stack, so really Ctl-] pushes a label on the stack, and Ctl-T pops it off.
" Works with local tags as well.
"
" Examples:
"   D INIT - Will work as expected
"
"   D EN^XUP - You must be on the tag name to jump
"       to EN or if you are on the ^ you will jump
"       to the first line of XUP
"
"   D ^XUP - You must be on the ^ to work, will
"       jump to the first line of XUP
"
"   D %DTC^RGUT - You must be on the % to work
"
"   G %A - You must be on the % to work
"
"   G A - Will work as expected
"
"   D DT^DICRW:'$D(DUZ)#2!'$D(DTIME),EN^XQH -
"       Works for either DT^DICRW on the DT or ^ and
"       for EN^XQH on the EN or ^, respectively
"
"   W $$%A^RGUT - You must be on the % or one of
"       the $ to work
"
"   W $$EN^XUP,$$%A^RGUT - EN^XUP will work on the EN
"       or one of the $, and %A^RGUT will work as long
"       as you are on the % or one of the $


if exists("b:did_mt_ftplugin")
  finish
endif

if !exists("*MTag") "don't define the same function twice
  "parse label^routine and jump to the file at the label location
  function! MTag(argtag)
    let l:argtag = a:argtag

    while 1 "loop through and ignore anything that isn't a label
      if l:argtag == "" "got to end
        break
      elseif strpart(l:argtag, 0, 1) =~ "[%A-Za-z0-9^]" "got to a valid label
        break
      else
        let l:argtag = strpart(l:argtag, 1) "remove invalid char from front
      endif
    endwhile

    let l:chartag = strpart(l:argtag, 1, 1) "test for unique cases

    if l:chartag =~ "\n" || l:chartag =~ "\t" || l:chartag =~ " "
      let l:argtag = strpart(l:argtag, 0, 1) "got the label^routine
    endif

    if stridx(l:argtag, "(") >= 0
      "got the label^routine
      let l:argtag = strpart(l:argtag, 0, stridx(l:argtag, "("))
    endif

    if stridx(l:argtag, ")") >= 0
      "got the label^routine
      let l:argtag = strpart(l:argtag, 0, stridx(l:argtag, ")"))
    endif

    if stridx(l:argtag, ",") >= 0
      "got the label^routine
      let l:argtag = strpart(l:argtag, 0, stridx(l:argtag, ","))
    endif

    if stridx(l:argtag, ":") >= 0
      "got the label^routine
      let l:argtag = strpart(l:argtag, 0, stridx(l:argtag, ":"))
    endif

    if stridx(l:argtag, '"') >= 0
      "got the label^routine
      let l:argtag = strpart(l:argtag, 0, stridx(l:argtag, '"'))
    endif

    "No label, so we should look for the label in the first line of the routine.
    "It is valid in MUMPS/GT.M to have a label in the first line with a
    "different name than the name of the routine.
    "This matches up with the tags file.
    if l:argtag =~ "^^" "an ^routine reference
      let l:argtag = strpart(l:argtag, 1) "strip off the leading ^
      let l:gtmpath = tr($gtmroutines, '( )', ',,,') "set up the search path
      let l:gtmlist = split(l:gtmpath, ",") "turn $gtmroutines into a list
      let l:path = ""

      for l:dir in l:gtmlist "loop through the list, making a modified string
        if l:dir == "" "extra commas from tr() function, ignore them
          continue
        endif

        let l:path .= l:dir . ";," "rebuild as a string, add a search directive
      endfor

      let l:path = strpart(l:path, 0, len(l:path) - 1) "strip off last comma

      "find the path to the file we're going to inspect
      let l:argfile = findfile(tr(l:argtag, "%", "_") . ".m", l:path)

      if l:argfile == ""
        "routine doesn't exist, so can't search for the tag name
        let l:argtag = tr(l:argtag, "%", "_") "grab name to display in error

        echohl ErrorMsg
        echo "E484: Can't open file " . l:argtag . ".m"
        echohl None

        return
      endif

      let l:line = get(readfile(l:argfile), 0) "grab first line of routine

      "we only care about the label
      if l:line =~ "\t"
        let l:line = strpart(l:line, 0, stridx(l:line, "\t"))
      endif

      "we only care about the label
      if l:line =~ " "
        let l:line = strpart(l:line, 0, stridx(l:line, " "))
      endif

      "we only care about the label
      if l:line =~ "("
        let l:line = strpart(l:line, 0, stridx(l:line, "("))
      endif

      "we only care about the label
      if l:line =~ ";"
        let l:line = strpart(l:line, 0, stridx(l:line, "("))
      endif

      let l:argtag = l:line . "^" . l:argtag "build the label^routine reference
    endif

    "deal with a label offset in the routine
    if l:argtag =~ "+" "get rid of the label offset to jump to the right label
      let l:argtag = strpart(l:argtag, 0, stridx(l:argtag, "+"))
                 \ . strpart(l:argtag, stridx(l:argtag, "^"))
    endif

    if l:argtag !~ "\\^" "deal with a local label, in the routine we're in
      let l:routine = bufname("%") "get the current routine name
      "strip off the dirname, keep the basename of the routine
      let l:routine = strpart(l:routine, strridx(l:routine, "/")+1)
      let l:routine = tr(l:routine, "_", "%") "change to external format

      if l:routine =~ "\\.m$" "we have the .m extension
        let l:length = strlen(l:routine)-2 "find the length without the suffix
        let l:routine = strpart(l:routine, 0, l:length) "remove the .m suffix
      endif

      let l:argtag = l:argtag . "^" . l:routine "build label^routine reference
    endif

    "handle the various errors that can crop up
    try
      "jump to the tag, or if there is more than one option, present a list
      execute "tjump " . l:argtag
    catch /^Vim(\a\+):E433:/ "no .mtags or mtags file
      echohl ErrorMsg
      echo "E433: cstag: No tags file"
      echohl None
    catch /^Vim(\a\+):E426:/ "no tag in the .mtags or mtags file
      echohl ErrorMsg
      echo "E257: cstag: tag not found"
      echohl None
    catch /^Vim(\a\+):E434:/ "no tag in the .mtags or mtags file
      echohl ErrorMsg
      echo "E257: cstag: tag not found"
      echohl None
    catch /^Vim(\a\+):E429:/ "tag is in tags file, but routine doesn't exist
      let l:routine = strpart(l:argtag, stridx(l:argtag, "^")+1) "strip label
      let l:routine = tr(l:routine, "%", "_") "change to external format

      echohl ErrorMsg
      echo "E484: Can't open file " . l:routine . ".m"
      echohl None
    endtry
  endfunction
endif

"creates a key mapping, bound to Ctl-], to jump to MUMPS labels
"pass a reference to the label^routine under the cursor
au BufEnter <buffer> nnoremap <silent> <buffer> <C-]> lb"ayE:call MTag(@a)<CR>

let b:did_mt_ftplugin = 1
