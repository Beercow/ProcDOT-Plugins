@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
#!/usr/bin/env python

import os
os.system("start /wait cmd /K")
