Plugin will show up in the main menu plugins.

Requires python 2.7

No GUI at this time.

To use, change the first line in save_as_png.bat to match your python executable.

Example: @setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!

change py to python.

To change the size of the png, change the number in -Gdpi= on line 29.
