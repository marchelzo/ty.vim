au BufRead,BufNewFile *.ty set filetype=ty

if has("nvim")
  let s:started = 0
  function! s:Start()
    if s:started
      return
    end
    let s:started = 1
	lua require('vim.lsp.log').set_level('TRACE')
    lua require('lsp').start()
  endfunction
  au FileType ty call s:Start()
end
