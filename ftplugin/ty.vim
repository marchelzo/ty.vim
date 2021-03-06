" Ty filetype plugin
" Maintainer: Brad Garagan <bradgaragan@gmail.com>
" Last Updated: 2022-06-29

" Only do this when not done yet for this buffer
if exists('b:did_ftplugin')
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

setlocal expandtab
setlocal tabstop=8
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal textwidth=120
setlocal commentstring=//\ %s

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql

compiler ty
" vim: tabstop=2 shiftwidth=2 expandtab
