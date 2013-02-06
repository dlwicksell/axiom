" Package:       Axiom
" File:          mumps.vim
" Language:      MUMPS/GT.M
" Summary:       Syntax file
" Maintainer:    David Wicksell <dlw@linux.com>
" Last Modified: Feb 6, 2013
"
" Written by David Wicksell <dlw@linux.com>
" Copyright © 2010-2013 Fourth Watch Software, LC
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
" This Vim syntax file was created to deal with a GT.M environment.
" It was inspired by earlier work by Jim Self <jaself@ucdavis.edu>.


if v:version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
elseif exists("b:mumps_syntax")
  "fold comment blocks
  syntax region mumpsCommentBlock keepend transparent fold
    \ start=/\(^\([%A-Za-z][A-Za-z0-9]*\|[0-9]\+\|\s\+;\@!\).*\n\)\@<=\s\+;/
    \ end=/\n\ze\([%A-Za-z][A-Za-z0-9]*\|[0-9]\+\|\s\+;\@!\)/

  "fold dotted-do blocks recursively, to an arbitrary depth
  syntax region mumpsDoBlock keepend transparent fold
    \ start=/^.*\s[Dd][Oo]\?\(\n\|:.*\n\|\s\{2}.*\n\)\ze\z\(\(\s\+\.\)\+\)/
    \ skip=/\n\([%A-Za-z][A-Za-z0-9]*\|[0-9]\+\)\z1/
    \ end=/\n\ze\z1\@!/

  let b:current_syntax = "mumps"

  finish
endif

syntax case ignore
"we want to sync fromstart, as dotted-do blocks can be arbitrarily long
"in order to ensure fast syncing, all but the mumps blocks are skipped
syntax sync fromstart

"define the lines as containers
syntax region mumpsLevelLine start=/^[ \t;]/ end=/$/ display keepend oneline
  \ contains=mumpsDotLevel
syntax region mumpsFormalLine start=/^\S/ end=/$/ display keepend oneline
  \ contains=mumpsLabel
syntax region mumpsCommentLine start=/^;/ end=/$/ display keepend oneline
  \ contains=mumpsComment

"beginnings of lines
syntax match mumpsDotLevel /^\s\+[. \t]*/ display contained
  \ nextgroup=mumpsCommand,mumpsComment
"mumpsDotRegion can follow a label, but not in a formal line or later
syntax match mumpsDotRegion /\s\+[. \t]*/ display contained
  \ nextgroup=mumpsCommand,mumpsComment
syntax match mumpsLabel /^[%A-Za-z][A-Za-z0-9]*:\?\|^[0-9]\+:\?/
  \ display contained nextgroup=mumpsLabelList,mumpsDotRegion,mumpsComment
syntax region mumpsLabelList matchgroup=mumpsComma start=/(/ end=/)/ display
  \ oneline contained contains=mumpsVariable,mumpsComma
  \ nextgroup=mumpsCommand,mumpsComment,mumpsSpace

"flag obvious errors
syntax match mumpsStringError /".*/ display contained
syntax match mumpsParenError /(.*/ display contained
syntax match mumpsParenError /).*/ display contained

"contained syntax patterns
syntax region mumpsString start=/"/ skip=/""/ end=/"/ display keepend
  \ oneline contained
syntax match mumpsComment /;.*/ display contained
syntax match mumpsVariable /[%A-Za-z]\+[A-Za-z0-9]*/ display contained
syntax match mumpsNumber /[0-9]\+/ display contained
"too hard to match on legal operators without more needless complexity
"added dollar to deal with the _$<func> or $<func>_ intrinsic function bug
syntax match mumpsOperator "[$*_+-/\=<>'#&!?@,^:[\]]" display contained
"necessary to highlight a comma in a mumpsLabelList properly
syntax match mumpsComma /,/ display contained
"mumps allows unlimited white space after arguments and argumentless commands
syntax match mumpsSpace /\s\+/ display contained
  \ nextgroup=mumpsCommand,mumpsComment
"handle an argumentless command properly
syntax match mumpsCommandEnd /  / display contained
  \ nextgroup=mumpsSpace,mumpsCommand,mumpsComment

syntax cluster mumpsArgumentCluster contains=mumpsVariable,mumpsNumber,
  \mumpsOperator,mumpsString,mumpsSpecialVariable,mumpsExtrinsicFunction,
  \mumpsFunction,mumpsFunctionList,mumpsStringError,mumpsParenError

"skip strings with arbitrary spaces, and don't eat an ending " ; \n or space
syntax region mumpsArgument start=/ / skip=/"[^"]*"/me=e-1 end=/[ ;]\|\n/me=e-1
  \ display oneline contained contains=@mumpsArgumentCluster
  \ nextgroup=mumpsSpace,mumpsComment

