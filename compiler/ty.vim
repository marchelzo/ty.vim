" Vim compiler file
" Compiler: Ty Compiler

if exists("g:current_compiler")
  finish
endif
let g:current_compiler = "ty"

let s:cpo_save = &cpo
set cpo&vim

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

if filereadable("Makefile") || filereadable("makefile")
  CompilerSet makeprg=make
else
  CompilerSet makeprg=ty
endif

CompilerSet errorformat=
  \CompileError:\ %m%p,
  \ParseError:\ %m%p,
  \ParseError:\ %f:%l:%c:\ %m,
  \Syntax\ error:\ %.%#\ at\ %f:%l:%c\\,\ %m,
  \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: tabstop=2 shiftwidth=2 expandtab
