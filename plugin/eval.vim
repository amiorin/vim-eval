function! s:EvalVimLRegion(s,e)
  let lines = getline(a:s,a:e)
  let file = tempname()
  call writefile(lines,file)
  execute ':source '.file
  call delete(file)
endfunction

command! -range EvalVimL  :call s:EvalVimLRegion(<line1>,<line2>)
nnoremap <silent> <Plug>eval_viml :EvalVimL<CR>
vnoremap <silent> <Plug>eval_viml_region :EvalVimL<CR>

function! s:initVariable(var, value)
  if !exists(a:var)
    exec 'let ' . a:var . ' = ' . "'" . substitute(a:value, "'", "''", "g") . "'"
    return 1
  endif
  return 0
endfunction

call s:initVariable("g:eval_viml_n", "<C-c>")
call s:initVariable("g:eval_viml_v", "<C-c>")

if !exists('g:eval_viml_map_keys') || g:eval_viml_map_keys
  augroup EvalVimL
    autocmd!
    execute 'autocmd filetype vim :nmap <silent> ' . g:eval_viml_n . ' <Plug>eval_viml'
    execute 'autocmd filetype vim :vmap <silent> ' . g:eval_viml_v . ' <Plug>eval_viml_region'
  augroup END
endif
