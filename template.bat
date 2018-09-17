@echo off

REM  this file is generated using wsl-alias by leongrdic
REM  https://github.com/leongrdic/wsl-alias

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
