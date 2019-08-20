autocmd BufRead,BufNewFile *.bats setfiletype bats
autocmd BufRead,BufNewFile * call s:DetectBats()

function! s:DetectBats()
  if getline(1) =~# '^#!.*\<bats\>'
    let &filetype = 'bats'
  endif
endfunction
