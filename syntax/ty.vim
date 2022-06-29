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

syntax match   tyNoise          /[:,;]/
syntax match   tyRange          /\.\.\+/ skipwhite skipempty nextgroup=@tyExpression
syntax match   tyDot            /\.\ze[^.]/ skipwhite skipempty nextgroup=tyObjectProp,tyFuncCall,tyPrototype,tyTaggedTemplate
syntax match   tyObjectProp     contained /\<\K\k*/
syntax match   tyFuncCall       /\<\K\k*\ze\s*(/
syntax match   tyParensError    /[)}\]]/

" Program Keywords
syntax keyword tyStorageClass   const var let pub skipwhite skipempty nextgroup=tyDestructuringBlock,tyDestructuringArray,tyVariableDef
"syntax keyword tyStorageClass   const var let pub skipwhite skipempty nextgroup=@tyExpression
syntax match   tyVariableDef    contained /\<\K\k*/ skipwhite skipempty nextgroup=tyFlowDefinition
syntax keyword tyOperatorKeyword delete instanceof typeof void not and or new in of skipwhite skipempty nextgroup=@tyExpression
syntax match   tyOperator       "[-!|&+<>=%/*~^]" skipwhite skipempty nextgroup=@tyExpression
syntax match   tyOperator       /::/ skipwhite skipempty nextgroup=@tyExpression
syntax keyword tyBooleanTrue    true
syntax keyword tyBooleanFalse   false
syntax match   tyIdentifier     /\<K\k*/ skipwhite skipempty

" Modules
syntax keyword tyImport                       import skipwhite skipempty nextgroup=tyModuleAsterisk,tyModuleKeyword,tyModuleGroup,tyFlowImportType
syntax keyword tyExport                       export skipwhite skipempty nextgroup=@tyAll,tyModuleGroup,tyExportDefault,tyModuleAsterisk,tyModuleKeyword,tyFlowTypeStatement
syntax match   tyModuleKeyword      contained /\<\K\k*/ skipwhite skipempty nextgroup=tyModuleAs,tyFrom,tyModuleComma
syntax keyword tyExportDefault      contained default skipwhite skipempty nextgroup=@tyExpression
syntax keyword tyExportDefaultGroup contained default skipwhite skipempty nextgroup=tyModuleAs,tyFrom,tyModuleComma
syntax match   tyModuleAsterisk     contained /\*/ skipwhite skipempty nextgroup=tyModuleKeyword,tyModuleAs,tyFrom
syntax keyword tyModuleAs           contained as skipwhite skipempty nextgroup=tyModuleKeyword,tyExportDefaultGroup
syntax keyword tyFrom               contained from skipwhite skipempty nextgroup=tyString
syntax match   tyModuleComma        contained /,/ skipwhite skipempty nextgroup=tyModuleKeyword,tyModuleAsterisk,tyModuleGroup,tyFlowTypeKeyword

" Strings, Templates, Numbers
syntax region  tyString           start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+  contains=tySpecial extend
syntax region  tyTemplateString   start=+`+  skip=+\\`+  end=+`+     contains=tyTemplateExpression,tySpecial extend
syntax match   tyTaggedTemplate   /\<\K\k*\ze`/ nextgroup=tyTemplateString
syntax match   tyNumber           /\c\<\%(\d\+\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\%(\x\|_\)\+\)n\=\>/
syntax keyword tyNumber           Infinity
syntax match   tyFloat            /\c\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%(e[+-]\=\d\+\)\=\>/

