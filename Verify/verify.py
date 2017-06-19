#!/usr/bin/env python

import os
import sys
    
if os.getenv('PROCDOTPLUGIN_VerificationRun') == '0':

    pass
    
else:    
    if os.getenv('PROCDOTPLUGIN_CurrentNode_name')[:6] == 'SERVER':
        sys.exit(1)
    else:
        sys.exit(0)

def main():
    raw_input('Verification complete.')

if __name__ == '__main__':
    main()