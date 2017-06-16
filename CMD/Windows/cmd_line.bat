@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
import os
os.system("start /wait cmd /K")