" Regular Expressions
syntax match   tySpecial            contained "\v\\%(x\x\x|u%(\x{4}|\{\x{4,5}})|c\u|.)"
syntax region  tyTemplateExpression contained matchgroup=tyTemplateBraces start=+${+ end=+}+ contains=@tyExpression keepend
syntax region  tyRegexpCharClass    contained start=+\[+ skip=+\\.+ end=+\]+ contains=tySpecial extend
syntax match   tyRegexpBoundary     contained "\v\c[$^]|\\b"
syntax match   tyRegexpBackRef      contained "\v\\[1-9]\d*"
syntax match   tyRegexpQuantifier   contained "\v[^\\]%([?*+]|\{\d+%(,\d*)?})\??"lc=1
syntax match   tyRegexpOr           contained "|"
syntax match   tyRegexpMod          contained "\v\(\?[:=!>]"lc=1
syntax region  tyRegexpGroup        contained start="[^\\]("lc=1 skip="\\.\|\[\(\\.\|[^]]\+\)\]" end=")" contains=tyRegexpCharClass,@tyRegexpSpecial keepend
syntax region  tyRegexpString   start=+\%(\%(\<return\|\<typeof\|\_[^)\]'"[:blank:][:alnum:]_$]\)\s*\)\@<=/\ze[^*/]+ skip=+\\.\|\[[^]]\{1,}\]+ end=+/[gimyus]\{,6}+ contains=tyRegexpCharClass,tyRegexpGroup,@tyRegexpSpecial oneline keepend extend
syntax cluster tyRegexpSpecial    contains=tySpecial,tyRegexpBoundary,tyRegexpBackRef,tyRegexpQuantifier,tyRegexpOr,tyRegexpMod

" Objects
syntax match   tyObjectShorthandProp contained /\<\k*\ze\s*/ skipwhite skipempty nextgroup=tyObjectSeparator
syntax match   tyObjectKey         contained /\<\k*\ze\s*:/ contains=tyFunctionKey skipwhite skipempty nextgroup=tyObjectValue
syntax region  tyObjectKeyString   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=tySpecial skipwhite skipempty nextgroup=tyObjectValue
syntax region  tyObjectKeyComputed contained matchgroup=tyBrackets start=/\[/ end=/]/ contains=@tyExpression skipwhite skipempty nextgroup=tyObjectValue,tyFuncArgs extend
syntax match   tyObjectSeparator   contained /,/
syntax region  tyObjectValue       contained matchgroup=tyObjectColon start=/:/ end=/[,}]\@=/ contains=@tyExpression extend
syntax match   tyObjectFuncName    contained /\<\K\k*\ze\_s*(/ skipwhite skipempty nextgroup=tyFuncArgs
syntax match   tyFunctionKey       contained /\<\K\k*\ze\s*:\s*function\>/
syntax match   tyObjectMethodType  contained /\<[gs]et\ze\s\+\K\k*/ skipwhite skipempty nextgroup=tyObjectFuncName
syntax region  tyObjectStringKey   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=tySpecial extend skipwhite skipempty nextgroup=tyFuncArgs,tyObjectValue

exe 'syntax keyword tyNull      null             '.(exists('g:ty_conceal_null')      ? 'conceal cchar='.g:ty_conceal_null       : '')
exe 'syntax keyword tyReturn    return contained '.(exists('g:ty_conceal_return')    ? 'conceal cchar='.g:ty_conceal_return     : '').' skipwhite nextgroup=@tyExpression'
exe 'syntax keyword tyUndefined undefined        '.(exists('g:ty_conceal_undefined') ? 'conceal cchar='.g:ty_conceal_undefined  : '')
exe 'syntax keyword tyNan       NaN              '.(exists('g:ty_conceal_NaN')       ? 'conceal cchar='.g:ty_conceal_NaN        : '')
exe 'syntax keyword tyPrototype prototype        '.(exists('g:ty_conceal_prototype') ? 'conceal cchar='.g:ty_conceal_prototype  : '')
exe 'syntax keyword tyThis      this             '.(exists('g:ty_conceal_this')      ? 'conceal cchar='.g:ty_conceal_this       : '')
exe 'syntax keyword tySuper     super  contained '.(exists('g:ty_conceal_super')     ? 'conceal cchar='.g:ty_conceal_super      : '')

syntax match tyInstanceVar /\<@\K\k*\>/ skipwhite skipempty

" Statement Keywords
syntax match   tyBlockLabel              /\<\K\k*\s*::\@!/    contains=tyNoise skipwhite skipempty nextgroup=tyBlock
syntax match   tyBlockLabelKey contained /\<\K\k*\ze\s*\_[;]/
syntax keyword tyStatement     contained with yield debugger
syntax keyword tyStatement     contained break continue skipwhite skipempty nextgroup=tyBlockLabelKey
syntax keyword tyMatch                  match           skipwhite skipempty
syntax keyword tyDefer                  defer           skipwhite skipempty
syntax keyword tyConditional            if              skipwhite skipempty nextgroup=tyParenIfElse
syntax keyword tyConditional            else            skipwhite skipempty nextgroup=tyCommentIfElse,tyIfElseBlock
syntax keyword tyConditional            switch          skipwhite skipempty nextgroup=tyParenSwitch
syntax keyword tyRepeat                 while for       skipwhite skipempty nextgroup=tyParenRepeat,tyForAwait
syntax keyword tyDo                     do              skipwhite skipempty nextgroup=tyRepeatBlock
syntax region  tySwitchCase   contained matchgroup=tyLabel start=/\<\%(case\|default\)\>/ end=/:\@=/ contains=@tyExpression,tyLabel skipwhite skipempty nextgroup=tySwitchColon keepend
syntax keyword tyTry                    try             skipwhite skipempty nextgroup=tyTryCatchBlock
syntax keyword tyFinally      contained finally         skipwhite skipempty nextgroup=tyFinallyBlock
syntax keyword tyCatch        contained catch           skipwhite skipempty nextgroup=tyParenCatch,tyTryCatchBlock
syntax keyword tyException              throw
syntax keyword tyAsyncKeyword           async await
syntax match   tySwitchColon   contained /::\@!/        skipwhite skipempty nextgroup=tySwitchBlock

" Keywords
syntax keyword tyGlobalObjects     ArrayBuffer Array BigInt BigInt64Array BigUint64Array Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray Boolean Buffer Collator DataView Date DateTimeFormat Function Intl Iterator JSON Map Set WeakMap WeakRef WeakSet Math Number NumberFormat Object ParallelArray Promise Proxy Reflect RegExp String Symbol Uint8ClampedArray WebAssembly console document fetch window
syntax keyword tyGlobalNodeObjects  module exports global process __dirname __filename
syntax match   tyGlobalNodeObjects  /\<require\>/ containedin=tyFuncCall
syntax keyword tyExceptions         Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError
syntax keyword tyBuiltins           decodeURI decodeURIComponent encodeURI encodeURIComponent eval isFinite isNaN parseFloat parseInt uneval
" DISCUSS: How imporant is this, really? Perhaps it should be linked to an error because I assume the keywords are reserved?
syntax keyword tyFutureKeys         abstract enum int short boolean interface byte long char final native synchronized float package throws goto private transient implements protected volatile double public

" DISCUSS: Should we really be matching stuff like this?
" DOM2 Objects
syntax keyword tyGlobalObjects  DOMImplementation DocumentFragment Document Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
syntax keyword tyExceptions     DOMException

" DISCUSS: Should we really be matching stuff like this?
" DOM2 CONSTANT
syntax keyword tyDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
syntax keyword tyDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE

" DISCUSS: Should we really be special matching on these props?
" HTML events and internal variables
syntax keyword tyHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize

" Code blocks
syntax region  tyBracket                      matchgroup=tyBrackets            start=/\[/ end=/\]/ contains=@tyExpression,tySpreadExpression extend fold
syntax region  tyParen                        matchgroup=tyParens              start=/(/  end=/)/  contains=@tyExpression extend fold nextgroup=tyFlowDefinition
syntax region  tyParenDecorator     contained matchgroup=tyParensDecorator     start=/(/  end=/)/  contains=@tyAll extend fold
syntax region  tyParenIfElse        contained matchgroup=tyParensIfElse        start=/(/  end=/)/  contains=@tyAll skipwhite skipempty nextgroup=tyCommentIfElse,tyIfElseBlock,tyReturn extend fold
syntax region  tyParenRepeat        contained matchgroup=tyParensRepeat        start=/(/  end=/)/  contains=@tyAll skipwhite skipempty nextgroup=tyCommentRepeat,tyRepeatBlock,tyReturn extend fold
syntax region  tyParenSwitch        contained matchgroup=tyParensSwitch        start=/(/  end=/)/  contains=@tyAll skipwhite skipempty nextgroup=tySwitchBlock extend fold
syntax region  tyParenCatch         contained matchgroup=tyParensCatch         start=/(/  end=/)/  skipwhite skipempty nextgroup=tyTryCatchBlock extend fold
syntax region  tyFuncArgs           contained matchgroup=tyFuncParens          start=/(/  end=/)/  contains=tyFuncArgCommas,tyComment,tyFuncArgExpression,tyDestructuringBlock,tyDestructuringArray,tyRestExpression,tyFlowArgumentDef skipwhite skipempty nextgroup=tyCommentFunction,tyFuncBlock,tyFlowReturn extend fold
syntax region  tyClassBlock         contained matchgroup=tyClassBraces         start=/{/  end=/}/  contains=tyClassFuncName,tyClassMethodType,tyArrowFunction,tyArrowFuncArgs,tyComment,tyGenerator,tyDecorator,tyClassProperty,tyClassPropertyComputed,tyClassStringKey,tyAsyncKeyword,tyNoise extend fold
syntax region  tyFuncBlock          contained matchgroup=tyFuncBraces          start=/{/  end=/}/  contains=@tyAll,tyBlock extend fold
syntax region  tyIfElseBlock        contained matchgroup=tyIfElseBraces        start=/{/  end=/}/  contains=@tyAll,tyBlock extend fold
syntax region  tyTryCatchBlock      contained matchgroup=tyTryCatchBraces      start=/{/  end=/}/  contains=@tyAll,tyBlock skipwhite skipempty nextgroup=tyCatch,tyFinally extend fold
syntax region  tyFinallyBlock       contained matchgroup=tyFinallyBraces       start=/{/  end=/}/  contains=@tyAll,tyBlock extend fold
syntax region  tySwitchBlock        contained matchgroup=tySwitchBraces        start=/{/  end=/}/  contains=@tyAll,tyBlock,tySwitchCase extend fold
syntax region  tyRepeatBlock        contained matchgroup=tyRepeatBraces        start=/{/  end=/}/  contains=@tyAll,tyBlock extend fold
syntax region  tyDestructuringBlock contained matchgroup=tyDestructuringBraces start=/{/  end=/}/  contains=tyDestructuringProperty,tyDestructuringAssignment,tyDestructuringNoise,tyDestructuringPropertyComputed,tySpreadExpression,tyComment nextgroup=tyFlowDefinition extend fold
syntax region  tyDestructuringArray contained matchgroup=tyDestructuringBraces start=/\[/ end=/\]/ contains=tyDestructuringPropertyValue,tyDestructuringNoise,tyDestructuringProperty,tySpreadExpression,tyDestructuringBlock,tyDestructuringArray,tyComment nextgroup=tyFlowDefinition extend fold
syntax region  tyObject             contained matchgroup=tyObjectBraces        start=/{/  end=/}/  contains=tyObjectKey,tyObjectKeyString,tyObjectKeyComputed,tyObjectShorthandProp,tyObjectSeparator,tyObjectFuncName,tyObjectMethodType,tyGenerator,tyComment,tyObjectStringKey,tySpreadExpression,tyDecorator,tyAsyncKeyword,tyTemplateString extend fold
syntax region  tyBlock                        matchgroup=tyBraces              start=/{/  end=/}/  contains=@tyAll,tySpreadExpression extend fold
syntax region  tyModuleGroup        contained matchgroup=tyModuleBraces        start=/{/ end=/}/   contains=tyModuleKeyword,tyModuleComma,tyModuleAs,tyComment,tyFlowTypeKeyword skipwhite skipempty nextgroup=tyFrom fold
syntax region  tySpreadExpression   contained matchgroup=tySpreadOperator      start=/\.\.\./ end=/[,}\]]\@=/ contains=@tyExpression
syntax region  tyRestExpression     contained matchgroup=tyRestOperator        start=/\.\.\./ end=/[,)]\@=/
syntax region  tyTernaryIf                    matchgroup=tyTernaryIfOperator   start=/?:\@!/  end=/\%(:\|}\@=\)/  contains=@tyExpression extend skipwhite skipempty nextgroup=@tyExpression
" These must occur here or they will be override by tyTernaryIf
syntax match   tyOperator           /?\.\ze\_D/
syntax match   tyOperator           /??/ skipwhite skipempty nextgroup=@tyExpression

