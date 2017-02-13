@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
#!/usr/bin/env python

from Tkinter import *
import tkFileDialog
import os
import subprocess as sub
import base64

def icon(tempFile):
    temp = os.getenv('LOCALAPPDATA')
    icon = \
    """ AAABAAEAECAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AAAAAA4AAAh/AAAVxAAACfIAAAnyAAAVxAAACH8AAAAO////AP///wD///8A////AP///wD///8A////AAAAAEIAAA3pAABx9wAAwP8AAO//AADv/wAAwP8AAHH3AAAN6QAAAEL///8A////AP///wD///8A////AAAAAEIAABfzAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AABfzAAAAQv///wD///8A////AAAAAA4AAA3pAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADL/wAADekAAAAO////AP///wAAAAh/AABx9wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAHH3AAAIf////wD///8AAAAVxAAAwP8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADA/wAAFcT///8A////AAAACfIAAO//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA7/8AAAny////AP///wAAAAnyAADv/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAO//AAAJ8v///wD///8AAAAVxAAAwP8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADA/wAAFcT///8A////AAAACH8AAHH3AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAAcfcAAAh/////AP///wAAAAAOAAAN6QAAy/8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AAA3pAAAADv///wD///8A////AAAAAEIAABfzAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AABfzAAAAQv///wD///8A////AP///wD///8AAAAAQgAADekAAHH3AADA/wAA7/8AAO//AADA/wAAcfcAAA3pAAAAQv///wD///8A////AP///wD///8A////AP///wAAAAAOAAAIfwAAFcQAAAnyAAAJ8gAAFcQAAAh/AAAADv///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A//8AAPw/AADwDwAA4AcAAMADAADAAwAAgAEAAIABAACAAQAAgAEAAMADAADAAwAA4AcAAPAPAAD8PwAA//8AAA==
    """
    icondata= base64.b64decode(icon)
    tempFile= temp+"icon.ico"
    iconfile= open(tempFile,"wb")
    iconfile.write(icondata)
    iconfile.close()
    return tempFile

def gui(tempFile):
    root = Tk()
    root.withdraw() # hide root
    root.wm_iconbitmap(tempFile)
    name = tkFileDialog.asksaveasfilename(filetypes=[('SVG','*.svg')], title='Save Graph as SVG', defaultextension='.svg')
    if name:
        with open(name, 'w') as f:
            p = sub.Popen(['dot', (os.getenv('PROCDOTPLUGIN_GraphFileDot')), '-Tsvg', '-o', (name) ], stdout=sub.PIPE, stderr=sub.PIPE)
            p.wait()

def main():
    tempFile = None
    tempFile = icon(tempFile)
    gui(tempFile)
    os.remove(tempFile)

if __name__ == '__main__':
    main()