"skip strings with arbitrary spaces, and don't eat an ending " ; \n or space
syntax region mumpsPostCondition display oneline contained
  \ start=/:\S\+/ skip=/"[^"]*"/ end=/[ ;]\|\n/me=e-1
  \ contains=@mumpsArgumentCluster
  \ nextgroup=mumpsArgument,mumpsCommandEnd,mumpsComment

syntax cluster mumpsFunctionCluster contains=mumpsVariable,mumpsOperator,
  \mumpsString,mumpsNumber,mumpsSpecialVariable,mumpsFunctionList,
  \mumpsFunction,mumpsStringError,mumpsParenError,mumpsExtrinsicFunction

"match the $$<func>, but not the ^<routine>, since non-func calls don't match
syntax match mumpsExtrinsicFunction display contained
  \ /\$\$[%A-Za-z]\+[A-Za-z0-9]*/
syntax region mumpsFunctionList matchgroup=mumpsComma start=/(/ end=/)/ display
  \ oneline contained contains=@mumpsFunctionCluster

"mumps commands
syntax keyword mumpsCommand contained B C D E F G H I J K L M N O Q R S TC TRE
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained TRO TS U V W X ZA ZB ZCOM ZC ZD ZED ZG ZH
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained ZL ZK ZM ZP ZSH ZST ZSY ZTC ZTS ZWI ZWR
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained BREAK CLOSE DO ELSE FOR GOTO HALT HANG IF
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained JOB KILL LOCK MERGE NEW OPEN QUIT READ SET
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained TCOMMIT TRESTART TROLLBACK TSTART USE VIEW
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained WRITE XECUTE ZALLOCATE ZBREAK ZCOMPILE
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained ZCONTINUE ZDEALLOCATE ZEDIT ZGOTO ZHELP
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained ZLINK ZKILL ZMESSAGE ZPRINT ZSHOW ZSTEP
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment
syntax keyword mumpsCommand contained ZSYSTEM ZTCOMMIT ZTSTART ZWITHDRAW ZWRITE
  \ nextgroup=mumpsArgument,mumpsPostCondition,mumpsCommandEnd,mumpsComment

"mumps intrinsic functions, you have to add $ to iskeyword for this to work
"it is already added in settings.vim, sourced if in a mumps filetype buffer
syntax keyword mumpsFunction contained $A $C $D $E $F $FN $G $I $INCR $J $L $NA
syntax keyword mumpsFunction contained $N $O $P $QL $QS $Q $R $RE $S $ST $T $TR
syntax keyword mumpsFunction contained $V $ZAH $ZA $ZC $ZD $ZE $ZF $ZINCR $ZJ
syntax keyword mumpsFunction contained $ZL $ZP $ZTR $ZCO $ZSUB $ZW $ZM $ZTRI
syntax keyword mumpsFunction contained $ASCII $CHAR $DATA $EXTRACT $FIND
syntax keyword mumpsFunction contained $FNUMBER $GET $INCREMENT $JUSTIFY $LENGTH
syntax keyword mumpsFunction contained $NAME $NEXT $ORDER $PIECE $QLENGTH
syntax keyword mumpsFunction contained $QSUBSCRIPT $QUERY $RANDOM $REVERSE
syntax keyword mumpsFunction contained $SELECT $STACK $TEXT $TRANSLATE $VIEW
syntax keyword mumpsFunction contained $ZAHANDLE $ZBITAND $ZBITCOUNT $ZBITFIND
syntax keyword mumpsFunction contained $ZBITGET $ZBITLEN $ZBITNOT $ZBITOR
syntax keyword mumpsFunction contained $ZBITSET $ZBITSTR $ZBITXOR $ZASCII $ZCHAR
syntax keyword mumpsFunction contained $ZDATA $ZDATE $ZEXTRACT $ZFIND
syntax keyword mumpsFunction contained $ZINCREMENT $ZJUSTIFY $ZLENGTH $ZPIECE
syntax keyword mumpsFunction contained $ZTRANSLATE $ZCONVERT $ZSUBSTR $ZWIDTH
syntax keyword mumpsFunction contained $ZJOBEXAM $ZMESSAGE $ZPARSE $ZPREVIOUS
syntax keyword mumpsFunction contained $ZQGBLMOD $ZSEARCH $ZTRIGGER $ZTRNLNM