syntax match   tyGenerator            contained /\*/ skipwhite skipempty nextgroup=tyFuncName,tyFuncArgs,tyFlowFunctionGroup
syntax match   tyFuncName             contained /\<\K\k*/ skipwhite skipempty nextgroup=tyFuncArgs,tyFlowFunctionGroup
syntax region  tyFuncArgExpression    contained matchgroup=tyFuncArgOperator start=/=/ end=/[,)]\@=/ contains=@tyExpression extend
syntax match   tyFuncArgCommas        contained ','
syntax keyword tyArguments            contained arguments
syntax keyword tyForAwait             contained await skipwhite skipempty nextgroup=tyParenRepeat

" Matches a single keyword argument with no parens
syntax match   tyArrowFuncArgs  /\<\K\k*\ze\s*->/ skipwhite contains=tyFuncArgs skipwhite skipempty nextgroup=tyArrowFunction extend
" Matches a series of arguments surrounded in parens
syntax match   tyArrowFuncArgs  /([^()]*)\ze\s*->/ contains=tyFuncArgs skipempty skipwhite nextgroup=tyArrowFunction extend

exe 'syntax match tyFunction /\<\(function\|macro\)\>/      skipwhite skipempty nextgroup=tyGenerator,tyFuncName,tyFuncArgs,tyFlowFunctionGroup skipwhite '.(exists('g:ty_conceal_function') ? 'conceal cchar='.g:ty_conceal_function : '')
exe 'syntax match tyArrowFunction /->/           skipwhite skipempty nextgroup=tyFuncBlock,tyCommentFunction '.(exists('g:ty_conceal_arrow_function') ? 'conceal cchar='.g:ty_conceal_arrow_function : '')
exe 'syntax match tyArrowFunction /()\ze\s*->/   skipwhite skipempty nextgroup=tyArrowFunction '.(exists('g:ty_conceal_noarg_arrow_function') ? 'conceal cchar='.g:ty_conceal_noarg_arrow_function : '')
exe 'syntax match tyArrowFunction /_\ze\s*->/    skipwhite skipempty nextgroup=tyArrowFunction '.(exists('g:ty_conceal_underscore_arrow_function') ? 'conceal cchar='.g:ty_conceal_underscore_arrow_function : '')

