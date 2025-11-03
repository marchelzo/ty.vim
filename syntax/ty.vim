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

syn keyword tyFunction fn function skipwhite skipempty nextgroup=tyFunctionName
syn match   tyFunctionName contained /\%(\w\%(\w\|-\w\)*[!?=]\?[*]\=\)\|\%([/<>#~=+%?*^&!:.|-]\+\)/ skipwhite skipempty nextgroup=tyFunctionTypeParams,tyParamList,@tyStatement

syn region  tyParenthesizedExpression matchgroup=tyGroupParen start=/(/ end=/)/ transparent contains=@tyExpression

syn region tyQuasiQuoted matchgroup=tyQuasiQuote start=/\$\$\[/ end=/\$\$]/ contains=TOP
syn region tyQQSpliceExpr matchgroup=tyQQSplice start=+\$\$(+ end=+)+ contains=TOP
syn region tyQQSpliceVal matchgroup=tyQQSplice start=+\$\${+ end=+}+ contains=TOP
syn match  tyQQSpliceVar /\$\$\K\k*/

let ident = '\%(\%(\d\)\@!\%(::\)\?\w\%(\w\|-\w\)*\%(::\K\%(\w|-\)*\)*[!?]\?\|\$\d\+\)'

syn match   tySemicolon /;/ contained
syn match   tyOperator /\%(#\)\|?\|\%([~<>=/%+*^&!:.|-]\)\+/
execute "syn match   tyIdentifier /" .. ident .. "/ contains=tyModAccess,tyCall,tyType,tyCtor,tyModName"
syn match   tyCall /\%(\d\)\@!\%(::\)\?\w\%(\w\|-\w\)*\%(::\K\%(\w|-\)*\)*[!?]\?\%(@\?(\)\@=/ contains=tyModAccess,tyType,tyCtor nextgroup=tyArgList,tyPartialApp
syn match   tyModAccess contained '::'
syn match   tyModName contained /\w\+\%(::\)\@=/

syn region  tyArray matchgroup=tyArrayBracket start=/\[/ end=/]/ transparent
syn region  tyDict matchgroup=tyDictBracket start=/%{/ end=/}/ transparent

syn match tyNotNil /\$[A-z_]\@=/ contained nextgroup=tyIdentifier

" Modules
syn match   tyNewline contained /\n\|$/
syn match   tyModAlias contained /\w\+[!?]\?/ skipwhite nextgroup=tyImportList,tyNewline,tyHiding
syn keyword tyImport contained import skipwhite nextgroup=tyModPath
syn match   tyModPath contained /\w\+\%(\%(::\|\.\)\w\+\)*/ skipwhite nextgroup=tyAs,tyImportList,tyNewline,tyHiding
syn keyword tyAs contained as skipwhite nextgroup=tyModAlias
syn keyword tyHiding contained hiding skipwhite nextgroup=tyImportList
syn region  tyImportList contained start=/(/ end=/)/ contains=tyIdentifier,tyAs skipwhite nextgroup=tyNewline
syn region  tyImportStatement start=/\%(\<import\>\)\@=/ end=/\n/ contains=tyImport

syn keyword tyUse use skipwhite nextgroup=tyModPath,tyType

syn keyword tyBool true false
syn keyword tyPub pub

" Classes / Tags
syn keyword tyClass trait class tag skipwhite skipempty nextgroup=tyClassName
syn match   tyClassName contained /\w\+/ skipwhite skipempty nextgroup=tyClassParams,tyClassTypeParams,tyTagSemicolon,tyClassBlock,tyExtend,tyTraitList
syn match   tyExtend contained /</ skipwhite skipempty nextgroup=tySuperName
syn region  tyTraitList contained start=/:/ end=/{\@=/ keepend contains=@tyExpression skipwhite skipempty nextgroup=tyClassBlock
syn match   tyTrait contained /\%(\*\|%\)\?\w\%(\w\|-\w\)*[!?]\?/ skipwhite skipempty nextgroup=tyParamConstraint
syn match   tySuperName contained /\w\+\%(\%(::\|\.\)\w\+\)*/ skipwhite skipempty nextgroup=tyTagSemicolon,tyClassBlock,tyTraitList,tyClassTypeParams
syn match   tyTagSemicolon contained /;/
syn region  tyClassBlock contained start=/{/ end=/}/ contains=tyField,tyMethodName,tyComment,tyKeyword,tyDecorator,tyDecoratorMacro
syn match   tyMethodName contained /\%(`\=\w\%(\w\|-\w\)*[!?=]\?\*\=`\=\)\|\%([/<>#~=+%*^&!:.|-]\+\)\|\[;;\]\|\[\]\|?/ skipwhite skipempty nextgroup=tyMethodTypeParams,tyParamList,tyReturnType,@tyStatement
syn region  tyField contained start=/\(static\s\)\=\w\%(\w\|-\w\)\{-}[!?]\?\s*:/me=e-1 end=/$/ skipwhite skipempty contains=tyFieldType,tyFieldInit,tyKeyword,@tyExpression
syn match   tyFieldType contained /:/ skipwhite nextgroup=@tyExpression
syn match   tyFieldInit contained /=/ skipwhite nextgroup=@tyExpression
syn match   tyInstanceVar contained /@\w\%(\w\|-\)*[!?]\?/ containedin=tyClassBlock
syn match   tySelf contained /\%(\K-\)\@<!\%(self\|super\)\K\@!/ containedin=tyClassBlock
"syn keyword tySelf self contained containedin=tyClassBlock
"syn match   tySelf contained /<self\>/ containedin=tyClassBlock

syn region tyClassTypeParams contained skipwhite matchgroup=tyTypeParamsBracket start=/\[/ end=/]/ contains=@tyExpression nextgroup=tyClassParams,tyExtend,tyTraitList,tyClassBlock
syn region tyMethodTypeParams contained matchgroup=tyTypeParamsBracket start=/\[/ end=/]/ contains=@tyExpression nextgroup=tyParamList
syn region tyFunctionTypeParams contained matchgroup=tyTypeParamsBracket start=/\[/ end=/]/ contains=@tyExpression nextgroup=tyParamList

syn region  tyClassParams matchgroup=tyParamListParen contained start=/(/ end=/)/ contains=tyParam,tyGatherParam,tyKwargsParam,tyParamDefault,tyComma skipwhite skipempty nextgroup=tyClassBlock,tyExtend,tyTraitList

syn region  tyParamList matchgroup=tyParamListParen contained start=/(/ end=/)/ contains=tyParam,tyGatherParam,tyKwargsParam,tyParamDefault,tyComma,tyComment,@tyExpression skipwhite skipempty nextgroup=tyReturnType,@tyStatement
syn match   tyComma contained /,/ skipwhite skipempty
syn match   tyParam contained /\w\%(\w\|-\w\)*[!?]\?/ skipwhite skipempty nextgroup=tyParamConstraint,tyComma
syn match   tyGatherParam contained /\*\w\%(\w\|-\w\)*[!?]\?/ skipwhite skipempty nextgroup=tyParamConstraint,tyComma
syn match   tyKwargsParam contained /%\w\%(\w\|-\w\)*[!?]\?/ skipwhite skipempty nextgroup=tyParamConstraint,tyComma
"syn region  tyParamConstraint contained start=':' end=/,\|)\|\%(=\@=\)/ contains=@tyExpression skipwhite skipempty nextgroup=tyParamDefault,tyComma
syn match tyParamConstraint contained /:/ skipwhite nextgroup=@tyExpresion
"syn region  tyParamDefault contained start='=' end=/{\|,/ skipwhite skipempty contains=@tyExpression
syn match tyParamDefault contained /=/ skipwhite nextgroup=@tyExpression
syn region tyReturnType start=/->/ end=/\%({\|;\)\@=/ skipwhite skipempty transparent contains=@tyExpression nextgroup=@tyStatement

syn region tyRecord contained matchgroup=tyRecordBracket start=/{/ end=/}/ contains=@tyExpression extend
syn region tyBlock contained matchgroup=tyBraces start=/{/  end=/}/  contains=@tyStatement,tyBlock extend fold

syn keyword tyNil nil
syn keyword tyKeyword with let const pub generator while for if else try catch finally throw return in not and or yield break continue macro operator static defer as namespace ns

execute 'syn match tyMemberAccess /\%(\%([])"' .. "'" .. '} ]\|\k\)\.\)\@<=' .. ident .. '\%(\k\|(\)\@!/'

execute 'syn match tyKwArg contained /' .. ident .. '\%(:\|\s*=[=><%*]\@!\)\@=/'

syn keyword tyMatch match skipwhite skipempty nextgroup=@tyStatement
syn keyword tyDo do skipwhite skipempty nextgroup=@tyStatement

" syn match tyNumber /-\?\%(0x\)\?\d\+\%(\.\d\+\)\?/
" syn region tyRawString start=+'+ skip=+\\'+ end=+'+
" syn region tySpecialString start=+"+ skip=+\\"+ end=+"+

"syn match   tyCall /[a-z_]\%(\w\|-\)*[!?\\]\?(\@=/ contained contains=tySelf nextgroup=tyArgList
syn match   tyPartialApp /@/he=e+1 contained nextgroup=tyArgList
syn region  tyArgList matchgroup=tyArgListParen start=/(/ end=/)/ contains=@tyExpression,tyComma,tyKwArg contained
syn match   tyCtorPartialApp /@/he=e+1 contained nextgroup=tyCtorArgList
syn region  tyCtorArgList matchgroup=tyCtorArgListParen start=/(/ end=/)/ contains=@tyExpression,tyComma contained
syn match   tyComma contained /,/ skipwhite skipempty
"syn match   tyArg contained /\%(\*\|%\)\?\w\%(\w\|-\w\)*[!?]\?/ skipwhite skipempty nextgroup=tyParamConstraint,tyComma

syn match tyType /\K\@<![A-Z]\w*\%(\K\)\@!/ nextgroup=tyClassTypeParams
syn match tyCtor /\K\@<![A-Z]\w*\%(@\?(\)\@=/ nextgroup=tyCtorPartialApp,tyCtorArgList

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

syntax cluster tyExpression contains=tyBool,tyNumber,tyIdentifier,tyMemberAccess,tyKeyword,tyFunction,tyNil,tyOperator,tyInstanceVar,tySelf,tyCall,tySpecialString,tyString,tyType,tyCtor,tyRegexpString,tyDirective,tyComment,tyNotNil,tyDecoratorMacro,tyDecorator,tyParenthesizedExpression,tyQuasiQuoted,tyQQSpliceVar,tyQQSpliceVal,tyQQSpliceExpr,tyArray,tyDict,tyMatch,tyRecord,tyDo,tySemicolon

syntax cluster tyStatement contains=@tyExpression,tyBlock,tyEnvComment,tyUse,tyNullStatement

syntax match tyNullStatement /;/ skipempty skipwhite contained

syntax region  tyString           start=+\z([']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ contains=tySpecial extend
syntax region  tySpecialString    start=+\z(["]\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ contains=tySpecial,tyTemplateExpression extend
syntax match   tyNumber           /\c\%(\<\|[!?]\@<=\)-\=\%(\d[0-9_]*\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\%(\x\|_\)\+\)n\=\%([-!?]\@=\|\>\)/

syntax region  tyDocString           start=+\z('''\+\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ contains=tySpecial extend
syntax region  tyDocSpecialString    start=+\z("""\+\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ contains=tySpecial,tyTemplateExpression extend

syn region tyDecorator      matchgroup=tyDecoratorSymbol start=/@/ end=/$/ contains=tyDecoratorName,@tyExpression extend
syn region tyDecoratorMacro matchgroup=tyDecoratorMacroBracket start=/@{/  end=/}/  contains=tyDecoratorMacroName,@tyExpression extend

syn match  tyDecoratorName /\%(\d\)\@!\%(::\)\?\w\%(\w\|-\w\)*\%(::\K\%(\w|-\)*\)*[!?]\?/ contained contains=tyModAccess nextgroup=tyDecoratorArgList,tyDecoratorPartialApp
syn match  tyDecoratorMacroName /\%(\d\)\@!\%(::\)\?\w\%(\w\|-\w\)*\%(::\K\%(\w|-\)*\)*[!?]\?/ contained contains=tyModAccess nextgroup=tyDecoratorArgList,tyDecoratorPartialApp
syn match  tyDecoratorPartialApp /@/he=e+1 contained nextgroup=tyDecoratorArgList
syn region tyDecoratorArgList matchgroup=tyDecoratorParen start=/(/ end=/)/ contains=@tyExpression,tyComma contained


hi link tyEscapedReservedWord Normal
hi link tyImport              Include
hi link tyAs                  Keyword
hi link tyHiding              Keyword
hi link tyModPath             YellowItalic
hi link tyModAlias            YellowItalic
hi link tyModName             YellowItalic
hi link tyUse                 Include
hi link tyIdentifier          Normal
hi link tyField               Identifier
hi link tyFieldType           Operator
hi link tyModAccess           Conceal
hi link tyBool                Boolean
hi link tyNil                 Constant
hi link tyNumber              Number
hi link tyPub                 StorageClass
hi link tyClass               Structure
hi link tyClassName           Type
hi link tyExtend              Operator
hi link tySuperName           Type
hi link tyMethodName          Function
hi link tyFunction            Keyword
hi link tyFunctionName        Function
hi link tyCall                Function
hi link tyLet                 StorageClass
hi link tyKeyword             Keyword
hi link tyDo                  Keyword
hi link tyMatch               Keyword
hi link tyParam               Special
hi link tyParamDefault        Operator
hi link tyParamConstraint     Operator
hi link tyGatherParam         Special
hi link tyKwargsParam         Special
hi link tyParam               Special
hi link tyOperator            Operator
hi link tyNotNil              Special
hi link tyInstanceVar         Identifier
hi link tyMemberAccess        Identifier
hi link tyPartialApp          Macro
hi link tyCtorPartialApp      Macro
hi link tySelf                Constant
hi link tyString              String
hi link tySpecialString       String
hi link tyDocString           String
hi link tyDocSpecialString    String
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
hi link tyTypeParamsBracket   Normal
hi link tyCtor                Type
hi link tyComment             Comment
hi link tyEnvComment          Comment
hi link tyDirective           PreProc
hi link tyQuasiQuote          PreProc
hi link tyQQSplice            PreProc
hi link tyQQSpliceVar         Identifier

hi link tyDecoratorSymbol       Macro
hi link tyDecoratorName         Macro
hi link tyDecoratorMacroBracket Macro
hi link tyDecoratorMacroName    Macro
hi link tyDecoratorParen        Macro
hi link tyDecorator             Number

hi link tyArgListParen     Normal
hi link tyCtorArgListParen Type
hi link tyGroupParen       Normal
hi link tyArrayBracket     Normal
hi link tyDictBracket      Operator
hi link tySemicolon        Grey
hi link tyNullStatement    Grey
hi link tyKwArg            Identifier
