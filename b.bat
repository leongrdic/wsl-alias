@echo off

if [%1]==[] goto empty

set params=%*
set params=%params:\"=\\\\"%
set params=%params:"=\\\"%
bash -c "$HOME/.wsl/b.sh '%cd%' \"%params%\""

goto :eof

:empty
bash -c "$HOME/.wsl/b.sh '%cd%'"