" Classes
syntax keyword tyClassKeyword           contained class tag
syntax keyword tyExtendsKeyword         contained extends skipwhite skipempty nextgroup=@tyExpression
syntax match   tyClassNoise             contained /\./
syntax match   tyClassFuncName          contained /\<\%(\K\k*\|[-<>+*&|:]\+\)\ze\s*[(]/ skipwhite skipempty nextgroup=tyFuncArgs,tyFlowClassFunctionGroup
syntax match   tyClassMethodType        contained /\<\%([gs]et\|static\)\ze\s\+\K\k*/ skipwhite skipempty nextgroup=tyAsyncKeyword,tyClassFuncName,tyClassProperty
syntax region  tyClassDefinition                  start=/\<\(class\|tag\)\>/ end=/\(\<extends\>\s\+\)\@!{\@=/ contains=tyClassKeyword,tyExtendsKeyword,tyClassNoise,@tyExpression,tyFlowClassGroup skipwhite skipempty nextgroup=tyCommentClass,tyClassBlock,tyFlowClassGroup
syntax match   tyClassProperty          contained /\<\K\k*\ze\s*[=;]/ skipwhite skipempty nextgroup=tyClassValue,tyFlowClassDef
syntax region  tyClassValue             contained start=/=/ end=/\_[;}]\@=/ contains=@tyExpression
syntax region  tyClassPropertyComputed  contained matchgroup=tyBrackets start=/\[/ end=/]/ contains=@tyExpression skipwhite skipempty nextgroup=tyFuncArgs,tyClassValue extend
syntax region  tyClassStringKey         contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=tySpecial extend skipwhite skipempty nextgroup=tyFuncArgs

" Destructuring
syntax match   tyDestructuringPropertyValue     contained /\k\+/
syntax match   tyDestructuringProperty          contained /\k\+\ze\s*=/ skipwhite skipempty nextgroup=tyDestructuringValue
syntax match   tyDestructuringAssignment        contained /\k\+\ze\s*:/ skipwhite skipempty nextgroup=tyDestructuringValueAssignment
syntax region  tyDestructuringValue             contained start=/=/ end=/[,}\]]\@=/ contains=@tyExpression extend
syntax region  tyDestructuringValueAssignment   contained start=/:/ end=/[,}=]\@=/ contains=tyDestructuringPropertyValue,tyDestructuringBlock,tyNoise,tyDestructuringNoise skipwhite skipempty nextgroup=tyDestructuringValue extend
syntax match   tyDestructuringNoise             contained /[,[\]]/
syntax region  tyDestructuringPropertyComputed  contained matchgroup=tyDestructuringBraces start=/\[/ end=/]/ contains=@tyExpression skipwhite skipempty nextgroup=tyDestructuringValue,tyDestructuringValueAssignment,tyDestructuringNoise extend fold

