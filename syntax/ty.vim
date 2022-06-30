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
  syntax iskeyword @,48-57,_,192-255,$,?,!,|,&,:,<,>,@-@
else
  setlocal iskeyword+=$
  setlocal iskeyword+=?
endif

syntax sync fromstart

" TODO: Figure out what type of casing I need
" syntax case ignore
syntax case match

syn match   tyIdentifier /\w\+[!?]\?/

" Modules
syn match   tyNewline contained /\n\|$/
syn match   tyModAlias contained /\w\+[!?]\?/ skipwhite nextgroup=tyImportList,tyNewline
syn keyword tyImport contained import skipwhite nextgroup=tyModPath
syn match   tyModPath contained /\w\+\%(\%(::\|\.\)\w\+\)*/ skipwhite nextgroup=tyAs,tyImportList,tyNewline
syn keyword tyAs contained as skipwhite nextgroup=tyModAlias
syn region  tyImportList contained start=/(/ end=/)/ contains=tyIdentifier skipwhite nextgroup=tyNewline
syn region  tyImportStatement start=/\%(import\)\@=/ end=/\n/ contains=tyImport

syn keyword tyBool true false
syn keyword tyPub pub

" Classes / Tags
syn keyword tyClass class tag skipwhite skipempty nextgroup=tyClassName
syn match   tyClassName contained /\w\+/ skipwhite skipempty nextgroup=tyTagSemicolon,tyClassBlock,tyExtend
syn match   tyExtend contained /:/ skipwhite skipempty nextgroup=tySuperName
syn match   tySuperName contained /\w\+\%(\%(::\|\.\)\w\+\)*/ skipwhite skipempty nextgroup=tyTagSemicolon,tyClassBlock
syn match   tyTagSemicolon contained /;/
syn region  tyClassBlock contained start=/{/ end=/}/ contains=tyMethodName
syn match   tyMethodName contained /\%(\w\+[!?]\?\)\|\%([<>=+*^&!:.|-]\+\)/ skipwhite skipempty nextgroup=tyParamList
syn match   tyInstanceVar contained /@\w\+[!?]\?/ containedin=tyClassBlock
syn keyword tySelf contained self containedin=tyClassBlock

syn region  tyParamList contained start=/(/ end=/)/ keepend contains=tyParam,tyParamDefault skipwhite skipempty nextgroup=@tyStatement
syn match   tyParam contained /\%(\*\|%\)\?\w\+[!?]\?/ skipwhite skipempty nextgroup=tyParamConstraint
syn region  tyParamConstraint contained start=':' end=/,\|)\|\%(=\@=\)/ contains=@tyExpression
syn match   tyParamDefault contained '=' skipwhite skipempty nextgroup=@tyExpression

syn region tyBlock contained matchgroup=tyBraces start=/{/  end=/}/  contains=@tyStatement,tyBlock extend fold

syn keyword tyNil nil
syn keyword tyKeyword let pub function match while for if else try catch finally throw return in not and or yield break continue macro operator
syn match   tyOperator /\%(#\)\|\%([<>=+*^&!:.|-]\+\)/
syn match tyNumber /-\?\%(0x\)\?\d\+\%(\.\d\+\)\?/

syn region tyRawString start=+'+ skip=+\\'+ end=+'+
syn region tySpecialString start=+"+ skip=+\\"+ end=+"+

syn match tyCall /[a-z_]\w*[!?]\?(\@=/
syn match tyType /[A-Z]\w*(\@!/
syn match tyCtor /[A-Z]\w*(\@=/


syntax cluster tyExpression contains=tyBool,tyNumber,tyIdentifier,tyKeyword,tyNil,tyOperator,tyInstanceVar,tySelf,tyCall,tySpecialString,tyString,tyType,tyCtor
syntax cluster tyStatement contains=@tyExpression,tyBlock

hi link tyImport             Include
hi link tyAs                 Keyword
hi link tyModPath            YellowItalic
hi link tyModAlias           YellowItalic
hi link tyIdentifier         Identifier
hi link tyBool               Boolean
hi link tyNil                Constant
hi link tyNumber             Constant
hi link tyPub                StorageClass
hi link tyClass              Structure
hi link tyClassName          Type
hi link tySuperName          Type
hi link tyMethodName         Function
hi link tyCall               Function
hi link tyLet                StorageClass
hi link tyKeyword            Keyword
hi link tyParam              Special
hi link tyOperator           Operator
hi link tyInstanceVar        Identifier
hi link tySelf               Orange
hi link tyRawString          String
hi link tySpecialString      String
hi link tyType               Type
hi link tyCtor               Type
