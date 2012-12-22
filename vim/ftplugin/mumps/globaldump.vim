" Package:       Axiom
" File:          globaldump.vim
" Summary:       Dumps a global reference while editing
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
" Binds Ctl-K to jump to a MUMPS global in the current buffer.
" If you define b:globalsplit and set it to 1, then it will
" display the contents of the global in a horizontal split window,
" underneath the routine window, otherwise the contents of the
" global will be displayed in your current buffer, on top of your
" routine. If you define b:splittype and set it to 'vertical', then
" the split window will be vertical, and to the right of the routine
" window.
"
" Binds Ctl-K, Ctl-], and Ctl-T in the split screen containing the
" contents of the global, if you set the b:globalsplit variable to
" 1, to close the window and remove the buffer's contents. Also closes
" the window and removes the buffer's contents if :quit is used instead.
"
" Creates an ex command called :ZWR that will dump a global, also in
" split screen or in the current buffer.


if exists("b:did_gd_ftplugin")
  finish
endif

if !exists("*FileDelete") "don't define the same function twice
  "In global split mode, delete the buffer that displays the global data, and
  "remove the temporary file that contains the data from the filesystem
  function! FileDelete()
    "turn off the BufWinLeave autocmd so it isn't executed twice while still
    "in the global buffer, necessary to handle all cases
    autocmd! BufWinLeave <buffer>

    let l:tempfile = bufname("%") "name of global dump buffer

    execute "bdelete " . l:tempfile

    silent echo delete(l:tempfile)

    redraw! "need to do this if the routine buffer is modified

    "Need to remap <C-K> and redefine ZWR after deleting the dump buffer
    nnoremap <silent> <buffer> <C-K> "by$:call MGlobal(@b)<CR>
    command! -nargs=1 -buffer ZWR call ZWRArgument(<q-args>, 1)

    call StartSyntax() "going back into the previous mumps buffer
  endfunction
endif

if !exists("*ZWRArgument") "don't define the same function twice
  "call KBAWDUMP.m and pass it the global to display in VIM mode, no children
  function! ZWRArgument(global, mode)
    if a:mode && a:global !~ "[()]"
      "turn off VIM mode for calls without subscripts, with the :ZWR command
      let l:global = system("mumps -r KBAWDUMP '" . a:global . "'")
    else
      let l:global = system("mumps -r KBAWDUMP '-" . a:global . "'")
    endif

    "output more useful error messages if we get an error from GT.M
    if l:global =~ "%GTM-E-FILENOTFND" && l:global !~ "^^"
      echohl ErrorMsg
      echo "%GTM-E-FILENOTFND: Put KBAWDUMP.m in your $gtmroutines search path"
      echohl None
    elseif l:global =~ "mumps: command not found" && l:global !~ "^^"
      echohl ErrorMsg
      echo "mumps: command not found: Install GT.M on your system"
      echohl None
    "catch too many arguments passed via :ZWR, and don't display in split screen
    elseif l:global == "KBAWDUMP takes one argument, the global reference.\n"
      echohl ErrorMsg
      echo "KBAWDUMP takes one argument, the global reference."
      echohl None
    "hard to determine what caused a particular error, but try our best
    elseif l:global == "Expression expected but not found\n"
      echohl ErrorMsg
      echo "Expression expected but not found. Try :ZWR"
      echohl None
    elseif l:global == "Illegal naked global reference\n"
      echohl ErrorMsg
      echo "Illegal naked global reference. Try :ZWR"
      echohl None
    elseif l:global == "Indirection string contains extra trailing characters\n"
      echohl ErrorMsg
      echo "Indirection string contains extra trailing characters. Try :ZWR"
      echohl None
    elseif l:global == "Variable expected in this context\n"
      echohl ErrorMsg
      echo "Variable expected in this context. Try :ZWR"
      echohl None
    elseif l:global == "Right parenthesis expected\n"
      echohl ErrorMsg
      echo "Right parenthesis expected. Try :ZWR"
      echohl None
    elseif l:global =~ "Either an identifier or a left" && l:global !~ "^^"
      echohl ErrorMsg
      echo "Either an identifier or a left parenthesis is expected Try :ZWR"
      echohl None
    "catch an undefined global, so we don't display it in split screen
    elseif l:global =~ "Global variable undefined:" || l:global == ""
      if l:global !~ "^^"
        echohl ErrorMsg

        if strpart(a:global, 0, 1) == "^"
          echo "Global variable undefined: " . a:global
        else
          echo "Global variable undefined: ^" . a:global
        endif

        echohl None
      endif
    else
      if getbufvar("%", "globalsplit") == 1 "global split window mode is on
        if v:version >= 702
          let l:PPID = getpid()
        else
          let l:PPID = system("echo -n $PPID") "getpid() doesn't exist
        endif

        let l:tempfile = "~/.globaldump." . l:PPID "create a temp file

        if !filereadable(glob(l:tempfile)) "doesn't already exist
          execute "redir! > " . l:tempfile | "dump the global to the temp file

          if strpart(a:global, 0, 1) != "^"
            silent echo "^" . a:global | "display the global argument at the top
          else
            silent echo a:global | "display the global argument at the top
          endif

          silent echo ""
          silent echo l:global

          redir END "change output back to current buffer

          "expose the splittype variable to the split screen buffer
          let s:splittype = b:splittype

          if getbufvar("%", "splittype") == "vertical" "split window mode
            "open up the split window on the right
            execute "rightbelow vsplit " . l:tempfile
          else
            "open up the split window on the bottom
            execute "rightbelow split " . l:tempfile
          endif

          setlocal nomodifiable "no reason to allow changing the contents
          setlocal readonly "require a ! in order to alter the contents

          setlocal nolinebreak "wraps lines

          let s:oldshowbreak = &showbreak
          set showbreak=>> "shows that lines have wrapped

          if s:splittype == "vertical" "split window mode
            ", will increase the size of the window with the global data
            nnoremap <silent> <buffer> , <C-W>>
            ". will decrease the size of the window with the global data
            nnoremap <silent> <buffer> . <C-W><
          else
            ", will increase the size of the window with the global data
            nnoremap <silent> <buffer> , <C-W>+
            ". will decrease the size of the window with the global data
            nnoremap <silent> <buffer> . <C-W>-
          endif

          "Ctl-K map will only be applicable in the window with the global data
          nnoremap <silent> <buffer> <C-K> :call FileDelete()<CR>
          "remap the key mappings for the tag stack, so buffer won't mess it up
          nnoremap <silent> <buffer> <C-]> :call FileDelete()<CR>
          nnoremap <silent> <buffer> <C-T> :call FileDelete()<CR>

          "reset &showbreak after shutting down the global dump buffer
          autocmd BufWinLeave <buffer> :let &showbreak = s:oldshowbreak
          "delete the buffer and temporary file when :q is used
          autocmd BufWinLeave <buffer> :call FileDelete()
        else "already exists, don't want multiple split screens
          echohl ErrorMsg
          echo "Close the global dump window with Ctl-K first"
          echohl None
        endif
      else
        echo l:global | "dump the global in the routine editing buffer
      endif
    endif
  endfunction