" Comments
syntax keyword tyCommentTodo    contained TODO FIXME XXX TBD NOTE
syntax region  tyComment        start=+//+ end=/$/ contains=tyCommentTodo,@Spell extend keepend
syntax region  tyComment        start=+/\*+  end=+\*/+ contains=tyCommentTodo,@Spell fold extend keepend
syntax region  tyEnvComment     start=/\%^#!/ end=/$/ display

" Specialized Comments - These are special comment regexes that are used in
" odd places that maintain the proper nextgroup functionality. It sucks we
" can't make tyComment a skippable type of group for nextgroup
syntax region  tyCommentFunction    contained start=+//+ end=/$/    contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyFuncBlock,tyFlowReturn extend keepend
syntax region  tyCommentFunction    contained start=+/\*+ end=+\*/+ contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyFuncBlock,tyFlowReturn fold extend keepend
syntax region  tyCommentClass       contained start=+//+ end=/$/    contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyClassBlock,tyFlowClassGroup extend keepend
syntax region  tyCommentClass       contained start=+/\*+ end=+\*/+ contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyClassBlock,tyFlowClassGroup fold extend keepend
syntax region  tyCommentIfElse      contained start=+//+ end=/$/    contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyIfElseBlock extend keepend
syntax region  tyCommentIfElse      contained start=+/\*+ end=+\*/+ contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyIfElseBlock fold extend keepend
syntax region  tyCommentRepeat      contained start=+//+ end=/$/    contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyRepeatBlock extend keepend
syntax region  tyCommentRepeat      contained start=+/\*+ end=+\*/+ contains=tyCommentTodo,@Spell skipwhite skipempty nextgroup=tyRepeatBlock fold extend keepend

