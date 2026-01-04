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

" Function to run current file with ty interpreter
function! s:RunTyFile()
  let l:file = expand('%:p')
  if empty(l:file)
    echohl ErrorMsg
    echo 'No file to run'
    echohl None
    return
  endif

  " Save current file if modified
  if &modified
    write
  endif

  " Store the current window number to return to later
  let l:origin_win = winnr()

  " Open terminal in a split at the bottom
  botright new

  " Run ty in the terminal
  call termopen('ty ' . shellescape(l:file), {
    \ 'on_exit': function('s:OnTyExit', [l:origin_win])
    \ })

  " Enter insert mode to see output immediately
  startinsert
endfunction

" Callback when ty process exits
function! s:OnTyExit(origin_win, job_id, exit_code, event)
  " Switch to normal mode
  stopinsert

  " Set up q to close the terminal and return to original window
  nnoremap <buffer> q :call <SID>CloseTyTerminal()<CR>

  " Store origin window for the close function
  let b:ty_origin_win = a:origin_win

  " Show exit status
  if a:exit_code != 0
    echohl ErrorMsg
    echo 'ty exited with code ' . a:exit_code . ' (press q to close)'
    echohl None
  else
    echo 'ty completed successfully (press q to close)'
  endif
endfunction

" Close terminal and return to original window
function! s:CloseTyTerminal()
  let l:origin_win = get(b:, 'ty_origin_win', 1)

  " Close the terminal buffer
  bdelete!

  " Try to return to the original window
  if winnr() != l:origin_win && l:origin_win <= winnr('$')
    execute l:origin_win . 'wincmd w'
  endif
endfunction

" Map <leader>r to run the current file
nnoremap <buffer> <leader>r :call <SID>RunTyFile()<CR>

" vim: tabstop=2 shiftwidth=2 expandtab
