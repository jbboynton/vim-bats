let s:default_command = "bats {test}"

function! RunBatsTests()
  let s:last_test = ""
  let s:all_test_files = s:AllTests()

  call s:RunTests(s:all_test_files)
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

function! s:BatsDirectory()
  if s:BatsDirectoryProvided()
    let l:directory = g:bats_directory
  else
    let l:directory = s:DefaultDirectory()
  endif

  return l:directory
endfunction

function! s:BatsDirectoryProvided()
  return exists("g:bats_directory")
endfunction

function! s:CurrentDirectory()
  return expand("%:p:h")
endfunction

function! s:ProjectRoot()
  let l:git_directory = system("git rev-parse --show-toplevel")[:-2]
  let l:repo_exists = !filereadable(l:git_directory)

  s:RaiseUnlessRepoExists(l:repo_exists)

  return fnameescape(l:git_directory)
endfunction

function! s:RaiseUnlessRepoExists(repo_exists)
  if empty(a:repo_exists)
    return 1
  endif

  let l:message = "Error: unable to locate the tests directory. Fix this " .
    \ "issue by assigning a value to g:bats_directory. " .
    \ "See :h bats_directory for more information."

  throw l:message
endfunction

function! s:DefaultDirectory()
  return s:ProjectRoot() . "/test"
endfunction

function! s:AllTests()
  return s:BatsDirectory() . "/**/*.bats"
endfunction

function! s:CurrentFilePath()
  return @%
endfunction