endif

if !exists("*MGlobal") "don't define the same function twice
  "MGlobal parses input from the movement commands bound to Ctl-K
  function! MGlobal(global)
    let l:global = a:global
    "track where we are in the syntax
    let l:lparen = 0 "track how many left parens we've seen
    let l:rparen = 0 "track how many right parens we've seen
    let l:quote = 0 "track how many quotes we've seen

    "parsing a character at a time, tracking where we are
    for l:char in range(0, len(l:global))
      "shouldn't have a tick ' outside of a string, so sanitize it and quit
      "letting the regular error handling deal with it
      if strpart(l:global, l:char, 1) == "'" && !l:quote
        let l:global = substitute(l:global, "'", '"', "g")

        break
      elseif strpart(l:global, l:char, 1) == '"' "dealing with strings is hard
        if l:lparen
          let l:quote += 1
        else
          let l:global = strpart(l:global, 0, l:char) "no strings outside parens

          break
        endif
      "beginning of subscript arguments
      elseif strpart(l:global, l:char, 1) == "(" && !l:quote
        let l:lparen += 1
      elseif strpart(l:global, l:char, 1) == ")"
        if l:lparen == 1 && l:quote == 0 "finished the subscripts, not in string
          let l:global = strpart(l:global, 0, l:char) . ")" "and we're done

          break
        elseif l:lparen == 0 && l:quote == 0 "simple reference in a parenthesis
          let l:global = strpart(l:global, 0, l:char) "also done, but no ) added

          break
        "finished with string and not in another set of parens
        elseif !(l:quote % 2) && l:lparen != l:rparen
          let l:rparen += 1 "this paren closes the subscript region
        endif

        if !(l:quote % 2) && l:lparen == l:rparen "all regions are closed
          let l:global = strpart(l:global, 0, l:char) . ")" "and we're done

          break
        endif
      "no subscripts, so end on operators or whitespace
      elseif !l:lparen && !l:rparen
        if strpart(l:global, l:char, 1) =~ "[]*_+-/\=<>'#&!?@,: []"
          let l:global = strpart(l:global, 0, l:char) "and we're done
        endif
      endif
    endfor

    call ZWRArgument(l:global, 0)
  endfunction 
endif

"define a key mapping, bound to Ctl-K, to dump the global data under the cursor
"works if you put the cursor on the ^ of the global reference
au BufEnter <buffer> nnoremap <silent> <buffer> <C-K> "by$:call MGlobal(@b)<CR>
"creates a user-defined command to dump global data directly
au BufEnter <buffer> command! -nargs=1 -buffer ZWR call ZWRArgument(<q-args>, 1)

let b:did_gd_ftplugin = 1