"mumps special variables, you have to add $ to iskeyword for this to work
"it is already added in settings.vim, sourced if in a mumps filetype buffer
syntax keyword mumpsSpecialVariable contained $D $EC $ES $ET $H $I $J $K $P $Q
syntax keyword mumpsSpecialVariable contained $R $ST $S $SY $T $TL $TR $X $Y
syntax keyword mumpsSpecialVariable contained $ZA $ZB $ZCH $ZDA $ZD $ZED $ZEO
syntax keyword mumpsSpecialVariable contained $ZE $ZG $ZINT $ZINI $ZJ $ZPATN
syntax keyword mumpsSpecialVariable contained $ZSO $ZS $ZT $ZDIR $ZGBL $ZL $ZPOS
syntax keyword mumpsSpecialVariable contained $ZPROMP $ZRO $ZSO $ZS $ZT $ZVER
syntax keyword mumpsSpecialVariable contained $DEVICE $ECODE $ESTACK $ETRAP
syntax keyword mumpsSpecialVariable contained $HOROLOG $IO $JOB $KEY $PRINCIPAL
syntax keyword mumpsSpecialVariable contained $QUIT $REFERENCE $STACK $STORAGE
syntax keyword mumpsSpecialVariable contained $SYSTEM $TEST $TLEVEL $TRESTART
syntax keyword mumpsSpecialVariable contained $ZCHSET $ZCM[DLINE] $ZCO[MPILE]
syntax keyword mumpsSpecialVariable contained $ZC[STATUS] $ZCS[TATUS] $ZDATEFORM
syntax keyword mumpsSpecialVariable contained $ZDIRECTORY $ZEDIT $ZEOF $ZERROR
syntax keyword mumpsSpecialVariable contained $ZGBLDIR $ZINTERRUPT $ZININTERRUPT
syntax keyword mumpsSpecialVariable contained $ZIO $ZJOB $ZL[EVEL] $ZMAXTPTI[ME]
syntax keyword mumpsSpecialVariable contained $ZMO[DE] $ZPATNUME[RIC]
syntax keyword mumpsSpecialVariable contained $ZPOS[ITION] $ZPROM[PT]
syntax keyword mumpsSpecialVariable contained $ZRO[UTINES] $ZSOURCE $ZSTATUS
syntax keyword mumpsSpecialVariable contained $ZSTEP $ZSY[STEM] $ZTE[XIT]
syntax keyword mumpsSpecialVariable contained $ZT[RAP] $ZV[ERSION] $ZYER[ROR]
syntax keyword mumpsSpecialVariable contained $ZTCO[DE] $ZTDA[TA] $ZTLE[VEL]
syntax keyword mumpsSpecialVariable contained $ZTOL[DVAL] $ZTRI[GGEROP]
syntax keyword mumpsSpecialVariable contained $ZTSL[ATE] $ZTUP[DATE] $ZTVA[LUE]
syntax keyword mumpsSpecialVariable contained $ZTWO[RMHOLE]

"fold comment blocks
syntax region mumpsCommentBlock keepend transparent fold
  \ start=/\(^\([%A-Za-z][A-Za-z0-9]*\|[0-9]\+\|\s\+;\@!\).*\n\)\@<=\s\+;/
  \ end=/\n\ze\([%A-Za-z][A-Za-z0-9]*\|[0-9]\+\|\s\+;\@!\)/

"fold dotted-do blocks recursively, to an arbitrary depth
"foldnestmax defaults to 20, which should be more than enough
syntax region mumpsDoBlock keepend transparent fold
  \ start=/^.*\s[Dd][Oo]\?\(\n\|:.*\n\|\s\{2}.*\n\)\ze\z\(\(\s\+\.\)\+\)/
  \ skip=/\n\([%A-Za-z][A-Za-z0-9]*\|[0-9]\+\)\z1/
  \ end=/\n\ze\z1\@!/

"fold entry point blocks
"syntax region mumpsEntryBlock keepend transparent fold
"  \ start=/^\S.*$/ end=/^.*\n\ze\S/

"highlight the syntax groups, change colors easily with :colorscheme
highlight def link mumpsLevelLine Normal
highlight def link mumpsFormalLine Normal
highlight def link mumpsCommentLine Normal

highlight def link mumpsDotLevel Statement
highlight def link mumpsDotRegion Statement
highlight def link mumpsLabel PreProc
highlight def link mumpsLabelList Error

highlight def link mumpsStringError Error
highlight def link mumpsParenError Error

highlight def link mumpsString String
highlight def link mumpsComment Comment
highlight def link mumpsVariable PreProc
highlight def link mumpsNumber Number
highlight def link mumpsOperator Type
highlight def link mumpsComma Type
highlight def link mumpsSpace Normal
highlight def link mumpsCommandEnd Normal

highlight def link mumpsArgument Normal
highlight def link mumpsPostCondition Normal

highlight def link mumpsExtrinsicFunction Function
highlight def link mumpsFunctionList Error

highlight def link mumpsCommand Keyword
highlight def link mumpsFunction Function
highlight def link mumpsSpecialVariable Identifier

highlight def link mumpsCommentBlock Folded
highlight def link mumpsDoBlock Folded

let b:current_syntax = "mumps"
