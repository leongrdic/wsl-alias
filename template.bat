@echo off

if [%1]==[] goto empty

set pwd=%cd%
set pwd=%pwd:\=\\%

set cmd=%*
set cmd=%cmd:\"=\\"%
set cmd=%cmd:\'=\\'%
set cmd=%cmd:\=/%
set cmd=%cmd://=\\%
set cmd=%cmd:"=\"%
set cmd=%cmd:'=\'%

wsl ~/.wsl-alias/wrapper.sh '%pwd%' {alias_command} %cmd%

goto :eof

:empty
wsl ~/.wsl-alias/wrapper.sh '%pwd%' {alias_command}
