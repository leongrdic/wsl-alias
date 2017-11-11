@echo off

if [%1]==[] goto empty

set uri=%cd%
set uri=%uri:\=\\%

set cmd=%*
set cmd=%cmd:\"=\\"%
set cmd=%cmd:\'=\\'%
set cmd=%cmd:"=\"%
set cmd=%cmd:'=\'%

wsl ~/.wsl/wrapper.sh '%cd%' {alias} %cmd%

goto :eof

:empty
wsl ~/.wsl/wrapper.sh '%cd%' {alias}
