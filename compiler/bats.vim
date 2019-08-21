if exists("current_compiler")
  finish
endif

let current_compiler = 'bats'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=bats\ %

let s:errorformat = join([
  \ '%Enot ok %m',
  \ '%-C# (in test file %f\\, line %l)',
  \ '%-C#  %m',
  \ '%-G%.%#',
  \ '%Z'
  \ ], ',')

execute 'CompilerSet errorformat=' . escape(s:errorformat, ' ')

