" Vim syntax file
" Language: Hare

if exists("b:current_syntax")
  finish
endif

syn case match
syn keyword tyKeyword let pub function macro import export defer _
syn keyword tyBranch for return break continue yield
syn keyword tyConditional if else match switch
" syn keyword tyBuiltin type  alloc assert append abort delete insert
" syn keyword tyBuiltin vastart vaarg vaend
syn keyword tyOperator in not and or
" syn match tyType "\v<size>((\_\s|//.*)*\()@!"
" syn match tyBuiltin "\v<size>((\_\s|//.*)*\()@="
" syn match tyPreProc "^use .*;"
" syn match tyPreProc "@[a-z]*"
syn match tyOperator "\.\.\." "\.\."

syn region tyString start=+\z(["']\)+ end=+\z1+ skip=+\\\\\|\\\z1+
syn region tyString start=+`+ end=+`+

"adapted from c.vim
"integer number, or floating point number without a dot and with "f".
syn match	tyNumbers		display transparent "\v<\d" contains=tyNumber,tyOctal,tyBinary,tyFloat
syn match	tyNumber		display contained "\v\d+(e[-+]?\d+)?(z|[iu](8|16|32|64)?)?"
"hex number
syn match	tyNumber		display contained "\v0x\x+(z|[iu](8|16|32|64)?)?"
"octal number
syn match	tyOctal		display contained "\v0o\o+(z|[iu](8|16|32|64)?)?"
"binary number
syn match	tyBinary		display contained '\v0b[01]+(z|[iu](8|16|32|64)?)?'
syn match	tyFloat		display contained "\v\d+(e[-+]?\d+)?(f32|f64)"
"floating point number, with dot, optional exponent
syn match	tyFloat		display contained "\v\d+\.\d+(e[-+]?\d+)?(f32|f64)?"

syn match	tySpaceError		display excludenl "\v\s+$"
syn match	tySpaceError		display "\v +\t"me=e-1

syn keyword tyTodo contained TODO FIXME XXX
syn region tyComment start="//" end="$" contains=tyTodo,@Spell

syn keyword tyNull nil
syn keyword tyBoolean true false

hi def link tyBinary Number
hi def link tyBoolean Boolean
hi def link tyBranch Repeat
hi def link tyBuiltin Function
hi def link tyComment Comment
hi def link tyConditional Conditional
hi def link tyFloat Number
hi def link tyKeyword Keyword
hi def link tyLabel Label
hi def link tyNull Constant
hi def link tyNumber Number
hi def link tyOctal Number
hi def link tyOperator Operator
hi def link tyPreProc PreProc
hi def link tyString String
hi def link tyTodo Todo
hi def link tyType Type

hi def link tySpaceError Error
autocmd InsertEnter * hi link tySpaceError NONE
autocmd InsertLeave * hi link tySpaceError Error

" vim: tabstop=8 shiftwidth=2 expandtab