" Decorators
syntax match   tyDecorator                    /^\s*@/ nextgroup=tyDecoratorFunction
syntax match   tyDecoratorFunction  contained /\h[a-zA-Z0-9_.]*/ nextgroup=tyParenDecorator

if exists("ty_plugin_jsdoc")
  runtime extras/jsdoc.vim
  " NGDoc requires JSDoc
  if exists("ty_plugin_ngdoc")
    runtime extras/ngdoc.vim
  endif
endif

if exists("ty_plugin_flow")
  runtime extras/flow.vim
endif

syntax cluster tyExpression  contains=tyBracket,tyParen,tyObject,tyTernaryIf,tyTaggedTemplate,tyTemplateString,tyString,tyRegexpString,tyNumber,tyFloat,tyOperator,tyOperatorKeyword,tyBooleanTrue,tyBooleanFalse,tyNull,tyFunction,tyArrowFunction,tyGlobalObjects,tyExceptions,tyFutureKeys,tyDomErrNo,tyDomNodeConsts,tyHtmlEvents,tyFuncCall,tyUndefined,tyNan,tyPrototype,tyBuiltins,tyNoise,tyClassDefinition,tyArrowFunction,tyArrowFuncArgs,tyParensError,tyComment,tyArguments,tyThis,tySuper,tyDo,tyForAwait,tyAsyncKeyword,tyStatement,tyRange,tyDot,tyInstanceVar,tyIdentifier
syntax cluster tyAll         contains=@tyExpression,tyStorageClass,tyConditional,tyRepeat,tyReturn,tyException,tyTry,tyNoise,tyBlockLabel,tyMatch,tyDefer

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ty_syn_inits")
  if version < 508
    let did_ty_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink tyComment              Comment
  HiLink tyEnvComment           PreProc
  HiLink tyParensIfElse         tyParens
  HiLink tyParensRepeat         tyParens
  HiLink tyParensSwitch         tyParens
  HiLink tyParensCatch          tyParens
  HiLink tyCommentTodo          Todo
  HiLink tyString               String
  HiLink tyObjectKeyString      String
  HiLink tyTemplateString       String
  HiLink tyObjectStringKey      String
  HiLink tyClassStringKey       String
  HiLink tyTaggedTemplate       StorageClass
  HiLink tyTernaryIfOperator    Operator
  HiLink tyRegexpString         String
  HiLink tyRegexpBoundary       SpecialChar
  HiLink tyRegexpQuantifier     SpecialChar
  HiLink tyRegexpOr             Conditional
  HiLink tyRegexpMod            SpecialChar
  HiLink tyRegexpBackRef        SpecialChar
  HiLink tyRegexpGroup          tyRegexpString
  HiLink tyRegexpCharClass      Character
  HiLink tyCharacter            Character
  HiLink tyPrototype            Special
  HiLink tyConditional          Conditional
  HiLink tyMatch                Conditional
  HiLink tyDefer                Statement
  HiLink tyBranch               Conditional
  HiLink tyLabel                Label
  HiLink tyReturn               Statement
  HiLink tyRepeat               Repeat
  HiLink tyDo                   Repeat
  HiLink tyStatement            Statement
  HiLink tyException            Exception
  HiLink tyTry                  Exception
  HiLink tyFinally              Exception
  HiLink tyCatch                Exception
  HiLink tyAsyncKeyword         Keyword
  HiLink tyForAwait             Keyword
  HiLink tyArrowFunction        Type
  HiLink tyFunction             Type
  HiLink tyGenerator            tyFunction
  HiLink tyArrowFuncArgs        tyFuncArgs
  HiLink tyFuncName             Function
  HiLink tyFuncCall             Function
  HiLink tyIdentifier           Identifier
  HiLink tyClassFuncName        tyFuncName
  HiLink tyObjectFuncName       Function
  HiLink tyArguments            Special
  HiLink tyError                Error
  HiLink tyParensError          Error
  HiLink tyOperatorKeyword      tyOperator
  HiLink tyOperator             Operator
  HiLink tyOf                   Operator
  HiLink tyStorageClass         StorageClass
  HiLink tyClassKeyword         Keyword
  HiLink tyExtendsKeyword       Keyword
  HiLink tyThis                 Special
  HiLink tySuper                Constant
  HiLink tyNan                  Number
  HiLink tyNull                 Type
  HiLink tyUndefined            Type
  HiLink tyNumber               Number
  HiLink tyFloat                Float
  HiLink tyBooleanTrue          Boolean
  HiLink tyBooleanFalse         Boolean
  HiLink tyObjectColon          tyNoise
  HiLink tyNoise                Noise
  HiLink tyDot                  Noise
  HiLink tyBrackets             Noise
  HiLink tyParens               Noise
  HiLink tyBraces               Noise
  HiLink tyFuncBraces           Noise
  HiLink tyFuncParens           Noise
  HiLink tyClassBraces          Noise
  HiLink tyClassNoise           Noise
  HiLink tyIfElseBraces         Noise
  HiLink tyTryCatchBraces       Noise
  HiLink tyModuleBraces         Noise
  HiLink tyObjectBraces         Noise
  HiLink tyObjectSeparator      Noise
  HiLink tyFinallyBraces        Noise
  HiLink tyRepeatBraces         Noise
  HiLink tySwitchBraces         Noise
  HiLink tySpecial              Special
  HiLink tyTemplateBraces       Noise
  HiLink tyGlobalObjects        Constant
  HiLink tyGlobalNodeObjects    Constant
  HiLink tyExceptions           Constant
  HiLink tyBuiltins             Constant
  HiLink tyImport               Include
  HiLink tyExport               Include
  HiLink tyExportDefault        StorageClass
  HiLink tyExportDefaultGroup   tyExportDefault
  HiLink tyModuleAs             Include
  HiLink tyModuleComma          tyNoise
  HiLink tyModuleAsterisk       Noise
  HiLink tyFrom                 Include
  HiLink tyDecorator            Special
  HiLink tyDecoratorFunction    Function
  HiLink tyParensDecorator      tyParens
  HiLink tyFuncArgOperator      tyFuncArgs
  HiLink tyClassProperty        tyObjectKey
  HiLink tyObjectShorthandProp  tyObjectKey
  HiLink tySpreadOperator       Operator
  HiLink tyRestOperator         Operator
  HiLink tyRestExpression       tyFuncArgs
  HiLink tySwitchColon          Noise
  HiLink tyClassMethodType      Type
  HiLink tyObjectMethodType     Type
  HiLink tyClassDefinition      tyFuncName
  HiLink tyBlockLabel           Identifier
  HiLink tyBlockLabelKey        tyBlockLabel

  HiLink tyDestructuringBraces     Noise
  HiLink tyDestructuringProperty   tyFuncArgs
  HiLink tyDestructuringAssignment tyObjectKey
  HiLink tyDestructuringNoise      Noise

  HiLink tyCommentFunction      tyComment
  HiLink tyCommentClass         tyComment
  HiLink tyCommentIfElse        tyComment
  HiLink tyCommentRepeat        tyComment

  HiLink tyDomErrNo             Constant
  HiLink tyDomNodeConsts        Constant
  HiLink tyDomElemAttrs         Label
  HiLink tyDomElemFuncs         PreProc

  HiLink tyHtmlEvents           Special
  HiLink tyHtmlElemAttrs        Label
  HiLink tyHtmlElemFuncs        PreProc

  HiLink tyCssStyles            Label

  HiLink tyInstanceVar          Identifier
  HiLink tyRange                Operator

  delcommand HiLink
endif

syntax cluster  tyExpression contains=@tyAll

let b:current_syntax = "ty"
if main_syntax == 'ty'
  unlet main_syntax
endif
