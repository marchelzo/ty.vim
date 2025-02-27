" Vim syntax file
" Language: Ty

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'ty'
endif

" Dollar sign is permitted anywhere in an identifier
if (v:version > 704 || v:version == 704 && has('patch1142')) && main_syntax == 'ty'
  "syntax iskeyword @,48-57,_,192-255,$,?,!,|,&,:,<,>,@-@,-
  syntax iskeyword @,48-57,_,192-255,$,?,!,:,@-@,-
else
  setlocal iskeyword+=$
  setlocal iskeyword+=?
endif

syntax sync fromstart

" TODO: Figure out what type of casing I need
" syntax case ignore
syntax case match

syn match   tyIdentifier /\%(\d\)\@!\w\%(\w\|-\w\)*\%(::\K\%(\w|-\)*\)*[!?]\?/ contains=tyModAccess
syn match   tyModAccess contained '::'

" Modules
syn match   tyNewline contained /\n\|$/
syn match   tyModAlias contained /\w\+[!?]\?/ skipwhite nextgroup=tyImportList,tyNewline,tyHiding
syn keyword tyImport contained import use skipwhite nextgroup=tyModPath
syn match   tyModPath contained /\w\+\%(\%(::\|\.\)\w\+\)*/ skipwhite nextgroup=tyAs,tyImportList,tyNewline,tyHiding
syn keyword tyAs contained as skipwhite nextgroup=tyModAlias
syn keyword tyHiding contained hiding skipwhite nextgroup=tyImportList
syn region  tyImportList contained start=/(/ end=/)/ contains=tyIdentifier,tyAs skipwhite nextgroup=tyNewline
syn region  tyImportStatement start=/\%(\<import\|use\>\)\@=/ end=/\n/ contains=tyImport

syn keyword tyBool true false
syn keyword tyPub pub

syn region tyDecorator      start=/@\[/ end=/\]/ contains=@tyExpression
syn region tyDecoratorMacro start=/@{/  end=/}/  contains=@tyExpression

