#!/usr/bin/env python

import os
import sys

def printenv():
    for key in os.environ.keys():
        print "%s=%s \n" % (key,os.environ[key])

if len(sys.argv) == 1:
    os.system('python -i shell.py junk')

