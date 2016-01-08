@echo off
setlocal enabledelayedexpansion
set out=%PROCDOTPLUGIN_ResultTXT%
set tcpflow=<path to tcpflow>
set temp=%LOCALAPPDATA%\temp\tcpflow_out
set IP=%PROCDOTPLUGIN_CurrentNode_Details_IP-Address%

%tcpflow% -o %temp% -r %PROCDOTPLUGIN_WindumpFilePcap%

call :parse %IP%
set new_IP=%one:~-3%.%two:~-3%.%three:~-3%.%four:~-3%
type %temp%\*%new_IP%* > %out%
rmdir /S /Q %temp%

:parse
set list=%1
FOR /f "tokens=1,2,3,4 delims=." %%a IN ("%list%") DO (
  set one=00%%a
  set two=00%%b
  set three=00%%c
  set four=00%%d
)
exit /b
