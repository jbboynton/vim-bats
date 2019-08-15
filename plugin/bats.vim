let s:default_command = "bats {test}"

function! RunBatsTests()
  let s:last_test = ""

  call s:RunTests(s:last_test)
endfunction

function! RunCurrentBatsTest()
  if s:InTestFile()
    let s:last_test_file = s:CurrentFilePath()
    let s:last_test = s:last_test_file

    call s:RunTests(s:last_test_file)
  elseif exists("s:last_test_file")
    call s:RunTests(s:last_test_file)
  endif
endfunction

function! RunLastBatsTest()
  if exists("s:last_test")
    call s:RunTests(s:last_test)
  endif
endfunction

" Private
" -------

function! s:RunTests(test_location)
  let s:bats_command =
    \ substitute(s:BatsCommand(), "{test}", a:test_location, "g")

  execute s:bats_command
endfunction

function! s:InTestFile()
  return match(expand("%"), ".bats$") != -1
endfunction

function! s:BatsCommand()
  if s:BatsCommandProvided()
    let l:command = g:bats_command
  else
    let l:command = s:DefaultCommand()
  endif

  return l:command
endfunction

function! s:BatsCommandProvided()
  return exists("g:bats_command")
endfunction

function! s:DefaultCommand()
  return "!clear && echo " . s:default_command . " && " . s:default_command
endfunction

function! s:CurrentFilePath()
  return @%
endfunction