syn keyword tyFunction fn function skipwhite skipempty nextgroup=tyFunctionName
syn match   tyFunctionName contained /\%(\w\%(\w\|-\w\)\+[!?=]\?[*]\=\)\|\%([/<>#~=+%?*^&!:.|-]\+\)/ skipwhite skipempty nextgroup=tyParamList,@tyStatement

" Classes / Tags
syn keyword tyClass class tag skipwhite skipempty nextgroup=tyClassName
syn match   tyClassName contained /\w\+/ skipwhite skipempty nextgroup=tyTagSemicolon,tyClassBlock,tyExtend
syn match   tyExtend contained /:/ skipwhite skipempty nextgroup=tySuperName
syn match   tySuperName contained /\w\+\%(\%(::\|\.\)\w\+\)*/ skipwhite skipempty nextgroup=tyTagSemicolon,tyClassBlock
syn match   tyTagSemicolon contained /;/
syn region  tyClassBlock contained start=/{/ end=/}/ contains=tyMethodName,tyComment,tyKeyword
syn match   tyMethodName contained /\%(\w\%(\w\|-\w\)\+[!?=]\?\*\=\)\|\%(\s[/<>#~=+%*^&!:.|-]\+\)/ skipwhite skipempty nextgroup=tyParamList,@tyStatement
syn match   tyInstanceVar contained /@\w\%(\w\|-\)*[!?]\?/ containedin=tyClassBlock
syn match   tySelf contained /\%(\K-\)\@<!self\K\@!/ containedin=tyClassBlock
"syn match   tySelf contained /<self\>/ containedin=tyClassBlock

syn region  tyParamList contained start=/(/ end=/)/ keepend contains=tyParam,tyParamDefault,@tyExpression skipwhite skipempty nextgroup=@tyStatement
syn match   tyParam contained /\%(\*\|%\)\?\w\%(\w\|-\w\)*[!?]\?/ skipwhite skipempty nextgroup=tyParamConstraint
syn region  tyParamConstraint contained start=':' end=/,\|)\|\%(=\@=\)/ contains=@tyExpression
syn match   tyParamDefault contained '=' skipwhite skipempty nextgroup=@tyExpression

syn region tyBlock contained matchgroup=tyBraces start=/{/  end=/}/  contains=@tyStatement,tyBlock extend fold

syn keyword tyNil nil
syn keyword tyKeyword with do let pub generator match while for if else try catch finally throw return in not and or yield break continue macro operator static defer as namespace ns

syn match   tyMemberAccess /\%(\K\.\)\@<=\K\k*/
syn match   tyOperator /\%(#\)\|?\|\%([~<>=/%+*^&!:.|-]\)\+/

" syn match tyNumber /-\?\%(0x\)\?\d\+\%(\.\d\+\)\?/
" syn region tyRawString start=+'+ skip=+\\'+ end=+'+
" syn region tySpecialString start=+"+ skip=+\\"+ end=+"+

syn match tyCall /[a-z_]\%(\w\|-\)*[!?\\]\?(\@=/
syn match tyType /[A-Z]\w*(\@!/
syn match tyCtor /[A-Z]\w*(\@=/

" Regular Expressions
syntax match   tySpecial            contained "\v\\%(x\x\x|u%(\x{4}|\{\x{4,5}})|c\u|.)"
syntax region  tyTemplateExpression contained matchgroup=tyTemplateBraces start=+{+ end=+}+ contains=@tyExpression keepend
syntax region  tyRegexpCharClass    contained start=+\[+ skip=+\\.+ end=+\]+ contains=tySpecial extend
syntax match   tyRegexpBoundary     contained "\v\c[$^]|\\b"
syntax match   tyRegexpBackRef      contained "\v\\[1-9]\d*"
syntax match   tyRegexpQuantifier   contained "\v[^\\]%([?*+]|\{\d+%(,\d*)?})\??"lc=1
syntax match   tyRegexpOr           contained "|"
syntax match   tyRegexpMod          contained "\v\(\?[:=!>]"lc=1
syntax region  tyRegexpGroup        contained start="[^\\]("lc=1 skip="\\.\|\[\(\\.\|[^]]\+\)\]" end=")" contains=tyRegexpCharClass,@tyRegexpSpecial keepend
syntax region  tyRegexpString   start=+\%(\%(\<return\|\<typeof\|\_[^)\]'"[:blank:][:alnum:]_$]\)\s*\)\@<=/\ze[^*/]+ skip=+\\.\|\[[^]]\{1,}\]+ end=+/[gimyus]\{,6}+ contains=tyRegexpCharClass,tyRegexpGroup,@tyRegexpSpecial oneline keepend extend
syntax cluster tyRegexpSpecial    contains=tySpecial,tyRegexpBoundary,tyRegexpBackRef,tyRegexpQuantifier,tyRegexpOr,tyRegexpMod

syntax region tyEscapedReservedWord start="`" end="`" oneline

" Compile-time directive
syntax region  tyDirective        start=+^\s*#|+ end=/$/ keepend

" Comments
syntax keyword tyCommentTodo    contained TODO FIXME XXX TBD NOTE
syntax region  tyComment        start=+//+ end=/$/ contains=tyCommentTodo,@Spell extend keepend
syntax region  tyComment        start=+/\*+  end=+\*/+ contains=tyCommentTodo,@Spell fold extend keepend
syntax region  tyEnvComment     start=/\%^#!/ end=/$/ display

syntax cluster tyExpression contains=tyBool,tyNumber,tyIdentifier,tyMemberAccess,tyKeyword,tyFunction,tyNil,tyOperator,tyInstanceVar,tySelf,tyCall,tySpecialString,tyString,tyType,tyCtor,tyRegexpString,tyDirective,tyComment
syntax cluster tyStatement contains=@tyExpression,tyBlock,tyEnvComment

syntax region  tyString           start=+\z([']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ contains=tySpecial extend
syntax region  tySpecialString    start=+\z(["]\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ contains=tySpecial extend
syntax match   tyNumber           /\c\%(\<\|[!?]\@<=\)-\=\%(\d[0-9_]*\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\%(\x\|_\)\+\)n\=\%([-!?]\@=\|\>\)/

hi link tyEscapedReservedWord Normal
hi link tyImport              Include
hi link tyAs                  Keyword
hi link tyHiding              Keyword
hi link tyModPath             YellowItalic
hi link tyModAlias            YellowItalic
hi link tyIdentifier          Normal
hi link tyModAccess           @lsp.type.namespace
hi link tyBool                Boolean
hi link tyNil                 Constant
hi link tyNumber              Number
hi link tyPub                 StorageClass
hi link tyClass               Structure
hi link tyClassName           Type
hi link tySuperName           Type
hi link tyMethodName          Function
hi link tyFunction            Keyword
hi link tyFunctionName        Function
hi link tyCall                Function
hi link tyLet                 StorageClass
hi link tyKeyword             Keyword
hi link tyParam               Special
hi link tyOperator            Operator
hi link tyInstanceVar         Identifier
hi link tyMemberAccess        Identifier
hi link tySelf                Constant
hi link tyString              String
hi link tySpecialString       String
hi link tySpecial             Special
hi link tyTemplateBraces      Special
hi link tyRegexpString        String
hi link tyRegexpBoundary      SpecialChar
hi link tyRegexpQuantifier    SpecialChar
hi link tyRegexpOr            Conditional
hi link tyRegexpMod           SpecialChar
hi link tyRegexpBackRef       SpecialChar
hi link tyRegexpGroup         tyRegexpString
hi link tyRegexpCharClass     Character
hi link tyType                Type
hi link tyCtor                Type
hi link tyComment             Comment
hi link tyEnvComment          Comment
hi link tyDirective           PreProc
hi link tyDecorator           @lsp.type.decorator
hi link tyDecoratorMacro      Macro
