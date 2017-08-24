@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
#!/usr/bin/env python

from Tkinter import *
import Tkconstants
import tkFileDialog
import os
import sys
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

def asksaveasfilename(val):
    val = float(val.get()) / float(100)
    val += float(1)
    val = val*96
    dpi = '-Gdpi=' + str(val)
    name = tkFileDialog.asksaveasfilename(filetypes=[('PNG','*.png')], title='Export Canvas to PNG', defaultextension='.png')
    if name:
        with open(name, 'w') as f:
            p = sub.Popen(['dot', (os.getenv('PROCDOTPLUGIN_GraphFileDot')), '-Tpng', (dpi), '-o', (name) ], stdout=sub.PIPE, stderr=sub.PIPE)
            p.wait()
    sys.exit(0)

def print_value(val, root):
    root.quit()

def on_closing(root):
    root.destroy()
    sys.exit(0)
    
def gui(tempFile):
    
    root = Tk()
    root.wm_iconbitmap(tempFile)
    root.title('Export Canvas to PNG')
    val = Scale(root, from_=0, to=200, length=300, label='Increase Canvas Size %', tickinterval=20, orient=HORIZONTAL)
    val.pack()    
    button_opt = {'padx': 5, 'pady': 5}
    Button(root, text='Save PNG', command=lambda:asksaveasfilename(val)).pack(**button_opt)
    root.bind("<Unmap>", lambda e: root.deiconify())
    root.protocol("WM_DELETE_WINDOW", lambda:on_closing(root))
    root.mainloop()

def main():
    tempFile = None
    tempFile = icon(tempFile)
    gui(tempFile)
    os.remove(tempFile)

if __name__ == '__main__':
    main()
