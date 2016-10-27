#!/usr/bin/env python
#
# github pages allow directories to be navigated only if
# they contain an index.html file.
# This script traverses a directory tree starting at 'root',
# generating 'index.html' files with file (and directory) listings,
# unless the given directory already contains an 'index.html' file.

import os
from os.path import *
import sys
import datetime

if len(sys.argv) != 2:
    print('Usage: {} <root-directory>'.format(sys.argv[0]))
    sys.exit(-1)

# start the traversal here...
root = abspath(sys.argv[1])
# ...but print direcory names based on one level up (to include 'xsl/' etc.)
base = dirname(root)

def make_index(dir, dirs, files):
    filename = join(dir, 'index.html')
    if exists(filename):
        return
    with open(filename, 'w') as output:
        output.write("""<html><head>
<title>Index of %s</title>
<style>
table {{ width: 100%; font-family: monospace;}}
td {{ text-align: right}}
td:first-child {{ text-align: left}}
td:last-child {{ text-align: center}}
</style>
</head>
<body><h1>{}</h1>
<table>""".format(relpath(dir, base)))
        output.write('<tr><th>{}</th><th>{}</th><th>{}</th></tr>'.format("Name", "Size", "Last Modified"))
        output.write('<tr><td><a href="..">..</a>/</td><td></td><td></td></tr>')
        for d in dirs:
            s = os.stat(join(dir, d))
            format = '<tr><td><a href="{}">{}</a>/</td><td></td><td>{}</td></tr>'
            output.write(format.format(d, d, datetime.datetime.fromtimestamp(int(s.st_mtime))))
        for f in files:
            s = os.stat(join(dir, f))
            if s.st_size > 1073741824:
                size = '{} GB'.format(s.st_size / 1073741824)
            elif s.st_size > 1048576:
                size = '{} MB'.format(s.st_size / 1048576)
            elif s.st_size > 1024:
                size = '{} KB'.format(s.st_size / 1024)
            else:
                size = '{} &nbsp;&nbsp;'.format(s.st_size)
            format = '<tr><td><a href="{}">{}</a></td><td>{}</td><td>{}</td></tr>'
            output.write(format.format(f, f, size, datetime.datetime.fromtimestamp(int(s.st_mtime))))
        output.write("""</table>
</body>
</html>""")

def process(dir):
    all = os.listdir(dir)
    dirs = sorted([d for d in all if isdir(join(dir, d))])
    files = sorted([f for f in all if isfile(join(dir, f)) if f != 'index.html'])
    make_index(dir, dirs, files)
    # recurse into subdirectory, skipping links (such as 'current')
    for d in dirs:
        if not islink(join(dir, d)):
            process(join(dir, d))

process(root)
