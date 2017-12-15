#!/usr/bin/env python

from Tkinter import *
import Tkconstants
import tkFileDialog
import os
import sys
import subprocess as sub
import base64

def asksaveasfilename(val):
    val = float(val.get()) / float(100)
    val += float(1)
    val = val*96
    dpi = '-Gdpi=' + str(val)
    print 'val = ',val
    print 'dpi = ',dpi
    name = tkFileDialog.asksaveasfilename(filetypes=[('PNG','*.png')], title='Export Canvas to PNG', defaultextension='.png')
    print 'name = ',name
    print 'GraphFileDot = ',os.getenv('PROCDOTPLUGIN_GraphFileDot')
    print 'Path2DotExecutable = ',os.getenv('PROCDOTPLUGIN_Path2DotExecutable')
    if name:
        with open(name, 'w') as f:
            p = sub.Popen([(os.getenv('PROCDOTPLUGIN_Path2DotExecutable')), (os.getenv('PROCDOTPLUGIN_GraphFileDot')), '-Tpng', (dpi), '-o', (name)], stdout=sub.PIPE, stderr=sub.PIPE)
            p.wait()
    sys.exit(0)

def on_closing(root):
    root.destroy()
    sys.exit(0)
    
def gui():
    
    root = Tk()
    root.title('Export Canvas to PNG')
    val = Scale(root, from_=0, to=200, length=300, label='Increase Canvas Size %', tickinterval=20, orient=HORIZONTAL)
    val.pack()    
    button_opt = {'padx': 5, 'pady': 5}
    Button(root, text='Save PNG', command=lambda:asksaveasfilename(val)).pack(**button_opt)
    root.bind("<Unmap>", lambda e: root.deiconify())
    root.protocol("WM_DELETE_WINDOW", lambda:on_closing(root))
    root.mainloop()

def main():

    gui()

if __name__ == '__main__':
    main()
